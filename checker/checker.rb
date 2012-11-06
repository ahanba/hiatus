#coding: utf-8

# To DO:
# Need to separate/create each tag processing method for each file type (ttx, xlz, sdlxliff)
# 

class Object
  def ignore_ttx_tags
    #remove "<df...>", "</df>" and "<ut ...>", "</ut>" tags
    self.to_s.gsub(/(<\/*df.*?>|<\/*ut.*?>)/, "")
  end
  
  def remove_DF_UT
    #remove "<df...>", "</df>" and "<ut .... >...  </ut>" tags 
    #include the text between <ut> & </ut> tags. That is different from ignore_ttx_tags
    self.to_s.gsub(/<\/*?df.*?>/,"").gsub(/<ut.*?<\/ut>/,"")
  end
end

module Checker
  include Reader
  include Writer
  require 'cgi'
  
  attr_accessor :glossary, :monolingual, :errors, :checks
  
  FILETYPE = {".ttx"  => "TTX",
              ".txt"  => "TXT",
              ".csv"  => "CSV",
              ".tmx"  => "TMX",
              ".xlz"  => "XLZ",
              ".xls"  => "XLS",
              ".xlsx" => "XLS",
              ".doc"  => "DOC",
              ".docx" => "DOC",
              ".rtf"  => "DOC",
              ".sdlxliff"  => "SDLXLIFF",
              ".tbx"  => "TBX"
  }
  
  def initialize(bilingual_path, glossary_path, monolingual_path, ops, checks, langs)
    @checks = checks
    
    Dir.glob(bilingual_path + "/**/{*.ttx,*.txt,*.csv,*.tmx,*xlz,*.xls,*.xlsx,*.doc,*.docx,*.rtf,*.tbx,*.sdlxliff}") {|file|
      filetype = check_extension(file)
      self.send("read#{filetype}", file, ops)
    }
    #@@bilungualArray is generated after readXXX processed.
    
    if @checks[:glossary]
      Dir.glob(glossary_path + "/**/{*.txt,*.tbx}") {|file|
        self.readGloss(file)
      }
      @glossary = Glossary.new(@@glossaryArray, langs) 
    end
    
    if @checks[:monolingual]
      Dir.glob(monolingual_path + "/**/*.txt") {|file|
        self.readMonolingual(file)
      }
      @monolingual = Monolingual.new(@@monolingualArray, langs)
    end
    
    @errors = []
  end
  
  #Run selected checks
  def run_checks
    @@bilingualArray.map {|segment|
      glossary_check(segment)      if @checks[:glossary]
      missingtag_check(segment)    if @checks[:missingtag]
      skip_check(segment)          if @checks[:skip]
      monolingual_check(segment)   if @checks[:monolingual]
      check_numbers(segment)       if @checks[:numbers]
      check_unsourced(segment)     if @checks[:unsourced]
      check_unsourced_rev(segment) if @checks[:unsourced_rev]
      check_length(segment)        if @checks[:length]
    }
    inconsistency_src2tgt_check  if @checks[:inconsistency_s2t]
    inconsistency_tgt2src_check  if @checks[:inconsistency_t2s]
  end
  
  #------------------------------------
  #define each check method from here
  #
  
  def glossary_check(segment)
    @glossary.each_term {|term|
      CGI.unescapeHTML(segment[:source].remove_DF_UT).scan(term.regSrc) {|found|
        next if CGI.unescapeHTML(segment[:target].remove_DF_UT)[term.regTgt]
        error = {}
        error[:message]   = "Glossary"
        error[:found]     = found
        error[:glossary]  = term
        error[:bilingual] = segment
        #error[:pos]とerror[:length]を追加して、ヒット部分の文字色を変える？
        @errors << error
      }
    }
  end
  
  def missingtag_check(segment)
    #check tag consistency
    #Tag definitions
    #TTX:      <ut .*?<\/ut>
    #XLZ:      \{\d+\}
    #sdlxliff: <x +id\="[\S\d]+"\/>
    
    src_tags = segment[:source].to_s.scan(/(<ut .*?<\/ut>|\{\d+\}|<x +id\="[\S\d]+"\/>)/)
    tgt_tags = segment[:target].to_s.scan(/(<ut .*?<\/ut>|\{\d+\}|<x +id\="[\S\d]+"\/>)/)
    deleted_tags, added_tags  = comp_tags(src_tags, tgt_tags)
    
    if deleted_tags != []
      deleted_tags.each { |tag|
        next if tag[0] == ""
        error = {}
        error[:message]   = "Deleted Tag"
        error[:found]     = CGI.unescapeHTML(tag[0])
        error[:bilingual] = segment
        @errors << error
      }
    end
    
    if added_tags != []
      added_tags.each { |tag|
        next if tag[0] == ""
        error = {}
        error[:message]   = "Added Tag"
        error[:found]     = CGI.unescapeHTML(tag[0])
        error[:bilingual] = segment
        @errors << error
      }
    end
  end
  
  def inconsistency_src2tgt_check
    #check source->target inconsistency
    inconsistency_check(:source, :target)
  end
  
  def inconsistency_tgt2src_check
    #check target->source inconsistency
    inconsistency_check(:target, :source)
  end
  
  def skip_check(segment)
    if segment[:target] == ""
      error = {}
      error[:message]   = "Empty!"
      error[:found]     = "Target is empty"
      error[:bilingual] = segment
      @errors << error
    elsif segment[:source].ignore_ttx_tags == segment[:target].ignore_ttx_tags
      error = {}
      error[:message]   = "Skipped?"
      error[:found]     = "Target is same as the source"
      error[:bilingual] = segment
      @errors << error
    end
  end
  
  def monolingual_check(segment)
    @monolingual.each_term {|term|
      if term.s_or_t.downcase == "s"
        CGI.unescapeHTML(segment[:source].remove_DF_UT).scan(term.regTerm) {|found|
          next if found == []
          error = {}
          error[:message]   = "Found in the Source"
          if term.message
            error[:found]   = found[0] + " => " + term.message if found.class == Array
            error[:found]   = found + " => " + term.message if found.class == String
          else
            error[:found]   = found[0] if found.class == Array
            error[:found]   = found[0] if found.class == String
          end
          error[:bilingual] = segment
          @errors << error
        }
      end
      if term.s_or_t.downcase == "t"
        CGI.unescapeHTML(segment[:target].remove_DF_UT).scan(term.regTerm) {|found|
          next if found == []
          error = {}
          error[:message]   = "Found in the Target"
          if term.message
            error[:found]   = found[0] + " => " + term.message if found.class == Array
            error[:found]   = found + " => " + term.message if found.class == String
          else
            error[:found]   = found[0] if found.class == Array
            error[:found]   = found[0] if found.class == String
          end
          error[:bilingual] = segment
          @errors << error
        }
      end
    }
  end
  
  def check_length(segment)
    src_length = CGI.unescapeHTML(segment[:source].remove_DF_UT).length
    tgt_length = CGI.unescapeHTML(segment[:target].remove_DF_UT).length
    if tgt_length/src_length.to_f >= 2
      error = {}
      error[:message]   = "Too long?"
      error[:found]     = "Target length is more than 200%"
      error[:bilingual] = segment
      @errors << error
    elsif tgt_length/src_length.to_f <= 0.5 
      error = {}
      error[:message]   = "Too short?"
      error[:found]     = "Target length is less than 50%"
      error[:bilingual] = segment
      @errors << error
    end
  end
  
  def check_unsourced(segment)
    #check unsourced English terms. Only valid when the target language is non-alphabet one
    unsourced_template(segment, :target, :source)
  end
  
  def check_unsourced_rev(segment)
    #check unsourced English terms. Only valid when the source language is non-alphabet one
    unsourced_template(segment, :source, :target)
  end
  
  def check_numbers(segment)
    CGI.unescapeHTML(segment[:source].remove_DF_UT).scan(/(\d+[\d ,\.]*\d|\d)/) {|found|
      #あとでリファクタリングする！
      if found[0] == "1"
        unless segment[:target].remove_DF_UT =~ /(1|一|one)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      elsif found[0] == "2"
        unless segment[:target].remove_DF_UT =~ /(2|二|two)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      elsif found[0] == "3"
        unless segment[:target].remove_DF_UT =~ /(3|三|three)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      elsif found[0] == "4"
        unless segment[:target].remove_DF_UT =~ /(4|四|four)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      elsif found[0] == "5"
        unless segment[:target].remove_DF_UT =~ /(5|五|five)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      elsif found[0] == "6"
        unless segment[:target].remove_DF_UT =~ /(6|六|six)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      elsif found[0] == "7"
        unless segment[:target].remove_DF_UT =~ /(7|七|seven)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      elsif found[0] == "8"
        unless segment[:target].remove_DF_UT =~ /(8|八|eight)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      elsif found[0] == "9"
        unless segment[:target].remove_DF_UT =~ /(9|九|nine)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      elsif found[0] == "0"
        unless segment[:target].remove_DF_UT =~ /(0|ゼロ|零|zero)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      elsif found[0] == "10"
        unless segment[:target].remove_DF_UT =~ /(10|十|ten)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      elsif found[0] == "100"
        unless segment[:target].remove_DF_UT =~ /(100|百|hundred)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      elsif found[0] == "1000"
        unless segment[:target].remove_DF_UT =~ /(1,000|1 000|1000|千|thousand)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      elsif found[0] == "10000"
        unless segment[:target].remove_DF_UT =~ /(10,000|10 000|10000|万)/i
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      else
        num_forms = []
        num_forms << found[0]
        num_forms << found[0].gsub(",","")
        num_forms << found[0].gsub(" ","")
        num_forms << found[0].reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
        num_forms << found[0].reverse.gsub(/(\d{3})(?=\d)/, '\1 ').reverse
        unless (segment[:target].remove_DF_UT.scan(/(#{num_forms.uniq.join("|")})/) != [])
          error = {}
          error[:message]   = "Missing Number?"
          error[:found]     = "#{found[0]} is not found in the target"
          error[:bilingual] = segment
          @errors << error
        end
      end
    }
  end
  
private
  def check_extension(file)
    ext = File.extname(file).downcase
    FILETYPE[ext]
  end
  
  #Hard to read... Need refactoring
  def comp_tags(src_tags, tgt_tags)
    src_tags.map{ |catch| remove_UT!(catch)}
    tgt_tags.map{ |catch| remove_UT!(catch)}
    
    src_tags.each_with_index{|e, i|
      pos = tgt_tags.index(e)
      next if pos == nil
      tgt_tags[pos] = nil
      src_tags[i] = nil
    }
    src_tags = src_tags.compact
    tgt_tags = tgt_tags.compact
    
    #p src_tags
    #p tgt_tags
    
    #以下、こういう例に対する対応
    #["&amp;lt;strong&amp;gt;","&amp;lt;/strong&amp;gt;&amp;amp;nbsp;","&amp;amp;nbsp;"]
    #["&amp;lt;strong&amp;gt;","&amp;lt;/strong&amp;gt;"]
    #不細工なのでリファクタリングする
    
    tgt_tags.each_with_index {|tgt_tag, i|
      src_tags.each_with_index {|src_tag, j|
        next if tgt_tag[0] == nil || src_tag[0] == nil
        if src_tag[0].include?(tgt_tag[0])
          src_tags[j][0].sub!(tgt_tag[0], "")
          tgt_tags[i] = nil
          next
        end
        if tgt_tag[0].include?(src_tag[0])
          tgt_tags[i][0].sub!(src_tag[0], "")
          src_tags[j] = nil
          next
        end
      }
    }
    
    #p src_tags.compact
    #p tgt_tags.compact
    return src_tags.compact, tgt_tags.compact
  end
  
  def remove_UT(catched)
    CGI.unescapeHTML(catched[0].gsub(/<\/*ut.*?>/,""))
  end
  
  def remove_UT!(catched)
    str = catched[0].gsub!(/<\/*ut.*?>/,"")
    CGI.unescapeHTML(str) if str != nil
  end
  
  def inconsistency_check(symbol1, symbol2)
    incon = {}
    @@bilingualArray.map{|segment|
      rawSrc = segment[symbol1].remove_DF_UT
      rawTgt = segment[symbol2].remove_DF_UT
      if incon.has_key?(rawSrc)
        incon[rawSrc][0] << rawTgt
        incon[rawSrc][1] << segment
        incon[rawSrc][2] += 1
      else
        incon[rawSrc] = []
        incon[rawSrc] << [rawTgt]
        incon[rawSrc] << [segment]
        incon[rawSrc] << 1
      end
    }
    
    incon.map {|str, value|
      forms = value[0].uniq
      next if value[2] == 1 || forms.length == 1
      
      colorIndex = [9,1,7,5,10,8,6]
      
      value[1].map{|segment|
        error = {}
        error[:message]   = "Inconsistent \(#{symbol1.to_s}->#{symbol2.to_s}\)"
        error[:found]     = "Inconsistent \(#{symbol1.to_s}->#{symbol2.to_s}\)"
        error[:bilingual] = segment
        error[:color] = colorIndex[(forms.index(segment[:"#{symbol2}"].remove_DF_UT)) % colorIndex.length]
        @errors << error
      }
    }
  end
  
  def unsourced_template(segment, symbol1, symbol2)
    enu_terms = CGI.unescapeHTML(segment[symbol1].remove_DF_UT).scan(/([@a-zA-Z][@\.a-zA-Z\d ]*[@\.a-zA-Z\d]|[@a-zA-Z])/)
    enu_terms.map {|enu_term|
      conv_enu = Regexp.compile(Regexp.escape(enu_term[0]), Regexp::IGNORECASE)
      next if CGI.unescapeHTML(segment[symbol2].remove_DF_UT)[conv_enu]
      error = {}
      error[:message]   = "Unsourced"
      error[:found]     = "\"#{enu_term[0]}\" not found in the #{symbol2.to_s}"
      error[:bilingual] = segment
      #error[:pos]とerror[:length]を追加して、ヒット部分の文字色を変える？
      @errors << error
    }
  end
end
