#coding: utf-8

module Checker
  module CheckSkip
    def check_skip(segment)
      if segment[:target] == ""
        error = {}
        error[:message]   = "Empty!"
        error[:found]     = "Target is empty"
        error[:bilingual] = segment
        @errors << error
      elsif segment[:source].remove_ttx_and_xliff_tags == segment[:target].remove_ttx_and_xliff_tags
        error = {}
        error[:message]   = "Skipped?"
        error[:found]     = "Target is same as the source"
        error[:bilingual] = segment
        @errors << error
      end
    end
  end
end
