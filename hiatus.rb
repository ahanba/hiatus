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
require 'reader/reader'
require 'writer/writer'
require 'checker/checker'

require 'yaml'

myconfig = YAML.load_file("config.yaml")

CHECKTYPE = {
  :glossary      => false,
  :inconsistency => false,
  :missingtag    => false,
  :skip          => false
}

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

bilingual_path = myconfig["required"]["bilingual"].gsub('\\','/').tosjis
glossary_path  = myconfig["required"]["glossary"].gsub('\\','/').tosjis
output_path    = myconfig["required"]["output"].gsub('\\','/').tosjis
report_format  = myconfig["required"]["report"]

CHECKTYPE[:glosssary]     = myconfig["check"]["glossary"]
CHECKTYPE[:inconsistency] = myconfig["check"]["inconsistency"]
CHECKTYPE[:missingtag]    = myconfig["check"]["missingtag"]
CHECKTYPE[:skip]          = myconfig["check"]["skip"]

option = {
  :filter     => myconfig["option"]["filter_by"],
  :ignore_100 => myconfig["option"]["ignore100"]
}

class MyChecker
  include Checker
end

mych = MyChecker.new(bilingual_path, glossary_path, option)

mych.glossary_check      if CHECKTYPE[:glosssary]
mych.inconsistency_check if CHECKTYPE[:inconsistency]
mych.missingtag_check    if CHECKTYPE[:missingtag]
mych.skip_check          if CHECKTYPE[:skip]

mych.send("report_#{report_format.upcase}", mych.errors, output_path)
