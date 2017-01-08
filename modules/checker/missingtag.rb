#coding: utf-8

module Checker
  module CheckMissingTag
    def check_missingtag(segment)
      #check tag consistency
      #Tag definitions
      #TTX:      <ut .*?<\/ut>
      #XLZ:      <(?:x|bx|ex).*?\/(?:x|bx|ex)>|<\/?g.*?>
      #sdlxliff: {TAG}
      #Not Tag, Software Suffix ... : (?:\.\.\.)$
      #Not Tag, Software UI variables: \{[%&]?[a-zA-Z\d]+\}|$0xa$

      src_tags = segment[:source].to_s.downcase.scan(/(<ut .*?<\/ut>|<[^>]*?>|\\+n|\\+r|\\+d|\\+t|{\d+})/i)
      tgt_tags = segment[:target].to_s.downcase.scan(/(<ut .*?<\/ut>|<[^>]*?>|\\+n|\\+r|\\+d|\\+t|{\d+})/i)
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
    
  private
    #Refactoring required!!
    def comp_tags(src_tags, tgt_tags)
      src_tags.map{ |catch| remove_ut_ttx_tags!(catch)}
      tgt_tags.map{ |catch| remove_ut_ttx_tags!(catch)}

      src_tags.each_with_index{|e, i|
        pos = tgt_tags.index(e)
        next if pos == nil
        tgt_tags[pos] = nil
        src_tags[i] = nil
      }
      src_tags = src_tags.compact
      tgt_tags = tgt_tags.compact
      
      #以下、こういう例に対する対応
      #["&amp;lt;strong&amp;gt;","&amp;lt;/strong&amp;gt;&amp;amp;nbsp;","&amp;amp;nbsp;"]
      #["&amp;lt;strong&amp;gt;","&amp;lt;/strong&amp;gt;"]
      #不細工なのでリファクタリングする
      
      tgt_tags.each_with_index {|tgt_tag, i|
        src_tags.each_with_index {|src_tag, j|
          next if tgt_tag == nil || src_tag == nil
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

    def remove_ut_ttx_tags!(catched)
      # delete &amp; etc. to hide false errors
      str = catched[0].gsub!(/<\/*ut.*?>|&(?:amp|lt|gt|quot|ndash|apos);/,"")
      CGI.unescapeHTML(str) if str != nil
    end
  end
end
