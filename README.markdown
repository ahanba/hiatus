# hiatus
**hiatus** is a localization QA tool. Reads various bilingual file formats, runs checks and reports errors detected.  
For more details, please see  
Slide: [http://www.slideshare.net/ahanba/how-to-use-hiatus](http://www.slideshare.net/ahanba/how-to-use-hiatus)  
Demo: [http://youtu.be/6yaiI0OS-3c](http://youtu.be/6yaiI0OS-3c)  

### Check Items
+ **Glossary**  
   When a glossary source term detected in a source segment, checks if corresponding glossary target term exists in a target segment. RegExp supported.  
  
+ **Search Source or Target Text** (Defined as **monolingual**)  
   Loads expressions from the list, and report errors if the expressions found in a segment. You can choose which segment to search (source or target). RegExp supported.
  
+ **Inconsistency**  
   Checks inconsistencies in two ways - Source to Target & Target to Source  
  
+ **Numbers**  
   Detects numbers in source but NOT in target.  
  
+ **TTX, XLZ, SDLXLIFF Tag Check**  
   Detects missing or added tags. Note that hiatus cannot detect inline SDLXLIFF tags accurately.    
  
+ **Length**  
   Length of source and target segments are different more/less than +/- 50%  
  
+ **Skipped Translation, Blank**  
   Reports errors if a target segment is blank, or source and target segments are same.  
  
+ **Alphanumeric Strings in Target but NOT in Source** (Defined as **unsourced**)  
   Valid only when **target** is non-Alphabet language (i.e. Japanese, Chinese, Korean...).   
  
+ **Alphanumeric Strings in Source but NOT in Target** (Defined as **unsourced_rev**)  
   Valid only when **source** is non-Alphabet language (i.e. Japanese, Chinese, Korean...). 
  
+ **Software**  
   Checks if 1) Hotkeys (i.e. &A, _A), 2) Missing/Added variables (i.e. %s, %d), and 3) '...' at the end (i.e. Save As...) are consistent between source and target segments.
  
