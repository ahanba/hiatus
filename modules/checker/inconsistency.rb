#coding: utf-8

module Checker
  module CheckInconsistency
    def check_inconsistency_src2tgt(segments, options)
      #check source->target inconsistency
      check_inconsistency(segments, :source, :target, options)
    end
    
    def check_inconsistency_tgt2src(segments, options)
      #check target->source inconsistency
      check_inconsistency(segments, :target, :source, options)
    end
    
  private
    def check_inconsistency(segments, symbol1, symbol2, options)
      #get type of options
      type = 1
      
      if options[:ignoreCase]
        if options[:ignoreTrailingSpace]
          type = 1 #ignore case + ignore space
        else
          type = 2 #ignore case + not ignore space
        end
      else
        if options[:ignoreTrailingSpace]
          type = 3 #not ignore case + ignore space
        else
          type = 4 #not ignore case + not ignore space
        end
      end
      
      #select method
      case type
      when 1
        inconsistency1(segments, symbol1, symbol2)
      when 2
        inconsistency2(segments, symbol1, symbol2)
      when 3
        inconsistency3(segments, symbol1, symbol2)
      when 4
        inconsistency4(segments, symbol1, symbol2)
      end
    end
    
    #ignore case + ignore space
    def inconsistency1(segments, symbol1, symbol2)
      incon = {}
      
      segments.map{|segment|
        rawSrc = segment[symbol1].remove_ttx_innertext_and_xliff_tags.strip.downcase
        rawTgt = segment[symbol2].remove_ttx_innertext_and_xliff_tags.strip.downcase
        
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
      
      incon.each {|str, value|
        forms = value[0].uniq
        next if value[2] == 1 || forms.length == 1
        
        colorIndex = [5,1,8,6,3,10,9]
        
        value[1].map{|segment|
          error = {}
          error[:message]   = "Inconsistent \(#{symbol1.to_s}->#{symbol2.to_s}\)"
          error[:found]     = "Inconsistent \(#{symbol1.to_s}->#{symbol2.to_s}\)"
          error[:bilingual] = segment
          error[:color] = colorIndex[forms.index(segment[symbol2].remove_ttx_innertext_and_xliff_tags.strip.downcase) % colorIndex.length]
          
          @errors << error
        }
      }
    end
    
    #ignore case + not ignore space
    def inconsistency2(segments, symbol1, symbol2)
      incon = {}
      
      segments.map{|segment|
        rawSrc = segment[symbol1].remove_ttx_innertext_and_xliff_tags.downcase
        rawTgt = segment[symbol2].remove_ttx_innertext_and_xliff_tags.downcase
        
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
      
      incon.each {|str, value|
        forms = value[0].uniq
        next if value[2] == 1 || forms.length == 1
        
        colorIndex = [5,1,8,6,3,10,9]
        
        value[1].map{|segment|
          error = {}
          error[:message]   = "Inconsistent \(#{symbol1.to_s}->#{symbol2.to_s}\)"
          error[:found]     = "Inconsistent \(#{symbol1.to_s}->#{symbol2.to_s}\)"
          error[:bilingual] = segment
          error[:color] = colorIndex[forms.index(segment[symbol2].remove_ttx_innertext_and_xliff_tags.downcase) % colorIndex.length]
          
          @errors << error
        }
      }
    end
    
    #not ignore case + ignore space
    def inconsistency3(segments, symbol1, symbol2)
      incon = {}
      
      segments.map{|segment|
        rawSrc = segment[symbol1].remove_ttx_innertext_and_xliff_tags.strip
        rawTgt = segment[symbol2].remove_ttx_innertext_and_xliff_tags.strip
        
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
      
      incon.each {|str, value|
        forms = value[0].uniq
        next if value[2] == 1 || forms.length == 1
        
        colorIndex = [5,1,8,6,3,10,9]
        
        value[1].map{|segment|
          error = {}
          error[:message]   = "Inconsistent \(#{symbol1.to_s}->#{symbol2.to_s}\)"
          error[:found]     = "Inconsistent \(#{symbol1.to_s}->#{symbol2.to_s}\)"
          error[:bilingual] = segment
          error[:color] = colorIndex[forms.index(segment[symbol2].remove_ttx_innertext_and_xliff_tags.strip) % colorIndex.length]
          
          @errors << error
        }
      }
    end
    
    #not ignore case + not ignore space
    def inconsistency4(segments, symbol1, symbol2)
      incon = {}
      
      segments.map{|segment|
        rawSrc = segment[symbol1].remove_ttx_innertext_and_xliff_tags
        rawTgt = segment[symbol2].remove_ttx_innertext_and_xliff_tags
        
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
      
      incon.each {|str, value|
        forms = value[0].uniq
        next if value[2] == 1 || forms.length == 1
        
        colorIndex = [5,1,8,6,3,10,9]
        
        value[1].map{|segment|
          error = {}
          error[:message]   = "Inconsistent \(#{symbol1.to_s}->#{symbol2.to_s}\)"
          error[:found]     = "Inconsistent \(#{symbol1.to_s}->#{symbol2.to_s}\)"
          error[:bilingual] = segment
          error[:color] = colorIndex[forms.index(segment[symbol2].remove_ttx_innertext_and_xliff_tags) % colorIndex.length]
          
          @errors << error
        }
      }
    end
  end
end
