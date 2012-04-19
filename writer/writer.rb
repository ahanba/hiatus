#coding: utf-8
  
module Writer
  #require 'haml'
  #require 'sass'
  require 'kconv'
  require 'cgi'
  
  def report_HTML(errors, output_path)
    
  end
  
  #For XLS report, only available on Windows with Excel installed
  def report_XLS(errors, output_path)
    excel = WIN32OLE.new('Excel.Application')
    t = Time.now.strftime("%y%m%d")
    myreport = output_path + "/#{t}_report.xlsx"
    
    begin
      book = excel.Workbooks.Add()
      sheet = book.Sheets("sheet1")
      
      header = ["File","Path","ErrorType","Source","Target", "Match","id","Message/FoundTerm", "GlossarySrc", "GlossaryTgt", "GlossFile", "Asset", "Fixed?"]
      sheet.fillColumns(header, 1)
      
      row = 1
      errors.map {|error|
        row += 1
        col = 1
        fullpath = File.expand_path(error[:bilingual][:filename])
        dir      = File.dirname(error[:bilingual][:filename])
        base     = File.basename(error[:bilingual][:filename])
        sheet.Cells(row, col).value      = "=HYPERLINK(\"#{fullpath}\",\"#{base}\")"
        sheet.Cells(row, col + 1).value  = dir
        sheet.Cells(row, col + 2).value  = error[:message]
        sheet.Cells(row, col + 3).value  = CGI.unescapeHTML(error[:bilingual][:source].ignore_ttx_tags)
        sheet.Cells(row, col + 4).value  = CGI.unescapeHTML(error[:bilingual][:target].ignore_ttx_tags)
        if error[:color]
          sheet.Cells(row, col + 3).Interior.ThemeColor = error[:color]
          sheet.Cells(row, col + 4).Interior.ThemeColor = error[:color]
        end
        sheet.Cells(row, col + 5).value  = error[:bilingual][:note] if error[:bilingual][:note]
        sheet.Cells(row, col + 6).value  = error[:bilingual][:id]   if error[:bilingual][:id]
        sheet.Cells(row, col + 7).value  = error[:found]
        sheet.Cells(row, col + 8).value  = error[:glossary].src  if error[:glossary]
        sheet.Cells(row, col + 9).value  = error[:glossary].tgt  if error[:glossary]
        sheet.Cells(row, col + 10).value = error[:glossary].file if error[:glossary]
        sheet.Cells(row, col + 11).value = error[:bilingual][:file] if error[:bilingual][:file]
      }
      
    #Font/Color/Filter etc.
    sheet.Cells.Font.Name = "Tahoma"
    sheet.Cells.Font.Size = 9
    
    sheet.Rows("1:1").Select
    excel.Selection.Font.Bold = "True"
    excel.Selection.AutoFilter
    
    sheet.Rows("2:2").Select
    excel.ActiveWindow.FreezePanes = "True"
    
    col = "A"
    ((header.length) - 1).times do; col.succ!; end
    
    sheet.Columns("A:#{col}").Select
    excel.Selection.Columns.AutoFit
    
    sheet.Columns("A:C").Select
    excel.Selection.ColumnWidth = "10"
    
    sheet.Columns("D:E").Select
    excel.Selection.ColumnWidth = "50"
    excel.Selection.WrapText = "True"
    
    sheet.Columns("F:G").Select
    excel.Selection.ColumnWidth = "7"
    
    sheet.Columns("K:L").Select
    excel.Selection.ColumnWidth = "10"
    
    sheet.Columns("H").Select
    excel.Selection.ColumnWidth = "25"
    
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