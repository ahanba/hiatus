#coding: utf-8

class NilClass
  def remove_ttx_tags
    #remove "<df...>", "</df>" and "<ut ...>", "</ut>" tags
    self.to_s.gsub(/(<\/?df.*?>|<\/?ut.*?>)/i, "")
  end

  def remove_ttx_tags_and_innertext
    #remove "<df...>", "</df>" and "<ut .... >...  </ut>" tags 
    #include the text between <ut> & </ut> tags. That is the difference from remove_ttx_tags method
    self.to_s.gsub(/<\/?df.*?>/i,"").gsub(/<ut.*?<\/ut>/i,"")
  end
  
  def remove_all_xliff_tags
    #see http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html for XLIFF specifications
    #delete mrk
    #placeholder inline tags are <x/>, <g>,<bx/>, <ex/> 
    #native inline tags are <bpt>, <ept>, <it>, <Ph>
    self.gsub(/(?:<(?:x|bx|ex).*?\/(?:x|bx|ex)>|<\/?g.*?>)/i, '')
  end
  
  def remove_mrk_xliff_tags
    self.to_s.gsub(/<mrk.*?<\/mrk>/i,"")
  end
  
  def remove_ttx_and_xliff_tags
    self.to_s.remove_ttx_tags.remove_all_xliff_tags
  end
  
  def remove_ttx_innertext_and_xliff_tags
    self.to_s.remove_ttx_tags_and_innertext.remove_all_xliff_tags
  end
end

