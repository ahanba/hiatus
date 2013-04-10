#coding: utf-8

module Reader
  module ReadGloss
    require 'reader/reader/core'
    include Reader::Core
    
    #-----------------------------------
    #Methods to read bilingual & monolingual glossaries
    
    def readGloss(file)
      begin
        case File.extname(file).downcase
        when ".txt"
          i = 0
          file_str = read_rawfile(file)
          file_str.each_line {|line|
            i += 1
            next if line.start_with?('//') # skip a line starting with //
            split_line = line.split("\t")
            entry = {}
            entry[:source]  = split_line[0].chomp
            entry[:target]  = split_line[1].chomp
            entry[:option]  = split_line[2].chomp
            entry[:message] = split_line[3].chomp if split_line[3]
            entry[:file]    = File.basename(file)
            @@glossaryArray << entry
          }
        when ".tbx"
          @doc = Nokogiri::XML(File.open(file))
          @doc.xpath("////termEntry").each {|termEntry|
            i = 0
            entry = {}
            entry[:option] = "z"
            entry[:file]   = File.basename(file)
            
            termEntry.css('langSet tig term').map {|term|
              entry[:source] = term.inner_text if i == 0
              entry[:target] = term.inner_text if i == 1
              i += 1
            }
            #p entry
            @@glossaryArray << entry
          }
        end
      rescue NoMethodError
        puts "Error: Invalid entry found in the Glossry file. Check Line #{i} on #{File.basename(file)}."
        puts $!
        puts $!.name
        puts $!.args
      rescue IOError
        puts "Could not open #{File.basename(file)}."
      end
    end
    
    
    def readMonolingual(file)
      file_str = read_rawfile(file)
      begin
        i = 0
        file_str.each_line {|line|
          i += 1
          next if line.start_with?('//') # skip a line starting with //
          split_line = line.split("\t")
          entry = {}
          entry[:s_or_t]  = split_line[0].chomp
          if entry[:s_or_t] != "s" && entry[:s_or_t] != "t"
            puts "Error: Invalid entry found in the Monolingual file. Check Line #{i} on #{File.basename(file)}. 1st coulm should be \"s\" or \"t\""
          end
          entry[:term]    = split_line[1].chomp
          entry[:option]  = split_line[2].chomp
          entry[:message] = split_line[3].chomp if split_line[3]
          #entry[:file]   = File.basename(file)
          @@monolingualArray << entry
        }
      rescue NoMethodError
        puts "Error: Invalid entry found in the Monolingual file. Check Line #{i} on #{File.basename(file)}."
        puts $!
        puts $!.name
        puts $!.args
      rescue IOError
        puts "Cannot open #{File.basename(file)}."
      end
    end
    #------------------------------------
  end
end
