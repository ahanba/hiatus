#coding: utf-8

module Checker
  require 'ffi/aspell'
  
  module CheckSpell
    def check_spell(segments, langs)
      speller = FFI::Aspell::Speller.new("#{langs[:target]}")

      CGI.unescapeHTML(segment[:target].remove_ttx_innertext_and_xliff_tags).convEntity.scan(/[a-zA-Z\']+/) {|word|
        unless speller.correct?(word)
          error = {}
          error[:message]   = "Spell Error?"
          error[:found]     = "#{word} => #{speller.suggestions(word)[0..1].join(', ')}"
          error[:bilingual] = segment
          @errors << error
        end
      }
    end
    
    def collect_targets
      #correct target segments
      #split word by word
      #Make Hash {:word => [list of segemnt ID]}
    end
  end
end
