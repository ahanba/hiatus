#coding: utf-8

module Checker
  module CheckSkip
    def check_skip(segment)
      if segment[:target] == ""
        error = {}
        error[:message]   = "Empty"
        error[:found]     = "Target is empty"
        error[:bilingual] = segment
        @errors << error
      end
    end
  end
end
