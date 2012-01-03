#coding: utf-8

class String
  def ignoretags
    self.gsub(/<.*?>/, "")
  end
end

module Checker
  include Reader
  include Writer
  require 'cgi'
  
  attr_accessor :bilingual, :glossary, :errors
  
  FILETYPE = {".ttx" => "TTX",
              ".txt" => "TXT",
              ".csv" => "CSV",
              ".tsv" => "TSV"
  }
  
  def initialize(bilingual_path, glossary_path, ops)
    Dir.glob(bilingual_path + "/**/{*.ttx,*.tsv,*.txt,*csv}") {|file|
      filetype = check_extension(file)
      self.send("read#{filetype}", file, ops)
    }
    @bilingual = @@bilingualArray
    
    Dir.glob(glossary_path + "/**/*.txt") {|file|
      self.readGloss(file)
    }
    @glossary = Glossary.new(@@glossaryArray)
    
    @errors = []
  end
  
  def glossary_check
    @glossary.each_term{|term|
      @bilingual.map {|segment|
        CGI.unescapeHTML(segment[:source].ignoretags).scan(term.regSrc) {|found|
          next if segment[:target].ignoretags.include?(term.tgt)
          error = {}
          error[:message]   = "Glossary"
          error[:found]     = found
          error[:glossary]  = term
          error[:bilingual] = segment
          @errors << error
        }
      }
    }
    return @errors
  end
  
  def inconsistency_check
    #check source-target inconsistency
    #読み取り時に inconsistency 用の Array も作成して、それをソートして前後比較 each_con
    return @errors
  end
  
  def missingtag_check
    #check tag consistency
    @bilingual.map {|segment|
      segment[:source].ignoretags.scan(/(&lt;(.*?)&gt;.*?&lt;\/\2&gt;)/) {|found|
        #これだと、ひとつでも入っていればクリアしてしまう。数も確認しないといけない。
        segment[:target].include?(found[0])
        error = {}
        error[:message]   = "MissingTag"
        error[:found]     = found
        error[:bilingual] = segment
        @errors << error
      }
    }
    return @errors
  end
  
  def skip_check
    #check source is same as target
    return @errors
  end
  
private
  def check_extension(file)
    ext = File.extname(file).downcase
    FILETYPE[ext]
  end
end
