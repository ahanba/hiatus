#coding: utf-8

module Reader
  module ReadTBX
    require 'reader/reader/core'
    include Core
    
    def readTBX(file, option)
      @doc = Nokogiri::XML(File.open(file))
      @doc.xpath("////termEntry").each {|termEntry|
        i = 0
        entry = {}
        entry[:filename] = file.to_s
        
        termEntry.css('langSet tig term').map {|term|
          entry[:source] = term.inner_text if i == 0
          entry[:target] = term.inner_text if i == 1
          i += 1
        }
        #p entry
        @@bilingualArray.push(entry)
      }
    end
  end
end
