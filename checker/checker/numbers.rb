#coding: utf-8

module Checker
  module CheckNumbers
    def check_numbers(segment)
      CGI.unescapeHTML(segment[:source].remove_ttx_innertext_and_xliff_tags).convEntity.scan(/(\d+[\d ,\.]*\d|\d)/) {|found|
        #あとでリファクタリングする！
        if found[0] == "1"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(1|一|one|single)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        elsif found[0] == "2"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(2|二|two|double)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end	
        elsif found[0] == "3"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(3|三|three)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        elsif found[0] == "4"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(4|四|four)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        elsif found[0] == "5"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(5|五|five)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        elsif found[0] == "6"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(6|六|six)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        elsif found[0] == "7"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(7|七|seven)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        elsif found[0] == "8"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(8|八|eight)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        elsif found[0] == "9"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(9|九|nine)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        elsif found[0] == "0"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(0|ゼロ|零|zero)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        elsif found[0] == "10"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(10|十|ten)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        elsif found[0] == "100"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(100|百|hundred)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        elsif found[0] == "1000"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(1,000|1 000|1000|千|thousand)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        elsif found[0] == "10000"
          unless segment[:target].remove_ttx_innertext_and_xliff_tags =~ /(10,000|10 000|10000|万)/i
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        else
          num_forms = []
          num_forms << found[0]
          num_forms << found[0].gsub(",","")
          num_forms << found[0].gsub(" ","")
          num_forms << found[0].reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
          num_forms << found[0].reverse.gsub(/(\d{3})(?=\d)/, '\1 ').reverse
          unless (segment[:target].remove_ttx_innertext_and_xliff_tags.scan(/(#{num_forms.uniq.join("|")})/) != [])
            error = {}
            error[:message]   = "Missing Number?"
            error[:found]     = "#{found[0]} is not found in the target"
            error[:bilingual] = segment
            @errors << error
          end
        end
      }
    end
  end
end
