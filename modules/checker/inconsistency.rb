#coding: utf-8

module Checker
  module CheckInconsistency
    def check_inconsistency_src2tgt(segments)
      #check source->target inconsistency
      check_inconsistency(segments, :source, :target)
    end

    def check_inconsistency_tgt2src(segments)
      #check target->source inconsistency
      check_inconsistency(segments, :target, :source)
    end
    
  private
    def check_inconsistency(segments, symbol1, symbol2)
      incon = {}
      segments.map{|segment|
        #ignore leading and trailing spaces with rstrip method
        rawSrc = segment[symbol1].remove_ttx_innertext_and_xliff_tags.rstrip
        rawTgt = segment[symbol2].remove_ttx_innertext_and_xliff_tags.rstrip
        
        #do not ignore leading and trailing spaces 
        #rawSrc = segment[symbol1].remove_ttx_innertext_and_xliff_tags
        #rawTgt = segment[symbol2].remove_ttx_innertext_and_xliff_tags
        if incon.has_key?(rawSrc)
          incon[rawSrc][0] << rawTgt
          incon[rawSrc][1] << segment
          incon[rawSrc][2] += 1
        else
          incon[rawSrc] = []
          incon[rawSrc] << [rawTgt]
          incon[rawSrc] << [segment]
          incon[rawSrc] << 1
        end
      }

      incon.map {|str, value|
        forms = value[0].uniq
        next if value[2] == 1 || forms.length == 1

        colorIndex = [5,1,8,6,3,10,9]

        value[1].map{|segment|
          error = {}
          error[:message]   = "Inconsistent \(#{symbol1.to_s}->#{symbol2.to_s}\)"
          error[:found]     = "Inconsistent \(#{symbol1.to_s}->#{symbol2.to_s}\)"
          error[:bilingual] = segment
          #rstripつけたとき
          error[:color] = colorIndex[(forms.index(segment[:"#{symbol2}"].remove_ttx_innertext_and_xliff_tags.rstrip)) % colorIndex.length]
          #error[:color] = colorIndex[(forms.index(segment[:"#{symbol2}"].remove_ttx_tags_and_innertext)) % colorIndex.length]
          @errors << error
        }
      }
    end
  end
end
