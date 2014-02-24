#coding: utf-8

module Checker
  module CheckIdentical
    def check_identical(segment)
      if segment[:source].remove_ttx_innertext_and_xliff_tags == segment[:target].remove_ttx_innertext_and_xliff_tags
        error = {}
        error[:message]   = "Identical"
        error[:found]     = "Target is same as the source"
        error[:bilingual] = segment
        @errors << error
      end
    end
  end
end
