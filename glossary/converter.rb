#coding: utf-8

module Converter
  #covert form of verbs/nouns to regExp format
  
  CHANGEFORM = {
                :TYPE1 => ['\b','(?:s|ed|ing)?\b'], #normal noun/verb
                :TYPE2 => ['\b','(?:y|ies|ied|ying)?\b'], #end with y
               #:TYPE3 => ['\b','(?:s|ed|ing)?\b'], #like "tap","let","swim"
                :TYPE4 => ['\b','(?:e|es|ed|ing)?\b'], #verb ends with "e". Like "delete", "remove"
  }
  
  FUKISOKU = {
              :be         => '\b(?:be|is|are|am|being|was|were)\b',
              :become     => '\b(?:become|becomes|became|becoming)\b',
              :begin      => '\b(?:begin|begins|began|begun|beginning)\b',
              :break      => '\b(?:break|breaks|broke|broken|breaking)\b',
              :bring      => '\b(?:bring|brings|brought|bringing)\b',
              :build      => '\b(?:build|builds|built|building)\b',
              :buy        => '\b(?:buy|buys|bought|buying)\b',
              :catch      => '\b(?:catch|catches|caught|catching)\b',
              :choose     => '\b(?:choose|chooses|chose|chosen|choosing)\b',
              :come       => '\b(?:come|comes|came|coming)\b',
              :do         => '\b(?:do|did|does|doing|done)\b',
              :draw       => '\b(?:draw|draws|drew|drawn|drawing)\b',
              :drink      => '\b(?:drink|drinks|drank|drunk|drinking)\b',
              :drive      => '\b(?:drive|drives|drove|driven|driving)\b',
              :eat        => '\b(?:eat|eats|ate|eaten|eating)\b',
              :fall       => '\b(?:fall|falls|fell|fallen|falling)\b',
              :feel       => '\b(?:feel|feels|felt|feeling)\b',
              :find       => '\b(?:find|finds|found|found|finding)\b',
              :fly        => '\b(?:fly|flys|flew|flown|flying)\b',
              :forget     => '\b(?:forget|forgets|forgot|forgetting|forgotten)\b',
              :get        => '\b(?:get|got|gets|getting|gotten)\b',
              :give       => '\b(?:give|gives|gave|given|giving)\b',
              :go         => '\b(?:go|goes|went|gone|going)\b',
              :grow       => '\b(?:grow|grows|grew|grown|growing)\b',
              :have       => '\b(?:have|has|had|having)\b',
              :hear       => '\b(?:hear|hears|heard|heard|hearing)\b',
              :hide       => '\b(?:hide|hides|hid|hidden|hiding)\b',
              :hold       => '\b(?:hold|holds|held|holding)\b',
              :is         => '\b(?:be|is|are|am|being|was|were)\b',
              :keep       => '\b(?:keep|keeps|kept|keeping)\b',
              :know       => '\b(?:know|knows|knew|known|knowing)\b',
              :lay        => '\b(?:lay|laies|laid|laying)\b',
              :lead       => '\b(?:lead|leads|led|leading)\b',
              :leave      => '\b(?:leave|leaves|left|leaving)\b',
              :lend       => '\b(?:lend|lends|lent|lending)\b',
              :lie        => '\b(?:lie|lay|lies|lying|lain)\b',
              :lose       => '\b(?:lose|loses|lost|losing)\b',
              :make       => '\b(?:make|makes|made|making)\b',
              :mean       => '\b(?:mean|means|meant|meaning)\b',
              :meet       => '\b(?:meet|meets|met|meeting)\b',
              :pay        => '\b(?:pay|pays|paid|paid|paying)\b',
              :ride       => '\b(?:ride|rides|rode|ridden|riding)\b',
              :rise       => '\b(?:rise|rises|rose|risen|rising)\b',
              :run        => '\b(?:run|runs|ran|running)\b',
              :say        => '\b(?:say|says|said|said|saying)\b',
              :see        => '\b(?:see|sees|saw|seen|seeing)\b',
              :sell       => '\b(?:sell|sells|sold|selling)\b',
              :send       => '\b(?:send|sends|sent|sending)\b',
              :shake      => '\b(?:shake|shakes|shook|shaken|shaking)\b',
              :shine      => '\b(?:shine|shines|shone|shining)\b',
              :shoot      => '\b(?:shoot|shoots|shot|shooting)\b',
              :show       => '\b(?:show|shows|showed|shown|showing)\b',
              :sing       => '\b(?:sing|sings|sang|sung|singing)\b',
              :sit        => '\b(?:sit|sits|sat|sitting)\b',
              :sleep      => '\b(?:sleep|sleeps|slept|sleeping)\b',
              :speak      => '\b(?:speak|speaks|spoke|spoken|speaking)\b',
              :spend      => '\b(?:spend|spends|spent|spending)\b',
              :stand      => '\b(?:stand|stands|stood|standing)\b',
              :steal      => '\b(?:steal|steals|stole|stealing|stolen)\b',
              :swim       => '\b(?:swim|swims|swam|swum|swimming)\b',
              :take       => '\b(?:take|takes|took|taken|taking)\b',
              :teach      => '\b(?:teach|teachs|taught|teaching)\b',
              :tear       => '\b(?:tear|tears|tore|torn|tearing)\b',
              :tell       => '\b(?:tell|tells|told|telling)\b',
              :think      => '\b(?:think|thinks|thought|thinking)\b',
              :throw      => '\b(?:throw|throws|threw|thrown|throwing)\b',
              :understand => '\b(?:understand|understands|understood|understanding)\b',
              :wake       => '\b(?:wake|wakes|woke|woken|waking)\b',
              :wear       => '\b(?:wear|wears|wore|worn|wearing)\b',
              :win        => '\b(?:win|wins|won|winning)\b',
              :withdraw   => '\b(?:withdraw|withdraws|withdrew|withdrawn|wthdrawing)\b',
              :withstand  => '\b(?:withstand|withstands|withstood|withstanding)\b',
              :write      => '\b(?:write|writes|wrote|written|writing)\b'
              }
  
  def convertEN(str)
    each_term = str.split(" ")
    converted_terms = []
    each_term.map {|term|
      if (term =~ /^[\[\(\.\\^]/) != nil
        term = term
      elsif (term =~ /.*[\]\)]$/) != nil
        term = term
      elsif (term =~ /^[ -~｡-ﾟ]*$/) == nil #if the term contains double-byte char, do not change
        term = term
      elsif FUKISOKU.has_key?(term.downcase.to_sym)
        term = FUKISOKU[term.downcase.to_sym]
      elsif term.match(/y\b/)
        term = CHANGEFORM[:TYPE2][0] + term.chop + CHANGEFORM[:TYPE2][1]
      elsif term.match(/e\b/)
        term = CHANGEFORM[:TYPE4][0] + term.chop + CHANGEFORM[:TYPE4][1]
      elsif term.match(/[aiueo](.)\b/)
        term = convetTYPE3(term, $1)
      else
        term = CHANGEFORM[:TYPE1][0] + term + CHANGEFORM[:TYPE1][1]
      end
      converted_terms << term
    }
    converted_terms.join(" ")
  end
  
  def convertJA(str)
    
  end
  
  def escapeRegex(str)
    str.gsub(/([\\\-\(\)])/){
      "\\"+ $1
    }
  end
  
  def convetTYPE3(term, char)
    conv = "(?:s|#{char}ed|#{char}ing)?\\b"
    return '\b' + term + conv
  end
end