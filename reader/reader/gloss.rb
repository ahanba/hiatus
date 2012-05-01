#coding: utf-8

module Reader
  module ReadGloss
    require 'reader/reader/core'
    include Core
    
    #-----------------------------------
    #Methods to read bilingual & monolingual glossaries
    
    def readGloss(file)
      file_str = read_rawfile(file)
      begin
        i = 0
        file_str.each_line {|line|
          i += 1
          split_line = line.split("\t")
          entry = {}
          entry[:source] = split_line[0].chomp
          entry[:target] = split_line[1].chomp
          entry[:option] = split_line[2].chomp
          entry[:file]   = File.basename(file)
          @@glossaryArray << entry
        }
      rescue NoMethodError
        puts "##Error##\nInvalid entry found while reading Glossary file.\nCheck Line #{i} on #{File.basename(file)}."
      rescue IOError
        puts "Cannot open #{File.basename(file)}."
      end
    end
    
    
    def readMonolingual(file)
      file_str = read_rawfile(file)
      begin
        i = 0
        file_str.each_line {|line|
          i += 1
          split_line = line.split("\t")
          entry = {}
          entry[:s_or_t]  = split_line[0].chomp
          if entry[:s_or_t] != "s" && entry[:s_or_t] != "t"
            puts "##Error##\nInvalid entry found while reading Monolingual file.\nCheck Line #{i} on #{File.basename(file)}. 1st coulm should be \"s\" or \"t\""
          end
          entry[:term]    = split_line[1].chomp
          entry[:option]  = split_line[2].chomp
          entry[:message] = split_line[3].chomp if split_line[3]
          #entry[:file]   = File.basename(file)
          @@monolingualArray << entry
        }
      rescue NoMethodError
        puts "##Error##\nInvalid entry found while reading Monolingual file.\nCheck Line #{i} on #{File.basename(file)}."
      rescue IOError
        puts "Cannot open #{File.basename(file)}."
      end
    end
    #------------------------------------
  end
end
