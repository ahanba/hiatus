#coding: utf-8
=begin
Developed environment
Ruby 1.9.2
Windows XP SP2 Japanese
Note that this script does not work with Ruby 1.8.7 or earlier
=end

$LOAD_PATH << File.dirname(File.expand_path(__FILE__))

require 'glossary/converter'
require 'glossary/glossary'
require 'glossary/monolingual'
require 'reader/reader'
require 'writer/writer'
require 'checker/checker'

require 'yaml'

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

myconfig = YAML.load_file("config.yaml")

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

bilingual_path    = myconfig["required"]["bilingual"].gsub('\\','/').tosjis
output_path       = myconfig["required"]["output"].gsub('\\','/').tosjis
report_format     = myconfig["required"]["report"]
source_lang       = myconfig["required"]["source"]
target_lang       = myconfig["required"]["target"]
glossary_path     = myconfig["required"]["glossary"].gsub('\\','/').tosjis
monolingual_path  = myconfig["required"]["monolingual"].gsub('\\','/').tosjis


checks = {
  :glossary          => false,
  :inconsistency_s2t => false,
  :inconsistency_t2s => false,
  :missingtag        => false,
  :skip              => false,
  :monolingual       => false,
  :numbers           => false,
  :unsourced         => false,
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
checks[:length]            = myconfig["check"]["length"]

option = {
  :filter     => myconfig["option"]["filter_by"],
  :ignore_100 => myconfig["option"]["ignore100"]
}

class MyChecker
  include Checker
end

mych = MyChecker.new(bilingual_path, glossary_path, monolingual_path, option, checks)
mych.run_checks
mych.send("report_#{report_format.upcase}", mych.errors, output_path)
