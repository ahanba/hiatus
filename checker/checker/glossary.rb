#coding: utf-8

module Checker
  module CheckGloss
    def check_glossary(segment)
      @glossary.each_term {|term|
        CGI.unescapeHTML(segment[:source].remove_ttx_innertext_and_xliff_tags).convEntity.scan(term.regSrc) {|found|
          next if CGI.unescapeHTML(segment[:target].remove_ttx_innertext_and_xliff_tags).convEntity[term.regTgt]
          error = {}
          error[:message]   = "Glossary"
          if term.message
            error[:found]   = found + " => " + term.message
          else
            error[:found]   = found if found.class == String
          end
          error[:glossary]  = term
          error[:bilingual] = segment
          #error[:pos]とerror[:length]を追加して、ヒット部分の文字色を変える？
          @errors << error
        }
      }
    end
  end
end
