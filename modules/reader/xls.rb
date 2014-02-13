#coding: utf-8

module Reader
  module ReadXLS
    require 'modules/reader/core'
    include Reader::Core
    
    COL_SRC = 1
    COL_TGT = 2
    COL_NOT = 1
    
    #For Excel sheet. Only avaliable on Windows platform
    #target is default active sheet, col A as Source, col B as Target, col C as ID
    def readXLS(file, option)
      excel = WIN32OLE.new('Excel.Application')
      file_path = getAbsolutePath(file)
      book = excel.Workbooks.Open(file_path)
      sheet = book.ActiveSheet
      
      begin
        rowNum = sheet.Range("A65536").End(:Direction  =>  -4162).Row
        
        i = 0
        rowNum.times do
          i += 1
          entry = {}
          entry[:filename] = file.to_s
          sheet.Cells(i, COL_SRC).value != nil ? entry[:source] = sheet.Cells(i, COL_SRC).value.native_to_utf : entry[:source] = ""
          sheet.Cells(i, COL_TGT).value != nil ? entry[:target] = sheet.Cells(i, COL_TGT).value.native_to_utf : entry[:target] = ""
          sheet.Cells(i, COL_NOT).value != nil ? entry[:note] = sheet.Cells(i, COL_NOT).value.native_to_utf : entry[:note] = ""
          entry[:id]       = "Row #{i}"
          @@bilingualArray.push(entry)
        end
      ensure
        excel.Workbooks.Close
        excel.Quit
      end
      
    end
  end
end
