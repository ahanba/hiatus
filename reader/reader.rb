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
  require 'reader/reader/sdlxliff'
  
  include Reader::ReadGloss
  include Reader::ReadCSV
  include Reader::ReadTMX
  include Reader::ReadTTX
  include Reader::ReadTXT
  include Reader::ReadXLS
  include Reader::ReadXLZ
  include Reader::ReadDOC
  include Reader::ReadTBX
  include Reader::ReadSDLXLIFF
end
