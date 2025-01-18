# hiatus
**hiatus** is a localization QA tool that supports various bilingual file formats, performs automated checks, and reports detected errors.  
For more details, see  
Slide: [http://www.slideshare.net/ahanba/how-to-use-hiatus](http://www.slideshare.net/ahanba/how-to-use-hiatus)  
Demo: [http://youtu.be/6yaiI0OS-3c](http://youtu.be/6yaiI0OS-3c)  

## Detectable errors
+ **Glossary**  
   When a glossary source term is found in a source segment, the tool checks if the corresponding glossary target term exists in the target segment. Supports RegExp for advanced matching.
  
+ **Search Source or Target Segment** (Defined as **monolingual**)  
   Searches source or target segments exclusively and reports errors if specified text is found. Supports RegExp for advanced matching.
  
+ **Inconsistency**  
   Checks for inconsistencies bidirectionally: Source-to-Target and Target-to-Source. 
  
+ **Numbers**  
   Detects numbers present in the source but missing in the target. 
  
+ **TTX, XLZ, SDLXLIFF Tag Check**  
   Detects missing or extra internal tags.     
  
+ **Length**  
   Flags source and target segments when their lengths differ by more than ±50%.
  
+ **Skipped Translation**  
   Reports errors for blank target segments.

+ **Identical Translation**   
   Reports errors when the source and target segments are identical.  
  
+ **Alphanumeric Strings in Target but NOT in Source** (Defined as **unsourced**)  
   Effective only when the **target** language is non-alphabetic (e.g., Japanese, Chinese, Korean).
  
+ **Alphanumeric Strings in Source but NOT in Target** (Defined as **unsourced_rev**)  
   Effective only when the **source** language is non-alphabetic (e.g., Japanese, Chinese, Korean).
  
+ **Software**  
   Checks for consistency between source and target segments for: 1) Hotkeys (e.g., &A, _A), 2) Missing/Added variables (e.g., %s, %d), and 3) '...' at the end (e.g., Save As...).
  
+ **Spell**  
   Spell check using [GNU Aspell](http://aspell.net/) library. 
   **Note**: Spell check is no longer available.

## Supported Bilingual File Formats
+ XLZ (Idiom)
+ TTX
+ TMX
+ CSV (You can specify the columns to check)
+ TXT (tab-separated file)
+ XLS/XLSX (By default, read as column A = Source, column B = Target, column C = Comment)
+ RTF/DOC/DOCX (Trados format bilingual)
+ TBX
+ SDLXLIFF

## Features
+ hiatus can automatically convert dictionary forms into possible active forms for English (optional).  
  Example: Converts **write** into RegExp **(?:write|writes|writing|wrote|written)**.
+ Automatically detects encoding using the [chardet2](https://github.com/janx/chardet2) library to prevent garbled character issues.
+ Simple output report (XLS) that is easy to filter.

## Precautions
+ Do **NOT** copy anything while hiatus is running.
  hiatus uses the clipboard when reading XLSX/DOC files (including reading the XLS Ignore list).
  During execution, avoid any copy operations."  
+ The Ignore List may not work correctly in some cases. (See 'About Ignore List' for details.)
  
## Environment
Ruby 1.9.2 and higher  
Windows only (Mac not supported)  

## Installation
1. Install [Ruby](http://rubyinstaller.org/). Check on **tk** option in the installation.
2. Install GNU Aspell ([Mac](http://aspell.net/), [Win](http://aspell.net/win32/)) and dictionaries you use.  
3. Add 'C:\Program Files (x86)\Aspell\bin' to your environmental variable PATH.  
4. On 'C:\Program Files (x86)\Aspell\bin', copy **aspell-15.dll** and save it as **aspell.dll**. Also save **pspell-15.dll** as **pspell.dll**.
5. Open the command prompt and run the following commands:
     gem install **nokogiri**  
     gem install **zip**  
     gem install **ffi**  
     gem install **ffi-aspell**  
     gem install **chardet2**

## How to use hiatus?
Fill out the necessary fields in config.yaml, then run hiatus.rb. An error report will be generated.

#### About config.yaml

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
       identical: false   
       monolingual: true  
       numbers: true  
       unsourced: true  
       unsourced_rev: true   
       length: false 
       software: true 
       spell: true 
  
     option:  
       filter_by: For XLZ, only entries where the 'Note' value matches this value will be checked; other entries will be skipped.  
       ignore100: true/false. For TTX/XLZ/SDLXLIFF, when set to true, 100% matches will be skipped."
       ignoreICE: true/false. For XLZ/SDLXLIFF, when set to true, ICE match will be skipped.  
       ignorelist: Path of the ignore list (XLSX file)
  
### About Ignore List
You can skip known false errors by specifying an ignore list.  
Open the hiatus report (XLSX file), mark **ignore** in the 'Fixed?' column (Column M), and save it as an XML Spreadsheet 2003 format.  
Then, specify the full path of the XML file in the **ignoreList** field. Use semicolons to separate multiple files.  

For example:  
  
       ignorelist: Y:\Sample_files\130412_report.xml  
       ignorelist: Y:\Sample_files\130412_report.xml;Y:\Sample_files\130522_report.xml  
   
By specifying the ignoreList, marked errors will not be reported the next time.

Note: While you can specify an XLSX (or CSV) file in the ignoreList field, it is not recommended due to instability in reading XLSX files. XML files are recommended instead.
  
### How to create Glossary file? 
Refer to the following instructions and sample files in the !Sample_files folder. 

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
(?<!start¥-|end¥-)point	点	#i	Feedback No.2
```

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
  
> [!TIP]
> You can try Ruby RegExp on [rubular](http://rubular.com/).  
> RegExp is based on [onigumo](https://github.com/k-takata/Onigmo), see [Ruby 2.0.0 reference](http://www.ruby-doc.org/core-2.0.0/Regexp.html) for details of RegExp available in Ruby 2.0.0. 
  
## License
Copyright &copy; 2014 Ayumu Hanba (ayumuhamba19&lt;at_mark&gt;gmail.com)  
Distributed under the [GPL License][GPL].

[GPL]: http://www.gnu.org/licenses/gpl.html