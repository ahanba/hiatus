#coding: utf-8

module Reader
  module ReadXLS
    require 'modules/reader/core'
    include Reader::Core
    
    COL_SRC = 3
    COL_TGT = 3
    COL_NOT = 2
    
    #For Excel sheet. Only avaliable on Windows platform
    #Target = Active sheet, col A as Source, col B as Target, and col C as ID
    def readXLS(file, option)
      excel = WIN32OLE.new('Excel.Application')
      begin
        #open XLS file
        xls_path = getAbsolutePath(file)
        book = excel.Workbooks.Open(xls_path)

        #save as XML file
        xml_path = file.sub(/xlsx$/i,'xml')
        book.SaveAs(getAbsolutePath(xml_path), 46)

        #read XML file
        doc = Nokogiri::XML(open(xml_path))
        rows = doc.xpath('//xmlns:Row', {'xmlns' => "urn:schemas-microsoft-com:office:spreadsheet"})
        start_index = rows[0]['ss:Index'].to_i

        i = 0
        rows.map {|row|
          cells = row.xpath('xmlns:Cell', {'xmlns' => "urn:schemas-microsoft-com:office:spreadsheet"})

          entry = {}
          entry[:filename] = file.to_s
          cells[COL_SRC-1].xpath('xmlns:Data', {'xmlns' => "urn:schemas-microsoft-com:office:spreadsheet"}) != nil ? entry[:source] = cells[COL_SRC-1].xpath('xmlns:Data', {'xmlns' => "urn:schemas-microsoft-com:office:spreadsheet"}).inner_text : entry[:source] = ""
          cells[COL_TGT-1].xpath('xmlns:Data', {'xmlns' => "urn:schemas-microsoft-com:office:spreadsheet"}) != nil ? entry[:target] = cells[COL_TGT-1].xpath('xmlns:Data', {'xmlns' => "urn:schemas-microsoft-com:office:spreadsheet"}).inner_text : entry[:target] = ""
          cells[COL_NOT-1].xpath('xmlns:Data', {'xmlns' => "urn:schemas-microsoft-com:office:spreadsheet"}) != nil ? entry[:note]   = cells[COL_NOT-1].xpath('xmlns:Data', {'xmlns' => "urn:schemas-microsoft-com:office:spreadsheet"}).inner_text : entry[:note]   = ""
          entry[:id] = "Row #{start_index + i}"
          @@bilingualArray.push(entry)
          i += 1
        }
      rescue
        p $!
      ensure
        excel.Workbooks.Close
        excel.Quit
      end
    end
  end
end
