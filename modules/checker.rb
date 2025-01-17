#coding: utf-8

module Checker
  require 'cgi'

  require 'modules/checker/glossary'
  require 'modules/checker/identical'
  require 'modules/checker/numbers'
  require 'modules/checker/missingtag'
  require 'modules/checker/skip'
  require 'modules/checker/monolingual'
  require 'modules/checker/unsourced'
  require 'modules/checker/length'
  require 'modules/checker/software'
  #require 'modules/checker/spell'
  require 'modules/checker/inconsistency'

  include Checker::CheckGloss
  include Checker::CheckIdentical
  include Checker::CheckNumbers
  include Checker::CheckMissingTag
  include Checker::CheckSkip
  include Checker::CheckMonolingual
  include Checker::CheckUnsourced
  include Checker::CheckLength
  include Checker::CheckSoftware
  #include Checker::CheckSpell
  include Checker::CheckInconsistency

  include Reader
  include Writer

  attr_accessor :glossary, :monolingual, :errors, :options, :checks, :langs

  FILETYPE = {".ttx"       => "TTX",
              ".txt"       => "TXT",
              ".csv"       => "CSV",
              ".tmx"       => "TMX",
              ".xlz"       => "XLZ",
              ".xls"       => "XLS",
              ".xlsx"      => "XLS",
              ".doc"       => "DOC",
              ".docx"      => "DOC",
              ".rtf"       => "DOC",
              ".sdlxliff"  => "SDLXLIFF",
              ".tbx"       => "TBX"
  }

  def initialize(bilingual_path, glossary_path, monolingual_path, options, checks, langs)
    @options = options
    @checks  = checks
    @langs   = langs

    puts "Reading Files..."
    Dir.glob(bilingual_path + "/**/{*.ttx,*.txt,*.csv,*.tmx,*xlz,*.xls,*.xlsx,*.doc,*.docx,*.rtf,*.tbx,*.sdlxliff}") {|file|
      filetype = check_extension(file)
      self.send("read#{filetype}", file, options)
    }
    #@@bilungualArray is generated after readXXX processed.
    #See modules/reader/core.rb

    if @checks[:glossary]
      Dir.glob(glossary_path + "/**/{*.txt,*.tbx}") {|file|
        puts "Reading #{File.basename(file)}"
        self.readGloss(file)
      }
      @glossary = Glossary.new(@@glossaryArray, langs)
    end

    if @checks[:monolingual]
      Dir.glob(monolingual_path + "/**/*.txt") {|file|
        puts "Reading #{File.basename(file)}"
        self.readMonolingual(file)
      }
      @monolingual = Monolingual.new(@@monolingualArray, langs)
    end

    @errors = []
  end

  #Run selected checks
  def run_checks
    #for debug
    #f = File.open("foo","w:utf-8")
    #f.puts(@@bilingualArray)
    puts "Total Segments: #{@@bilingualArray.length}\nRunning Checks..."
    @@bilingualArray.each {|segment|
      check_glossary(segment)      if @checks[:glossary]
      check_missingtag(segment)    if @checks[:missingtag]
      check_skip(segment)          if @checks[:skip]
      check_identical(segment)     if @checks[:identical]
      check_monolingual(segment)   if @checks[:monolingual]
      check_numbers(segment)       if @checks[:numbers]
      check_unsourced(segment)     if @checks[:unsourced]
      check_unsourced_rev(segment) if @checks[:unsourced_rev]
      check_length(segment)        if @checks[:length]
      check_software(segment)      if @checks[:software]
    }
    check_inconsistency_src2tgt(@@bilingualArray, @options)  if @checks[:inconsistency_s2t]
    check_inconsistency_tgt2src(@@bilingualArray, @options)  if @checks[:inconsistency_t2s]
    #check_spell(@@bilingualArray, @langs)                    if @checks[:spell]
  end

private
  def check_extension(file)
    ext = File.extname(file).downcase
    FILETYPE[ext]
  end
end
