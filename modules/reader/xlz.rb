#coding: utf-8

module Reader
  module ReadXLZ
    require 'modules/reader/core'
    include Reader::Core
    
    #For XLZ (Idiom) file
    def readXLZ(file, option)
      buf = ""
      Zip::ZipInputStream.open(file) {|zis|
        entry = zis.get_next_entry
        next if File.extname(entry.name) != ".xlf"
        buf = zis.read
      }
      tf = Tempfile.new("buf")
      tf.print buf
      tf.close
      
      str_xslted = %x(./modules/reader/xml tr ./modules/reader/xlf2tsv.xsl #{tf.path})
      tf.close!
      #str_xslted = Kconv.kconv(str_xslted, Kconv::UTF8, guess_encode(str_xslted))
      str_xslted = NKF.nkf('-wxm0', str_xslted)
      
      ops = {:col_sep => "\t", :quote_char => '"', :headers => true}
      myCSV = CSV.new(str_xslted, ops)
      myCSV.each {|row|
        #p row["tm_score"]
        #p row["match-quality"]
        if option[:filter] != nil
          next if row["Note"] != option[:filter]
          # ---  Use following if you filter with "include?" method. ---
          #next if row["Note"].to_s.include?(option[:filter])
        end
        if option[:ignore100] == true
          next if row["tm_score"] =~ /100\.?0*/
        end
        if option[:ignoreICE] == true
          next if row["match-quality"] == "guaranteed"
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
