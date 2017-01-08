#coding: utf-8

module Writer
  module Ignore
    #For Excel sheet. Only avaliable on Windows platform
    #check default active sheet
#    require 'tk'
    require 'csv'

    @@ignore_items = []

    #XLSX format. Save as XML and then read it.
    def read_XLS_report(file)
      excel2 = WIN32OLE.new('Excel.Application')

      begin
      xls_path = getAbsolutePath(file)
      book = excel2.Workbooks.Open(xls_path)

      #save as XML file
      xml_path = file.sub(/xlsx$/i,'xml')
      book.SaveAs(getAbsolutePath(xml_path), 46)

      #Pass to read_XML_report
      read_XML_report(open(xml_path))

      ensure
        excel2.Workbooks.Close
        excel2.Quit
      end
    end

    #CSV format. Not recommneded
    def read_CSV_report(file)
      file_str = read_rawfile(file)
      ops = {:col_sep => ",", :headers => true, :quote_char => '"'}
      myCSV = CSV.new(file_str, ops)

      myCSV.map {|row|
        next if row[12].to_s.downcase != 'ignore'
        records_to_compare = [
            row[3].convDash,
            row[4].convDash,
            row[7].convDash
          ]
        @@ignore_items << records_to_compare
        @@ignore_items.uniq!
      }
    end

    #XML spreadsheet 2003 format. Recommended. Accurate
    def read_XML_report(file)
      @doc = Nokogiri::XML(open(file))
      rows = @doc.css('Row')
      rows.map {|row|
        cells = row.css('Cell')
        next if cells[12].inner_text.downcase != 'ignore'
        records_to_compare = [
          cells[3].inner_text.convDash,
          cells[4].inner_text.convDash,
          cells[7].inner_text.convDash
        ]
        @@ignore_items << records_to_compare
        @@ignore_items.uniq!
      }
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
