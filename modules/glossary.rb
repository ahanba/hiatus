#coding: utf-8

class Glossary
  attr_accessor :terms
  #Glossary class has a collection of Term objects
  
  def initialize(glossArray, langs)
    @terms = []
    glossArray.map {|entry|
      @terms << Glossary::Term.new(entry, langs)
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
  #Term.src        = Source
  #Term.tgt        = Target
  #Term.message    = Message
  #Term.option     = RegExp option
  #Term.regSrc     = RegExp compiled Source
  #Term.regTgt     = RegExp compiled Target
   
  
  class Term
    include Converter
    
    attr_accessor :src, :tgt, :option, :message, :regSrc, :regTgt, :file
    
    def initialize(entry, langs)
      @src     = entry[:source]
      @tgt     = entry[:target]
      @option  = entry[:option]
      @message = entry[:message] if entry[:message]
      @file    = entry[:file]
      makeRegexp(@src, @tgt, @option, langs)
    end
  
  private
    OPS = { "i"   => Regexp::IGNORECASE,
            "m"   => Regexp::MULTILINE,
            "e"   => Regexp::EXTENDED,
            "im"  => Regexp::IGNORECASE | Regexp::MULTILINE,
            "mi"  => Regexp::IGNORECASE | Regexp::MULTILINE,
            "em"  => Regexp::EXTENDED | Regexp::MULTILINE,
            "me"  => Regexp::EXTENDED | Regexp::MULTILINE,
            "ie"  => Regexp::IGNORECASE | Regexp::EXTENDED,
            "ei"  => Regexp::IGNORECASE | Regexp::EXTENDED,
            "ime" => Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED,
            "iem" => Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED,
            "eim" => Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED,
            "emi" => Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED,
            "mie" => Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED,
            "mei" => Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED
    }
    
    def makeRegexp(src, tgt, option, langs)
      #Can be updated to cover different language conversion model
      if option =~ /^#/
        begin
          @regSrc = Regexp.compile(src, OPS[option.sub("#","")])
          @regTgt = Regexp.compile(tgt, OPS[option.sub("#","")])
        rescue
          raise RegexpError,"Can't convert \"#{src}\" to RegExp format. Check it on http://www.rubular.com"
        end
      elsif option == "z"
        @regSrc = Regexp.new(Regexp.escape(src), Regexp::IGNORECASE)
        @regTgt = Regexp.new(Regexp.escape(tgt), Regexp::IGNORECASE)
      elsif option != ""
        begin
          #����\�[�X���p��O��ɂȂ��Ă���̂ŁA����ɉ������R���o�[�W�����𑁂���������
          convertedSrc = self.send("convertEN", src)
          convertedTgt = self.send("convertEN", tgt)
          @regSrc = Regexp.compile(convertedSrc, OPS[option])
          @regTgt = Regexp.compile(convertedTgt, OPS[option])
        rescue RegexpError
          raise RegexpError,"Can't convert \"#{src}\" to RegExp format. Check it on http://www.rubular.com"
        end
      else
        @regSrc = Regexp.new(Regexp.escape(src))
        @regTgt = Regexp.new(Regexp.escape(tgt))
      end
      #p @regSrc
      #p @regTgt
    end
  end
end