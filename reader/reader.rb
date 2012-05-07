#coding: utf-8

module Reader
  require 'kconv'
  require 'csv'
  require 'nkf'
  require 'nokogiri'
  require 'zip/zip'
  require 'shell'
  require 'tempfile'
  
  require 'reader/reader/gloss'
  require 'reader/reader/xlz'
  require 'reader/reader/txt'
  require 'reader/reader/csv'
  require 'reader/reader/ttx'
  require 'reader/reader/tmx'
  require 'reader/reader/xls'
  require 'reader/reader/doc'
  require 'reader/reader/tbx'
  
  include ReadGloss
  include ReadCSV
  include ReadTMX
  include ReadTTX
  include ReadTXT
  include ReadXLS
  include ReadXLZ
  include ReadDOC
  include ReadTBX
end
