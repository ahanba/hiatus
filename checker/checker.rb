#coding: utf-8

# To DO:
# Need to re-arrange specific tag processing method for each file type (ttx, xlz, sdlxliff)

module Checker
  require 'checker/checker/glossary'
  require 'checker/checker/numbers'
  require 'checker/checker/missingtag'
  require 'checker/checker/skip'
  require 'checker/checker/monolingual'
  require 'checker/checker/unsourced'
  require 'checker/checker/length'
  require 'checker/checker/hotkey'
  require 'checker/checker/spell'
  require 'checker/checker/inconsistency'

  include Checker::CheckGloss
  include Checker::CheckNumbers
  include Checker::CheckMissingTag
  include Checker::CheckSkip
  include Checker::CheckMonolingual
  include Checker::CheckUnsourced
  include Checker::CheckLength
  include Checker::CheckHotkey
  include Checker::CheckSpell
  include Checker::CheckInconsistency
  
  include Reader
  include Writer
  require 'cgi'
  
  attr_accessor :glossary, :monolingual, :errors, :checks
  
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
  
  def initialize(bilingual_path, glossary_path, monolingual_path, ops, checks, langs)
    @checks = checks
    @langs  = langs
    
    Dir.glob(bilingual_path + "/**/{*.ttx,*.txt,*.csv,*.tmx,*xlz,*.xls,*.xlsx,*.doc,*.docx,*.rtf,*.tbx,*.sdlxliff}") {|file|
      filetype = check_extension(file)
      self.send("read#{filetype}", file, ops)
    }
    #@@bilungualArray is generated after readXXX processed.
    
    if @checks[:glossary]
      Dir.glob(glossary_path + "/**/{*.txt,*.tbx}") {|file|
        self.readGloss(file)
      }
      @glossary = Glossary.new(@@glossaryArray, langs) 
    end
    
    if @checks[:monolingual]
      Dir.glob(monolingual_path + "/**/*.txt") {|file|
        self.readMonolingual(file)
      }
      @monolingual = Monolingual.new(@@monolingualArray, langs)
    end
    
    @errors = []
  end
  
  #Run selected checks
  def run_checks
    @@bilingualArray.map {|segment|
      check_glossary(segment)      if @checks[:glossary]
      check_missingtag(segment)    if @checks[:missingtag]
      check_skip(segment)          if @checks[:skip]
      check_monolingual(segment)   if @checks[:monolingual]
      check_numbers(segment)       if @checks[:numbers]
      check_unsourced(segment)     if @checks[:unsourced]
      check_unsourced_rev(segment) if @checks[:unsourced_rev]
      check_length(segment)        if @checks[:length]
      check_hotkey(segment)        if @checks[:hotkey]
    }
    check_inconsistency_src2tgt(@@bilingualArray)  if @checks[:inconsistency_s2t]
    check_inconsistency_tgt2src(@@bilingualArray)  if @checks[:inconsistency_t2s]
    check_spell(@@bilingualArray, @langs)          if @checks[:spell]
  end
  
private
  def check_extension(file)
    ext = File.extname(file).downcase
    FILETYPE[ext]
  end
end
