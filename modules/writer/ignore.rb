#coding: utf-8

module Writer
  module Ignore
    #For Excel sheet. Only avaliable on Windows platform
    #check default active sheet
    require 'tk'
    
    def read_XLS_report(file)
      excel2 = WIN32OLE.new('Excel.Application')
      file_path = getAbsolutePath(file)
      ignore_items = []
      
      begin
        book = excel2.Workbooks.Open(file_path)
        sheet = book.ActiveSheet
        rowNum = sheet.Range("A65536").End(:Direction  =>  -4162).Row
        
        i = 1
        (rowNum - 1).times do
          i += 1
          next if sheet.Cells(i, 13).value.to_s.downcase != 'ignore'
          records_to_compare = [
            get_value_from_cell(sheet.Cells(i, 4)),
            get_value_from_cell(sheet.Cells(i, 5)),
            get_value_from_cell(sheet.Cells(i, 8))
            ]
          ignore_items << records_to_compare
        end
      ensure
        excel2.Workbooks.Close
        excel2.Quit
      end
      
      return ignore_items.uniq!
    end
    
    def get_value_from_cell(cell)
      cell.Copy
      str = NKF.nkf('-wxm0', TkClipboard.get).chomp
      str.include?("\n") ? str.gsub(/(^"|"$)/i,'') : str
    end
    
    def ignore?(error, ignore_items)
      records_to_compare = [
        CGI.unescapeHTML(error[:bilingual][:source].remove_ttx_and_xliff_tags).convEntity,
        CGI.unescapeHTML(error[:bilingual][:target].remove_ttx_and_xliff_tags).convEntity,
        error[:found]
        ]
      return ignore_items.include?(records_to_compare)
    end
  end
end
