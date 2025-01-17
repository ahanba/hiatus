#coding: utf-8
=begin
Environment:
Ruby 1.9.2 and higher
Windows only
=end

$LOAD_PATH << File.dirname(File.expand_path(__FILE__))

require 'modules/extend_string'
require 'modules/extend_nilclass'
require 'modules/glossary/converter'
require 'modules/glossary'
require 'modules/monolingual'
require 'modules/reader'
require 'modules/writer'
require 'modules/checker'

require 'yaml'

include Reader::Core

#For Windows XLS read/write, require win32ole
if(RUBY_PLATFORM.downcase =~ /mswin(?!ce)|mingw|cygwin|bccwin/)
  require 'win32ole'

  class WIN32OLE
    def fillColumns(array, row)
      array.each_with_index {|v, i|
        self.Cells.Item(row, i + 1).value = v
      }
     end
  end

  def getAbsolutePath(filename)
    fso = WIN32OLE.new('Scripting.FileSystemObject')
    return fso.GetAbsolutePathName(filename)
  end
end

myconfig = YAML.load(read_rawfile("config.yaml"))

#YAML data sample:
#{"required"=>
#  {"bilingual"=>"/Users/ahanba/Developer/Ruby/yyyyy/sample/bil",
#   "glossary"=>"/Users/ahanba/Developer/Ruby/yyyyy/sample/gloss",
#   "output"=>"/Users/ahanba/Developer/Ruby/yyyyy/sample",
#   "report"=>"XLS", "source"=>"en-us",
#   "target"=>"ja-jp"},
# "check"=>
#  {"glossary"=>true,
#   "inconsistency"=>false,
#   "missingtag"=>false,
#   "skip"=>false},
# "option"=>
#  {"filter_by"=>nil,
#   "ignore100"=>false}
#}

bilingual_path    = myconfig["required"]["bilingual"].gsub('\\','/').utf_to_native
output_path       = myconfig["required"]["output"].gsub('\\','/').utf_to_native
report_format     = myconfig["required"]["report"]
source_lang       = myconfig["required"]["source"]
target_lang       = myconfig["required"]["target"]
glossary_path     = myconfig["required"]["glossary"].gsub('\\','/').utf_to_native
monolingual_path  = myconfig["required"]["monolingual"].gsub('\\','/').utf_to_native
ignorelist_path   = (myconfig["option"]["ignorelist"] == nil ? nil : myconfig["option"]["ignorelist"].gsub('\\','/').utf_to_native)

puts "Checking Directories..."
[bilingual_path, output_path, glossary_path, monolingual_path].each { |myDir|
  unless myDir == nil or FileTest.directory?(myDir)
    puts "'#{myDir}' does not exist. Please check the path and try again."
    exit
  end
}

if ignorelist_path
  ignorelist_path.split(';').each {|mypath|
    unless FileTest.file?(mypath) || File.extname(mypath) == '.xlsx' || File.extname(mypath) == '.csv'
      puts "Invalid Ignore List: \"#{mypath}\" does not exist or is not a valid file. Supported file formats are XML, XLSX or CSV."
      exit
    end
  }
end

langs = {
  :source => source_lang,
  :target => target_lang
}

checks = {
  :glossary          => false,
  :inconsistency_s2t => false,
  :inconsistency_t2s => false,
  :missingtag        => false,
  :skip              => false,
  :identical         => false,
  :monolingual       => false,
  :numbers           => false,
  :unsourced         => false,
  :unsourced_rev     => false,
  :length            => false,
  :software          => false,
  :spell             => false
}

checks[:glossary]          = myconfig["check"]["glossary"]
checks[:inconsistency_s2t] = myconfig["check"]["inconsistency_s2t"]
checks[:inconsistency_t2s] = myconfig["check"]["inconsistency_t2s"]
checks[:missingtag]        = myconfig["check"]["missingtag"]
checks[:skip]              = myconfig["check"]["skip"]
checks[:identical]         = myconfig["check"]["identical"]
checks[:monolingual]       = myconfig["check"]["monolingual"]
checks[:numbers]           = myconfig["check"]["numbers"]
checks[:unsourced]         = myconfig["check"]["unsourced"]
checks[:unsourced_rev]     = myconfig["check"]["unsourced_rev"]
checks[:length]            = myconfig["check"]["length"]
checks[:software]          = myconfig["check"]["software"]
checks[:spell]             = myconfig["check"]["spell"]

options = {
  :filter     => myconfig["option"]["filter_by"],
  :ignore100  => myconfig["option"]["ignore100"],
  :ignoreICE  => myconfig["option"]["ignoreICE"],
  :ignorelist => ignorelist_path,
  :ignoreCase => myconfig["option"]["ignoreCase"],
  :ignoreTrailingSpace => myconfig["option"]["ignoreTrailingSpace"]
}

class MyChecker
  include Checker
end

mych = MyChecker.new(bilingual_path, glossary_path, monolingual_path, options, checks, langs)
mych.run_checks
puts "Generating Report..."
mych.send("report_#{report_format.upcase}", mych.errors, output_path, ignorelist_path)
