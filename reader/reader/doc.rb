#coding: utf-8

module Reader
  module ReadDOC
    require 'reader/reader/core'
    include Core
    require 'tk'
   
    #For Word document
    def readDOC(file, option)
      word = WIN32OLE.new('Word.Application')
      word.visible = false
      
      file_path = getAbsolutePath(file)
      doc = word.Documents.Open(file_path)
      
      begin
        doc.Activate
        word.ActiveWindow.ActivePane.View.ShowAll = -1
        word.Selection.WholeStory
        word.Selection.Font.Reset
        word.Selection.Copy
        
        cont = NKF.nkf('-wxm0', TkClipboard.get)
        segments= cont.scan(/(?<={0>)(.*?)<}(\d+){>(.*?)(?=<0})/i)
        segments.map {|segment|
        if option[:ignore100] == true && segment[1] != nil
          next if segment[1] == "100"
        end
        entry = {}
        entry[:filename] = file.to_s
        entry[:source]   = segment[0]
        entry[:target]   = segment[2]
        entry[:note]     = segment[1] #this represents match percent
        @@bilingualArray.push(entry)
      }
        
      ensure
        doc.Close(:SaveChanges => 0)
        word.Quit(:SaveChanges => 0)
      end
      
    end
  end
end
