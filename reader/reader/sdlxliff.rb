#coding: utf-8

module Reader
  
  module ReadSDLXLIFF
    require 'reader/reader/core'
    include Core
    
    #For sdlxliff (Trados Studio) file
    def readSDLXLIFF(file, option)
      doc = Nokogiri::XML(File.open(file, "rb").read)
      tunits = doc.css('trans-unit')
      
      tunits.each {|tunit|
        next if (tunit.attribute('translate').value == 'no' if tunit.has_attribute?('translate'))
        mySource = tunit.at('seg-source')
        next if mySource.content == ""
        myTarget = tunit.at('target')
        myDef    = tunit.xpath('sdl:seg-defs', {'sdl' => 'http://sdl.com/FileTypes/SdlXliff/1.0'})
        
        mySource.css('mrk[mtype="seg"]').zip(myTarget.css('mrk[mtype="seg"]'), myDef.xpath('sdl:seg', {'sdl' => 'http://sdl.com/FileTypes/SdlXliff/1.0'})).each {|seg|
          if option[:filter] != nil
            #do something
          end
          
          if option[:ignore100] == true && seg[2].has_attribute?('percent')
            next if seg[2].attribute('percent').value =~ /100\.?0*/
          end
          if option[:ignoreICE] == true &&  seg[2].has_attribute?('locked')
            next if seg[2].attribute('locked').value.downcase == "true" || seg[2].attribute('origin-system').value = "Perfect Match"
          end
          entry = {}
          entry[:filename] = file.to_s
          entry[:source]   = seg[0].inner_html.convXLIFFtags
          entry[:target]   = seg[1].inner_html.convXLIFFtags
          entry[:id]       = seg[2].attribute('id').value if seg[2].has_attribute?('id')
          #this represents match percent
          entry[:note]     = seg[2].attribute('percent').value if seg[2].has_attribute?('percent')
          entry[:file]     = doc.at('file').attribute('original').value
          @@bilingualArray.push(entry)
        }
      }
    end
  end
end
