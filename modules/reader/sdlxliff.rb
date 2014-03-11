#coding: utf-8

module Reader
  
  module ReadSDLXLIFF
    require 'modules/reader/core'
    include Reader::Core
    
    def readSDLXLIFF(file, option)
      doc = Nokogiri::XML(open(file))
      #f = File.open("log", "wb")
      tag_ref = {}
      tags = doc.xpath('//sdl:tag', {'sdl' => 'http://sdl.com/FileTypes/SdlXliff/1.0'})
      tags.map{|tag|
        #When <ph> and <st>: This is for <x>, <ex>, <bx> tags in SDLXLIFF
        #Storinng opening and closing tags together
        #["id" => "concatenated_tags"]
        if tag.xpath('sdl:bpt|sdl:ept', {'sdl' => 'http://sdl.com/FileTypes/SdlXliff/1.0'}).empty?
          tag_ref[tag.attribute('id').value] = tag.xpath('sdl:ph|sdl:st', {'sdl' => 'http://sdl.com/FileTypes/SdlXliff/1.0'}).inner_text
        #
        #When <bpt> and <ept>: This is for <g> tag in SDLXLIFF
        #Keeping opening and closing tags separately
        #["id" => ["opening_tag", "closing_tag"]]
        #Removing <sub ...xid ...> by using inner_text method to process cases like following:
        #<a href="../../p15646299.html" title="
        #<sub xid="acce6450-4359-4745-b4b9-8e7a55b22e8e">Chapter4 Hello World</sub>
        #">
        else
          tag_ref[tag.attribute('id').value] = [tag.xpath('sdl:bpt', {'sdl' => 'http://sdl.com/FileTypes/SdlXliff/1.0'}).inner_text, tag.xpath('sdl:ept', {'sdl' => 'http://sdl.com/FileTypes/SdlXliff/1.0'}).inner_text]
        end
      }
      #tag_ref.each{|k,v|
      #  f.print "#{k}\t#{v}\n"
      #}
      
      tunits = doc.css('trans-unit')
      tunits.each {|tunit|
        next if (tunit.attribute('translate').value == 'no' if tunit.has_attribute?('translate'))
        mySource = tunit.at('seg-source')
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
          entry[:source]   = restore_original_tags(seg[0].inner_html.remove_mrk_xliff_tags, tag_ref)
          entry[:target]   = restore_original_tags(seg[1].inner_html.remove_mrk_xliff_tags, tag_ref)
          entry[:id]       = seg[2].attribute('id').value if seg[2].has_attribute?('id')
          #this represents match percent
          entry[:note]     = seg[2].attribute('percent').value if seg[2].has_attribute?('percent')
          entry[:file]     = doc.at('file').attribute('original').value
          @@bilingualArray.push(entry)
        }
      }
    end
    
    def restore_original_tags(str, tag_ref)
      #For <x>, <bx>, <ex> tags
      str = str.gsub(/<([eb]?)x.*?id="([\S\d]+?)".*?\/\1x>/im){
              tag_ref[$2]
            }
      #f.puts str
      #For <g> tag. <g> can be nested. Get the shortest <g>...</g> which is not nested.
      while str.scan(/<g[^>]*?id="[\S\d]+?"[^>]*?>.*?<\/g>/im) != []
        str = str.sub(/^(.*)<g[^>]*?id="([\S\d]+?)"[^>]*?>(.*?)<\/g>(.*?)$/im){
                $1 + tag_ref[$2][0] + $3 + tag_ref[$2][1] + $4
              }
      end
      #f.puts str
      return str
    end
  end
end
