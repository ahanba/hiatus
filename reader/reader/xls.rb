#coding: utf-8

module Reader
  module ReadXLS
    require 'reader/reader/core'
    include Core
    
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
          sheet.Cells(i, 1).value != nil ? entry[:source] = from_native_charset(sheet.Cells(i, 1).value.to_s) : entry[:source] = ""
          sheet.Cells(i, 2).value != nil ? entry[:target] = from_native_charset(sheet.Cells(i, 2).value.to_s) : entry[:target] = ""
          entry[:note]     = from_native_charset(sheet.Cells(i, 3).value) if sheet.Cells(i, 3).value != nil
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
