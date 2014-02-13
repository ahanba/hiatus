#coding: utf-8

module Reader
  module ReadTMX
    require 'modules/reader/core'
    include Reader::Core
    
    #For TMX
    def readTMX(file, option)
      @doc = Nokogiri::XML(open(file))
      tus = @doc.xpath("//tu")
      tus.each{ |tu|
        tuvs = tu.xpath('./tuv')
        entry = {}
        entry[:filename] = file.to_s
        entry[:source] = tuvs[0].at("./seg").inner_text
        entry[:target] = tuvs[1].at("./seg").inner_text
        @@bilingualArray.push(entry)
      }
    end
  end
end
