#coding: utf-8

module Checker
  module GlossCheck
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
  end
end
