#coding: utf-8

class Glossary
  attr_accessor :terms
  
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
  #This class has each entry of source, target and regexp version source
  #Glossary class has an array of Term class object
  class Term
    include Converter
    attr_accessor :src, :tgt, :option, :regSrc
    
    def initialize(entry)
      @src    = entry[:source]
      @tgt    = entry[:target]
      @option = entry[:option]
      makeRegexp(convertEN(@src), @option) #convertEN
    end
  
  private
    def makeRegexp(src, option)
      begin
        ops = { "i" => Regexp::IGNORECASE,
                "m" => Regexp::MULTILINE,
                "e" => Regexp::EXTENDED
              }
        @regSrc = Regexp.compile(src, ops[option])
      rescue RegexpError
        raise RegexpError,"Can't convert \"#{src}\" to RegExp format. Check it with http://www.rubular.com"
      end
    end
  end
end