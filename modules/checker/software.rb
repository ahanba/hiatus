#coding: utf-8

module Checker
  module CheckSoftware
    def check_software(segment)
      CGI.unescapeHTML(segment[:source].remove_ttx_innertext_and_xliff_tags).convEntity.scan(/(\([A-Z]\)|(?:\.\.\.)$|[_&#%][A-Z]|\[?{\d+}\]?|\$0xa\$|\${[A-Z]+})/i){|match|
        next if CGI.unescapeHTML(segment[:target].remove_ttx_innertext_and_xliff_tags).convEntity[Regexp.new(Regexp.escape(match[0]), Regexp::IGNORECASE)]
        error = {}
        error[:message]   = "Hotkey Mismatch"
        error[:found]     = match
        error[:bilingual] = segment
        @errors << error
      }
      CGI.unescapeHTML(segment[:target].remove_ttx_innertext_and_xliff_tags).convEntity.scan(/(\([A-Z]\)|(?:\.\.\.)$|[_&#%][A-Z]|\[?{\d+}\]?|\$0xa\$|\${[A-Z]+})/i){|match|
        next if CGI.unescapeHTML(segment[:source].remove_ttx_innertext_and_xliff_tags).convEntity[Regexp.new(Regexp.escape(match[0]), Regexp::IGNORECASE)]
        error = {}
        error[:message]   = "Hotkey Mismatch"
        error[:found]     = match
        error[:bilingual] = segment
        @errors << error
      }
    end
  end
end
