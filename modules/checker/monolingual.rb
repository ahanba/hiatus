#coding: utf-8

module Checker
  module CheckMonolingual
    def check_monolingual(segment)
      @monolingual.each_term {|term|
        if term.s_or_t.downcase == "s"
          CGI.unescapeHTML(segment[:source].remove_ttx_innertext_and_xliff_tags).convEntity.scan(term.regTerm) {|found|
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
            error[:mololingual] = term
            error[:bilingual]   = segment
            @errors << error
          }
        end
        if term.s_or_t.downcase == "t"
          CGI.unescapeHTML(segment[:target].remove_ttx_innertext_and_xliff_tags).convEntity.scan(term.regTerm) {|found|
            next if found == []
            error = {}
            error[:message]   = "Found in the Target"
            #Use (?: ) fo regExp
            if term.message
              error[:found]   = found[0] + " => " + term.message if found.class == Array
              error[:found]   = found + " => " + term.message if found.class == String
            else
              error[:found]   = found[0] if found.class == Array
              error[:found]   = found if found.class == String
            end
            error[:mololingual] = term
            error[:bilingual]   = segment
            @errors << error
          }
        end
      }
    end
  end
end