+ **Spell**  
   Spell check using [GNU Aspell](http://aspell.net/) library.  

### Supported Bilingual File Formats
+ XLZ (Idiom)
+ TTX
+ TMX
+ TXT (tab-separated file)
+ CSV (LocStudio dump by CSVDump add-in)
+ XLS/XLSX (By default, read as column A = Source, column B = Target, column C = Comment)
+ RTF/DOC/DOCX (Trados format bilingual)
+ TBX
+ SDLXLIFF

### Features
+ hiatus can automatically convert dictionary form into possible active forms for English (Optional).    
  Example: Converts **write** into RegExp **(?:write|writes|writing|wrote|written)**.
+ Auto-detect encoding with [chardet2](https://github.com/janx/chardet2) library to prevent garbled character issues.
+ Simple output report (XLS). Easy to filter.
+ Can suppress known false errors by specifying Ignore List.
+ Source code is published here. You can modify as you like if you want.

### Precautions
+ Do **NOT** copy anything while hiatus is running.  
  hiatus uses clipboard while reading XLSX/DOC files (including reading XLS Ignore list).  
  When you use these functions, leave clipboard during execution. Do not perform any copy operations.  
+ Ignore list does not work correctly in some cases (See "About Ignore List" for details)  
  
### Environment
Ruby 1.9.2, 1.9.3 or 2.0.0  
Windows XP, Windows 7   
*hiatus works correctly in JA and EN environment. Other languages have not been tested. However, it might work correctly on other languages as chardet2 library is implemented to support various encodings.   

### Installation
1. Install [Ruby](http://rubyinstaller.org/) 2.0.0. Check on **tk** option on installation  
2. Install GNU Aspell ([Mac](http://aspell.net/), [Win](http://aspell.net/win32/)) and dictionaries you need.  
3. Add 'C:\Program Files (x86)\Aspell\bin' to your environmental variable PATH.  
4. On 'C:\Program Files (x86)\Aspell\bin', copy **aspell-15.dll** and save it as **aspell.dll**. Also save **pspell-15.dll** as **pspell.dll**.
5. Start command prompt and run following commands  
     gem install **nokogiri**  
     gem install **zip**  
     gem install **ffi**  
     gem install **ffi-aspell**  
     gem install **chardet2**

### How to use hiatus?
Fill in necessary fields on **config.yaml**, and run **hiatus.rb**.  
Then error report will be generated.

####About config.yaml

     required:  
       bilingual: Folder path of the target bilingual files (including subfolders)  
       output: Folder path of the output report  
       report: Format of the output report (Currently, only xls)  
       source: Source Language  
       target: Target Language  
       glossary: Folder path of the Glossary files (including subfolders)
       monolingual: Folder path of the Monolingual files (including subfolders) 

    check:　Choose true or false for each check.
       glossary: true  
       inconsistency_s2t: true  
       inconsistency_t2s: true  
       missingtag: true  
       skip: true  
       monolingual: true  
       numbers: true  
       unsourced: true  
       unsourced_rev: true   
       length: false 
       software: true 
       spell: true 
  
     option:  
       filter_by: For XLZ - Only when the "Note" value is same as this value, the entry will be checked. Other entries will be skipped.   
       ignore100: true/false. For TTX/XLZ/SDLXLIFF, when true, 100% match will be skipped.  
       ignoreICE: true/false. For XLZ/SDLXLIFF, when true, ICE match will be skipped.  
       ignorelist: Path to the ignore list (XLSX file)
  
### About Ignore List
You can skip known false errors by specifying ignore list.  
Open the hiatus report (XLSX file) and mark **ignore** in "Fixed?" column (column M), and save it as XML spreadsheet 2003 format.  
(Optional) Open the CSV file and save it as UTF-8 encoding.  
Then specify the full path of the XML file in the **ignoreList** field.  
For example:  
  
       ignorelist: Y:\Sample_files\130412_report.xml  
       ignorelist: Y:\Sample_files\130412_report.xml;Y:\Sample_files\130522_report.xml  
  
*Use semicolon to specify multiple lists.  
Then, marked errors will not reported next time. 
 

*Note*:  
You can specify XLSX (or CSV file) in ignoreList field, however, it is not recommended as reading XLSX file is unstable. XML file is recommended.   
  
### How to create Glossary file? 
See below and the sample files in !Sample_files folder.  

#### Glossary File Format  
Four-Column TAB delimited Text   
UTF-8 without BOM is recommended (Encoding is automatically detected by chardet)    
#### Structure   

| Column 1|Column 2|Column 3|Column 4|
|:-------|:-------|:--------|:-------|
|Source|Target|Option|Comment|   

|Column|Description|
|:---|:---|
|Source|Glossary source term. RegExp supported. Required|
|Target|Glossary target term. RegExp supported. Required|
|Option|Conversion option. Required|
|Comment|Comment. Optional|

#### About Options
Available options are combination of followings

|Option|Description|
|:-----|:----------|
|i|ignore case + Auto Conversion|
|m|multiline + Auto Conversion|
|e|extended + Auto Conversion|
|z|No Conversion + No RegExp + Case-Insensitive|
|*Blank*|No Conversion + No RegExp + Case-Sensitive (= As is)|
|||
|Prefix #||
|#<*X*>|Auto Conversion OFF. When you use your own RegExp, add # at the beginning of the option field|

#### Sample   
```
Server	 サーバー	z
(?:node|nodes)	ノード	#i	ノードの訳に注意
import(?:ing)	インポート	#i
Japan	日本		JapanはCase-sensitive
run	走る	i	
(?<!start|end) point	#i	点
```

You can try Ruby RegExp on [rubular](http://rubular.com/).  
RegExp is based on [onigumo](https://github.com/k-takata/Onigmo), see [Ruby 2.0.0 reference](http://www.ruby-doc.org/core-2.0.0/Regexp.html) for details of RegExp available in Ruby 2.0.0.   

### How to create Monolingual file?   
See below and the sample files in !Sample_files folder.   

#### Monolingual File Format  
Four-Column TAB delimited Text   
UTF-8 without BOM is recommended (Encoding is automatically detected by chardet)
#### Structure   

|Column 1|Column 2|Column 3|Column 4|
|:-------|:-------|:--------|:-------|
|s or t|Expression|Option|Comment|

|Column|Description|
|:---|:---|
|s or t|Segment to search. 's' is source, 't' is target segment. Required|
|Expression|Search expression. RegExp supported. Required|
|Option|Conversion option. Required|
|Comment|Comment. Optional|

#### About Option
Available options are combination of followings

|Option|Description|
|:-----|:----------|
|i|ignore case + Auto Conversion|
|m|multiline + Auto Conversion|
|e|extended + Auto Conversion|
|z|No Conversion + No RegExp + Case-Insensitive|
|*Blank*|No Conversion + No RegExp + Case-Sensitive (= As is)|
|||
|Prefix #||
|#<*X*>|Auto Conversion OFF. When you use your own RegExp, add # at the beginning of the option field|

#### Sample    
```
t	；	#	全角セミコロン；を使用しない
t	[\p{Katakana}ー]・	#	カタカナ間の中黒を使用しない
t	[０１２３４５６７８９]+	#	全角数字を禁止
s	not	z	否定文？
t	Shared Document	#i	Windows のファイル パスはローカライズする（共有ドキュメント）。
t	[あいうえお]	#	Hiragana left
```

You can try Ruby RegExp on [rubular](http://rubular.com/).  
RegExp is based on [onigumo](https://github.com/k-takata/Onigmo), see [Ruby 2.0.0 reference](http://www.ruby-doc.org/core-2.0.0/Regexp.html) for details of RegExp available in Ruby 2.0.0. 

## License
Copyright &copy; 2014 Ayumu Hanba (ayumuhamba19&lt;at_mark&gt;gmail.com)  
Distributed under the [GPL License][GPL].

[GPL]: http://www.gnu.org/licenses/gpl.html
