#coding: utf-8

#For Windows XLS output format, require win32ole
if(RUBY_PLATFORM.downcase =~ /mswin(?!ce)|mingw|cygwin|bccwin/)
  require 'win32ole'
  
  class WIN32OLE
    def fillColumns(array, row)
      array.each_with_index {|v, i|
        self.Cells.Item(row, i + 1).value = v
      }
     end
  end
end


module Writer
  require 'haml'
  require 'sass'
  require 'kconv'
  
  def report_HTML(errors, output_path)
    
  end
  
  #For XLS report, only available on Windows with Excel installed
  def getAbsolutePath(filename)
    fso = WIN32OLE.new('Scripting.FileSystemObject')
    return fso.GetAbsolutePathName(filename)
  end
  
  def report_XLS(errors, output_path)
    excel = WIN32OLE.new('Excel.Application')
    t = Time.now.strftime("%y%m%d")
    myreport = output_path + "/#{t}_report.xlsx"
    
    begin
      book = excel.Workbooks.Add()
      sheet = book.Sheets("sheet1")
      
      header = ["File","Path","ErrorType","Source","Target", "Note","id","FoundTerm", "GlossarySrc", "GlossaryTgt", "InternalFile", "Fixed?"]
      sheet.fillColumns(header, 1)
      
      row = 1
      errors.map {|error|
        row += 1
        col = 1
        fullpath = File.expand_path(error[:bilingual][:filename])
        dir      = File.dirname(error[:bilingual][:filename])
        base     = File.basename(error[:bilingual][:filename])
        sheet.Cells(row, col).value = "=HYPERLINK(\"#{fullpath}\",\"#{base}\")"
        sheet.Cells(row, col + 1).value = dir
        sheet.Cells(row, col + 2).value = error[:message]
        sheet.Cells(row, col + 3).value = error[:bilingual][:source].ignoretags
        sheet.Cells(row, col + 4).value = error[:bilingual][:target].ignoretags
        sheet.Cells(row, col + 5).value = error[:bilingual][:note] if error[:bilingual][:note]
        sheet.Cells(row, col + 6).value = error[:bilingual][:id] if error[:bilingual][:id]
        sheet.Cells(row, col + 7).value = error[:found]
        sheet.Cells(row, col + 8).value = error[:glossary].src
        sheet.Cells(row, col + 9).value = error[:glossary].tgt
        sheet.Cells(row, col + 10).value = error[:bilingual][:file] if error[:bilingual][:file]
      }
      
    #Font/Color/Filter etc.
    sheet.Cells.Font.Name = "Tahoma"
    sheet.Cells.Font.Size = 9
    
    sheet.Rows("1:1").Select
    excel.Selection.Font.Bold = "True"
    excel.Selection.AutoFilter
    
    sheet.Rows("2:2").Select
    excel.ActiveWindow.FreezePanes = "True"
    
    sheet.Columns("D:E").Select
    excel.Selection.ColumnWidth = "50"
    excel.Selection.WrapText = "True"
    
    col = "A"
    ((header.length) - 1).times do; col.succ!; end
    sheet.Columns("A:#{col}").Select
    excel.Selection.Columns.AutoFit
    
    #Border
    [1, 2, 3, 4].map {|i|
      sheet.Range("A1:#{col}#{row}").Select
      excel.Selection.Borders(i).Linestyle = 1
    }
    
    myreport = myreport.tosjis
    book.SaveAs(getAbsolutePath(myreport))
    ensure
      excel.Workbooks.Close
      excel.Quit
    end
  end
  
end