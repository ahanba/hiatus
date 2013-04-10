#coding: utf-8

module Checker
  module CheckLength
    def check_length(segment)
      src_length = CGI.unescapeHTML(segment[:source].remove_ttx_innertext_and_xliff_tags).length
      tgt_length = CGI.unescapeHTML(segment[:target].remove_ttx_innertext_and_xliff_tags).length
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
  end
end
