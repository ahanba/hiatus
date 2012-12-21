#coding: utf-8
=begin
Developed environment
Ruby 1.9.2 or 1.9.3
Windows XP SP2, Windows 7
Note that this script does not work on Ruby 1.8.7 or earlier
=end

$LOAD_PATH << File.dirname(File.expand_path(__FILE__))

require 'glossary/converter/converter'
require 'glossary/glossary'
require 'glossary/monolingual'
require 'reader/reader'
require 'writer/writer'
require 'checker/checker'
require 'iconv'

require 'yaml'
include Reader::Core


CODE = Encoding.locale_charmap

def to_native_charset(str)
  Iconv.conv(CODE, "UTF-8", str)
end

def from_native_charset(str)
  Iconv.conv("UTF-8", CODE, str)
end

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

#YAML data is like this:
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

bilingual_path    = to_native_charset(myconfig["required"]["bilingual"].gsub('\\','/'))
output_path       = to_native_charset(myconfig["required"]["output"].gsub('\\','/'))
report_format     = myconfig["required"]["report"]
source_lang       = myconfig["required"]["source"]
target_lang       = myconfig["required"]["target"]
glossary_path     = to_native_charset(myconfig["required"]["glossary"].gsub('\\','/'))
monolingual_path  = to_native_charset(myconfig["required"]["monolingual"].gsub('\\','/'))

puts "checking directories..."
[bilingual_path, output_path, glossary_path, monolingual_path].each { |myDir|
  unless FileTest.directory?(myDir)
    puts "'#{myDir}' does not exist. Should be existing directory, please fix and try again."
    exit
  end
}

langs = {
  :sourceL => source_lang,
  :targetL => target_lang
}

checks = {
  :glossary          => false,
  :inconsistency_s2t => false,
  :inconsistency_t2s => false,
  :missingtag        => false,
  :skip              => false,
  :monolingual       => false,
  :numbers           => false,
  :unsourced         => false,
  :unsourced_rev     => false,
  :length            => false
} 

checks[:glossary]          = myconfig["check"]["glossary"]
checks[:inconsistency_s2t] = myconfig["check"]["inconsistency_s2t"]
checks[:inconsistency_t2s] = myconfig["check"]["inconsistency_t2s"]
checks[:missingtag]        = myconfig["check"]["missingtag"]
checks[:skip]              = myconfig["check"]["skip"]
checks[:monolingual]       = myconfig["check"]["monolingual"]
checks[:numbers]           = myconfig["check"]["numbers"]
checks[:unsourced]         = myconfig["check"]["unsourced"]
checks[:unsourced_rev]     = myconfig["check"]["unsourced_rev"]
checks[:length]            = myconfig["check"]["length"]

option = {
  :filter    => myconfig["option"]["filter_by"],
  :ignore100 => myconfig["option"]["ignore100"],
  :ignoreICE => myconfig["option"]["ignoreICE"]
}

class MyChecker
  include Checker
end

puts "reading files..."
mych = MyChecker.new(bilingual_path, glossary_path, monolingual_path, option, checks, langs)
puts "running checks..."
mych.run_checks
puts "generating report..."
mych.send("report_#{report_format.upcase}", mych.errors, output_path)
