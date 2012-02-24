#coding: utf-8

class Glossary
  attr_accessor :terms
  #Glossary class has a collection of Term objects
  
  def initialize(glossArray)
    @terms = []
    glossArray.map {|entry|
      @terms << Glossary::Term.new(entry)
    }
  end
  
  def each_term(&block)
    self.terms.each {|t| 
      block.call(t)
    }
  end
  
  #Term class
  #This class has each entry of source, target and each regexp version
  #Glossary class has an array of Term class object
  #
  #Term.src    = Source
  #Term.tgt    = Target
  #Term.option = RegExp option
  #Term.regSrc = RegExp compiled Source
  #Term.regTgt = RegExp compiled Target
  #Term.file   = Glossary file name
  
  class Term
    include Converter
    attr_accessor :src, :tgt, :option, :regSrc, :regTgt, :file
    
    def initialize(entry)
      @src    = entry[:source]
      @tgt    = entry[:target]
      @option = entry[:option]
      @file   = entry[:file]
      makeRegexp(@src, @tgt, @option)
    end
  
  private
    def makeRegexp(src, tgt, option)
      #Can be updated to cover different language conversion model
      convertedSrc = self.send("convertEN", src)
      if option != ""
        begin
          ops = { "i"   => Regexp::IGNORECASE,
                  "m"   => Regexp::MULTILINE,
                  "e"   => Regexp::EXTENDED,
                  "im"  => Regexp::IGNORECASE | Regexp::MULTILINE,
                  "em"  => Regexp::EXTENDED | Regexp::MULTILINE,
                  "ie"  => Regexp::IGNORECASE | Regexp::EXTENDED,
                  "ime" => Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED 
          }
          @regSrc = Regexp.compile(convertedSrc, ops[option])
          @regTgt = Regexp.compile(tgt, ops[option])
        rescue RegexpError
          raise RegexpError,"Can't convert \"#{src}\" to RegExp format. Check it with http://www.rubular.com"
        end
      else
        @regSrc = Regexp.escape(src)
        @regTgt = Regexp.escape(tgt)
      end
      #For testing
      #p @regSrc
      #p @regTgt
    end
  end
end