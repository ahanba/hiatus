#coding: utf-8

CODE = Encoding.locale_charmap

class String
  def utf_to_native
    self.encode(CODE, "UTF-8")
  end
  
  def native_to_utf
    self.encode("UTF-8", CODE)
  end
  
  def convEntity
    self.gsub(/&(apos|amp|quot|gt|lt);/) do
      match = $1.dup
      case match
        when 'apos'   then "'"
        when 'amp'    then '&'
        when 'quot'   then '"'
        when 'gt'     then '>'
        when 'lt'     then '<'
        when 'ndash'  then '-'
      end
    end
  end
  
  def remove_ttx_tags
    #remove "<df...>", "</df>" and "<ut ...>", "</ut>" tags
    self.gsub(/(<\/?df.*?>|<\/?ut.*?>)/i, "")
  end

  def remove_ttx_tags_and_innertext
    #remove "<df...>", "</df>" and "<ut .... >...  </ut>" tags 
    #include the text between <ut> & </ut> tags. That is the difference from remove_ttx_tags method
    self.gsub(/<\/?df.*?>/i,"").gsub(/<ut.*?<\/ut>/i,"")
  end

  #see http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html for XLIFF specifications
  #delete mrk
  #placeholder inline tags are <x/>, <g>,<bx/>, <ex/> 
  #native inline tags are <bpt>, <ept>, <it>, <Ph>
  def remove_all_xliff_tags
    self.gsub(/(?:<(?:x|bx|ex).*?\/(?:x|bx|ex)>|<\/?g.*?>)/i, '')
  end
  
  def remove_mrk_xliff_tags
    self.gsub(/<mrk.*?<\/mrk>/i,"")
  end
  
  def remove_ttx_and_xliff_tags
    self.remove_ttx_tags.remove_all_xliff_tags
  end
  
  def remove_ttx_innertext_and_xliff_tags
    self.remove_ttx_tags_and_innertext.remove_all_xliff_tags
  end
end