#coding: utf-8

module Reader
  module ReadTTX
    require 'reader/reader/core'
    include Reader::Core
    
    #For Trados TTX file
    def readTTX(file, option)
      file_str = read_rawfile(file)
      scannedttx = file_str.scan(/<tu(.*?MatchPercent="([\d\.]+)")?.*?<tuv.*?>(.*?)<\/tuv><tuv.*?>(.*?)<\/tuv><\/tu>/i)
      scannedttx.map {|tu|
        if option[:ignoreICE] == true && tu[0] != nil
          next if tu[0].include?('Origin="xtranslate"')
        end
        if option[:ignore100] == true && tu[1] != nil
          next if tu[1] == "100"
        end
        entry = {}
        entry[:filename] = file.to_s
        entry[:source]   = tu[2]
        entry[:target]   = tu[3]
        entry[:note]     = tu[1] #this represents match percent
        @@bilingualArray.push(entry)
      }
    end
  end
end
