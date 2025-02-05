#coding: utf-8

module Checker
  require 'ffi/aspell'

  module CheckSpell
    def check_spell(segments, langs)
      speller = FFI::Aspell::Speller.new("#{langs[:target]}")

      word_list = Hash::new
      segments.each_with_index {|segment, i|
        words = CGI.unescapeHTML(segment[:target].remove_ttx_innertext_and_xliff_tags).convEntity.scan(/[a-zA-Z_&]+?[a-z_&]+/)
        words.each {|word|
          case word_list.has_key?(word)
          when true
            word_list[word] << i
          when false
            word_list[word] = []
            word_list[word] << i
          end
        }
      }
      puts "Number of Unique Words: #{word_list.length}"

      word_list.each {|word, segment_indices|
        word = word.gsub(/[&_]/,'') # remove hotkey indicator
        next if word == word.upcase # ignore if all characters are capitalized (= constant)
        unless speller.correct?(word)
          error_msg = speller.suggestions(word)[0..1].join(', ')
          segment_indices.map {|segment_index|
            error = {}
            error[:message]   = "Spell Error?"
            error[:found]     = "#{word} => #{error_msg}"
            error[:bilingual] = segments[segment_index]
            @errors << error
          }
        end
      }
    end
  end
end
