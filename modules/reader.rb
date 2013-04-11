#coding: utf-8

module Reader
  #equire 'kconv'
  require 'csv'
  require 'nkf'
  require 'nokogiri'
  require 'zip/zip'
  require 'shell'
  require 'tempfile'
  
  require 'modules/reader/gloss'
  require 'modules/reader/xlz'
  require 'modules/reader/txt'
  require 'modules/reader/csv'
  require 'modules/reader/ttx'
  require 'modules/reader/tmx'
  require 'modules/reader/xls'
  require 'modules/reader/doc'
  require 'modules/reader/tbx'
  require 'modules/reader/sdlxliff'
  
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
