#coding: utf-8

module Reader
  module ReadSDLXLIFF
    require 'reader/reader/core'
    include Core
    
    #For sdlxliff (Trados Studio) file
    def readSDLXLIFF(file, option)
      str_xslted = %x(./reader/reader/xml tr ./reader/reader/sdlxliff2tsv.xsl #{file})
      str_xslted = NKF.nkf('-wx', str_xslted)
      
      ops = {:col_sep => "\t", :quote_char => '"', :headers => true}
      myCSV = CSV.new(str_xslted, ops)
      myCSV.each {|row|
        #p row["Source"]
        #p row["tm_score"]
        #p row["match-quality"]
        next if row["Source"] == "" && row["Target"] == ""
        if option[:filter] != nil
          next if row["Note"] != option[:filter]
          # ---  Use following if you filter with "include?" method. ---
          #next if row["Note"].to_s.include?(option[:filter])
        end
        if option[:ignore100] == true
          next if row["tm_score"] =~ /100\.?0*/
        end
        if option[:ignoreICE] == true
          next if row["match-quality"] == "Perfect Match"
        end
        entry = {}
        entry[:filename] = file.to_s
        entry[:source]   = row["Source"]
        entry[:target]   = row["Target"]
        entry[:id]       = row["SID"]
        entry[:note]     = row["tm_score"]
        entry[:file]     = row["File"]
        @@bilingualArray.push(entry)
      }
    end
  end
end
