#coding: utf-8

module Checker
  module CheckHotkey
    def check_hotkey(segment)
      CGI.unescapeHTML(segment[:source].remove_ttx_innertext_and_xliff_tags).convEntity.scan(/(\([A-Z]\)|(?<=\()[_&]?[A-Z](?=\)))/i){|key|
        next if CGI.unescapeHTML(segment[:target].remove_ttx_innertext_and_xliff_tags).convEntity[Regexp.new(Regexp.escape(key[0]), Regexp::IGNORECASE)]
        error = {}
        error[:message]   = "Hotkey Mismatch"
        error[:found]     = key
        error[:bilingual] = segment
        @errors << error
      }
    end
  end
end
