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
        when 'ldquo'  then '“'
        when 'rdquo'  then '”'
      end
    end
  end
  
  def convDash
    # to fix the issue while reading ignore list CSV file
    # \u2212 \uFF0D \u2013: these characters are imcompatible between SJIS and UTF-8
    self.gsub("\u2212", "\uFF0D")
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
  #placeholder inline tags are <x/>, <g>, <bx/>, <ex/>. 
  #<g> for separate open and close tags. Bold, Italic, etc
  #<x> for concatenated open and cloase tags.
  #<x id="xx"></x> for line feed
  #<x id="xx" /> for image
  #native inline tags are <bpt> = begin, <ept> = end, <it>, <Ph>
  
  #Original tag is not escaped
  def remove_all_xliff_tags
    self.gsub(/<[^>].*?>/, "")
  end
  
  def convert_img_and_remove_all_xliff_tags
    self.gsub(/<img[^>]*?>/, "{IMG}").gsub(/<[^>].*?>/, "")
  end
  
  def remove_mrk_xliff_tags
    self.gsub(/<mrk mtype="x-sdl-comment".+?>(.*)<\/mrk>/){ $1 }.gsub(/<mrk.*?<\/mrk>/i,"")
    #self.gsub(/<mrk.*?<\/mrk>/i,"")
  end
  
  def remove_ttx_and_xliff_tags
    self.remove_ttx_tags.convert_img_and_remove_all_xliff_tags
  end
  
  def remove_ttx_innertext_and_xliff_tags
    self.remove_ttx_tags_and_innertext.remove_all_xliff_tags
  end
  
end
