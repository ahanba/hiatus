#coding: utf-8

module Checker
  module CheckUnsourced
    def check_unsourced(segment)
      #check unsourced English terms. Only valid when the target language is non-alphabet one
      unsourced_template(segment, :target, :source)
    end

    def check_unsourced_rev(segment)
      #check unsourced English terms. Only valid when the source language is non-alphabet one
      unsourced_template(segment, :source, :target)
    end
    
  private
    def unsourced_template(segment, symbol1, symbol2)
      enu_terms = CGI.unescapeHTML(segment[symbol1].remove_ttx_innertext_and_xliff_tags).convEntity.scan(/([@a-zA-Z][@\.a-zA-Z\d ]*[@\.a-zA-Z\d]|[@a-zA-Z])/)
      enu_terms.map {|enu_term|
        conv_enu = Regexp.compile(Regexp.escape(enu_term[0]), Regexp::IGNORECASE)
        next if CGI.unescapeHTML(segment[symbol2].remove_ttx_innertext_and_xliff_tags).convEntity[conv_enu]
        error = {}
        error[:message]   = "Unsourced"
        error[:found]     = "\"#{enu_term[0]}\" not found in the #{symbol2.to_s}"
        error[:bilingual] = segment
        #error[:pos]とerror[:length]を追加して、ヒット部分の文字色を変える？
        @errors << error
      }
    end
  end
end
