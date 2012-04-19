#coding: utf-8

class Monolingual
  attr_accessor :terms
  #Monolingual class has a collection of Term objects
  
  def initialize(monoArray, langs)
    @terms = []
    monoArray.map {|entry|
      @terms << Monolingual::Term.new(entry, langs)
    }
  end
  
  def each_term(&block)
    self.terms.each {|t| 
      block.call(t)
    }
  end
  
  #Term class (monolingual)
  #This class has each entry of source, target and each regexp version
  #Glossary class has an array of Term class object
  #
  #Term.s_or_t    = Specify whether Source or Target
  #Term.term      = Target
  #Term.option    = RegExp option
  #Term.regTerm   = RegExp compiled Source
  
  class Term
    include Converter
    attr_accessor :s_or_t, :term, :option, :regTerm, :message
    
    def initialize(entry, langs)
      @s_or_t  = entry[:s_or_t]
      @term    = entry[:term]
      @option  = entry[:option]
      @message = entry[:message] if entry[:message]
      makeRegexp(@term, @option, langs)
    end
  
  private
    
    OPS = { "i"   => Regexp::IGNORECASE,
            "m"   => Regexp::MULTILINE,
            "e"   => Regexp::EXTENDED,
            "im"  => Regexp::IGNORECASE | Regexp::MULTILINE,
            "em"  => Regexp::EXTENDED | Regexp::MULTILINE,
            "ie"  => Regexp::IGNORECASE | Regexp::EXTENDED,
            "ime" => Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED 
    }
    
    def makeRegexp(term, option, langs)
      #Can be updated to cover different language conversion model
      convertedTerm = self.send("convertEN", term)
      
      if option =~ /^#/
        begin
          @regTerm = Regexp.compile(term, OPS[option.sub("#","")])
        rescue
          raise RegexpError,"Can't convert \"#{term}\" to RegExp format. Check it with http://www.rubular.com"
        end
      elsif option != ""
        begin
          @regTerm = Regexp.compile(convertedTerm, OPS[option])
        rescue RegexpError
          raise RegexpError,"Can't convert \"#{term}\" to RegExp format. Check it with http://www.rubular.com"
        end
      else
        @regTerm = Regexp.escape(term)
      end
      
    end
  end
end