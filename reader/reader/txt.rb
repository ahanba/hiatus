#coding: utf-8

module Reader
  module ReadTXT
    require 'reader/reader/core'
    include Reader::Core
    
    #For simple tab separated values. Like copy & pasted from Excel sheet
    def readTXT(file, option)
      file_str = read_rawfile(file)
      file_str.lines.each_with_index {|line, i|
        entry = {}
        entry[:filename] = file.to_s
        ch_line = line.chomp.split("\t")
        entry[:source]   = ch_line[0]
        entry[:target]   = ch_line[1]
        entry[:id]       = ch_line[2] if ch_line[2] != (nil && "")
        entry[:note]       = "Line: #{i + 1}"
        @@bilingualArray.push(entry)
      }
    end
  end
end
