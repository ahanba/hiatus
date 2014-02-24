#coding: utf-8

class NilClass
  def utf_to_native
    self.to_s.encode(CODE, "UTF-8")
  end
  
  def native_to_utf
    self.to_s.encode("UTF-8", CODE)
  end
  
  def convDash
    #do nothing for nilclass
    self
  end
  
  def remove_ttx_tags
    #remove "<df...>", "</df>" and "<ut ...>", "</ut>" tags
    self.to_s.gsub(/(<\/?df.*?>|<\/?ut.*?>)/i, "")
  end
  
  def remove_ttx_tags_and_innertext
    #remove "<df...>", "</df>" and "<ut .... >...  </ut>" tags 
    #include the text between <ut> & </ut> tags. That is the difference from remove_ttx_tags method
    self.to_s.gsub(/<\/?df.*?>/i,"").gsub(/<ut.*?<\/ut>/i,"")
  end
  
  #see http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html for XLIFF specifications
  #delete mrk
  #placeholder inline tags are <x/>, <g>, <bx/>, <ex/>. 
  #<g> for separate open and close tags. Bold, Italic, etc
  #<x> for concatenated open and cloase tags.
  #<x id="xx"></x> for line feed
  #<x id="xx" /> for image
  #native inline tags are <bpt> = begin, <ept> = end, <it>, <Ph>
  
  #
  #Obsolete
  #
  #def remove_all_xliff_tags
  #  self.to_s.gsub(/(<g[^>]+?><(?:x|bx|ex).+?\/(?:x|bx|ex)><\/g>|<x[^>]+?><\/x> ?<x[^>]+?><\/x> ?<x[^>]+?><\/x> ?<x[^>]+?><\/x> ?<x[^>]+?><\/x> ?)/i, '{TAG}').gsub(/<(?:x|bx|ex) id="[a-z\d]+".*?\/(?:x|bx|ex)>/i, '{TAG}').gsub(/<\/?g.*?>/i, '{TAG}')
  #end
  
  def remove_all_xliff_tags
    self.to_s.gsub(/<\/?[eb]?[xg].*?>/, "")
  end
  
  def convert_img_and_remove_all_xliff_tags
    self.to_s.gsub(/<img[^>]*?>/, "{IMG}").gsub(/<[^>].*?>/, "")
  end
  
  def remove_mrk_xliff_tags
    self.to_s.gsub(/<mrk.*?<\/mrk>/i,"")
  end
  
  def remove_ttx_and_xliff_tags
    self.to_s.remove_ttx_tags.convert_img_and_remove_all_xliff_tags
  end
  
  def remove_ttx_innertext_and_xliff_tags
    self.to_s.remove_ttx_tags_and_innertext.remove_all_xliff_tags
  end
end

