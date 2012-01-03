#coding: utf-8

module Converter
  #covert form of verbs/nouns to regExp format
  
  CHANGEFORM = {
                :TYPE1 => ['\b','(?:s|ed|ing)?\b'], #normal noun/verb
                :TYPE2 => ['\b','(?:y|ies|ied|ying)?\b'], #end with y
                :TYPE3 => ['\b','?(?:s|ed|ing)?\b'] #like "tap","let","swim"
  }
  
  FUKISOKU = {
              :do => ['\b(?:do|did|does|doing|done)\b'],
              :get => ['\b(?:get|got|gets|getting|gotten)\b'],
              :meet => ['\b(?:meet|meets|met|meeting)\b'],
              :see => ['\b(?:see|sees|saw|seen|seeing)\b'],
              :take => ['\b(?:take|takes|took|taken|taking)\b'],
              :make => ['\b(?:make|makes|made|making)\b'],
              :make => ['\b(?:make|makes|made|making)\b'],
              :forget => ['\b(?:forget|forgets|forgot|forgetting|forgotten)\b'],
              :steal => ['\b(?:steal|steals|stole|stealing|stolen)\b'],
              :lay => ['\b(?:lay|laies|laid|laying)\b'],
              :lie => ['\b(?:lie|lay|lies|lying|lain)\b'],
              :buy => ['\b(?:buy|bought|buys|buying))\b']
  }
  
  def convertEN(str)
    each_term = str.split(" ")
    converted_terms = []
    each_term.map {|term|
      if (term =~ /^[ -~｡-ﾟ]*$/) == nil #if the term contains double-byte char, do not change
        term = term
      elsif FUKISOKU.has_key?(term.to_sym)
        term = FUKISOKU[term.to_sym]
      elsif term.match(/y\b/)
        term = CHANGEFORM[:TYPE2][0] + term.chop + CHANGEFORM[:TYPE2][1]
      elsif term.match(/[aiueo](.)\b/)
        term = CHANGEFORM[:TYPE3][0] + term + $1 + CHANGEFORM[:TYPE3][1]
      else
        term = CHANGEFORM[:TYPE1][0] + term + CHANGEFORM[:TYPE1][1]
      end
      converted_terms << term
    }
    converted_terms.join(" ")
  end
end