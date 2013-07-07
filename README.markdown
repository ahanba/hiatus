hiatus
===========================
**hiatus** is a localization QA tool. Reads various types of bilingual files, runs checks and reports errors detected.  
For more details, please see  
Slide: [http://www.slideshare.net/ahanba/how-to-use-hiatus](http://www.slideshare.net/ahanba/how-to-use-hiatus)  
Demo: [http://youtu.be/6yaiI0OS-3c](http://youtu.be/6yaiI0OS-3c)  

Check Items
------
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

Supported Bilingual File Formats
------
+ XLZ (Idiom)
+ TTX
+ TMX
+ TXT (tab-separated file)
+ CSV (LocStudio dump by CSVDump add-in)
+ XLS/XLSX (read as column A = Source, column B = Target, column C = Comment)
+ RTF/DOC/DOCX (Trados format bilingual)
+ TBX
+ SDLXLIFF

Features
--------
+ For English, hiatus converts dictionary form into possible active forms (Optional).    
  Example: hiatus converts **write** into **write|writes|writing|wrote|written**, and all of these terms can be detected.
+ As long as the encode of input files are UTF-8/UTF-16, hiatus can handle multiple languages (i.e. Japanese, Chinese, Korean, Thai, etc.) without generating garbage characters.
+ Simple output report (XLS). Easy to filter.
+ Suppress known false errors by specifying Ignore List.
+ Source code is published - you can confirm what can be checked, what can NOT be checked.

Precautions
--------
+ Do **NOT** copy anything while hiatus is running.  
  hiatus uses clipboard while reading XLSX/DOC files (including reading XLS Ignore list).  
  When you use these functions, leave clipboard. Do not perform any copy operations.  
+ Ignore list does not work correctly in some cases (See "About Ignore List" for details)  
  
Environment
--------
Ruby 1.9.2 or 1.9.3  
Windows XP, Windows 7   
*Although it has not been tested, hiatus may work on other language environments. OS default encoding is set dynamically when generating Excel output file.   

Installation
---------
1. Install [Ruby](http://rubyinstaller.org/) 1.9.3. Check on **tk** option on installation  
2. Install GNU Aspell ([Mac](http://aspell.net/), [Win](http://aspell.net/win32/)) and dictionaries you need.  
3. Add 'C:\Program Files (x86)\Aspell\bin' to your environmental variable PATH.  
4. On 'C:\Program Files (x86)\Aspell\bin', copy **aspell-15.dll** and save it as **aspell.dll**. Also save **pspell-15.dll** as **pspell.dll**.
5. Start command prompt and run following commands  
     gem install **nokogiri**  
     gem install **zip**  
     gem install **ffi**  
     gem install **ffi-aspell**  

How to use hiatus?
---------
Fill in necessary fields on **config.yaml**, and run **hiatus.rb**.  
Then error report will be generated.

###About config.yaml###

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
  
About Ignore List
------------
You can skip known false errors by specifying ignore list.  
Open the hiatus report XLSX file and mark **ignore** in "Fixed?" column (column M), and save it as XML spreadsheet 2003 format.  
(Optional) Open the CSV file and save it as UTF-8 encoding.  
Then specify the full path of the XML file in the ignoreList field.  
For example:  
  
       ignorelist: Y:\Sample_files\130412_report.xml  
       ignorelist: Y:\Sample_files\130412_report.xml;Y:\Sample_files\130522_report.xml  
  
*Use semicolon to specify multiple lists.  
Then, marked errors will be suppressed next time. 
 

*Note*:  
You can specify XLSX (or CSV file) directly in ignoreList field, however, it does not work correctly in some cases.  
Some characters (typically some double-byte characters) get garbled while reading XLSX file.  
In that case, this function does not work as expected.  
This issue depends on your OS default encoding and source/target texts (languages) in the provided ignore list.  
Also reading XLSX file takes much longer than reading XML.  
So XML file is recommended.   
  
How to create Glossary file?
------------
Supported format is Tab Separated Text file (TSV file).  
UTF-8 without BOM is recommended, however, you can use other char code as it is automatically detected by NKF library.   
See below and the sample files in !Sample_files folder.  

**Glossary File Format** 

**SourceTerm&nbsp;&nbsp;&nbsp;&nbsp;TargetTerm&nbsp;&nbsp;&nbsp;&nbsp;Option**  
Assume space as a Tab - "SourceTerm[tab]TargetTerm[tab]Option" 

     Server	 サーバー	i
     node	ノード
     delegate	委譲する	i
     install	インストール	i 

Available options are the combinations of followings
+ **i**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Ignore Case + Auto Conversion*
+ **m**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*multiline + Auto Conversion*
+ **e**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Extended + Auto Conversion*  
+ **#**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Auto Conversion OFF. When you write RegExp by yourself, add # at the beginning of option field*  
Or  
+ **z**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*No Conversion + No RegExp. Only Case-Insensitive*
+ **Blank**&nbsp;&nbsp;&nbsp;&nbsp;*No Conversion + No RegExp + Case-Sensitive => As Is*  

You can try Ruby RegExp on [rubular](http://rubular.com/).  
Also Ruby RegExp is based on [oniguruma](http://www.geocities.jp/kosako3/oniguruma/), see [here](http://www.geocities.jp/kosako3/oniguruma/doc/RE.txt) for RegExp API available in Ruby.   
*Third column is mandatory - "SourceTerm&nbsp;&nbsp;&nbsp;&nbsp;TargetTerm&nbsp;&nbsp;&nbsp;&nbsp;Option"*  
*Even when you use Blank option, create third column and leave it blank*

Auto Conversion is a function to convert dictionary form into active possible forms.  
For example, **write** is converted into **write|writes|writing|wrote|written**, and all of these are detected.  

How to create Monolingual file?
--------
Supported format is Tab Separated Text file (TSV file).  
UTF-8 without BOM is recommended, however, you can use other char code as it is automatically detected by NKF library.   
See below and the sample files in !Sample_files folder.   

**Monolingual File Format** 

**s** or **t&nbsp;&nbsp;&nbsp;&nbsp;SearchTerm&nbsp;&nbsp;&nbsp;&nbsp;Option&nbsp;&nbsp;&nbsp;&nbsp;Message to display**  
Assume space as a Tab - "s or t[tab]SearchTerm[tab]Option[tab]Message to display"  

	t	；	#	全角セミコロン；を使用しない
	t	[\p{Katakana}ー]・	#	カタカナ間の中黒を使用しない
	t	[０１２３４５６７８９]+	#	全角数字を禁止
	s	not	z	否定文？
	t	Shared Document	#i	Windows のファイル パスはローカライズする（共有ドキュメント）。

If you specify **s** on the first column, Source text will be searched, and if **t**, Target text will be searched.  
Available options are same as Glossary.

You can try Ruby RegExp on [rubular](http://rubular.com/).  
Also Ruby RegExp is based on [oniguruma](http://www.geocities.jp/kosako3/oniguruma/), see [here](http://www.geocities.jp/kosako3/oniguruma/doc/RE.txt) for RegExp API available in Ruby.   
*Third column is mandatory - "s or t&nbsp;&nbsp;&nbsp;&nbsp;SearchTerm&nbsp;&nbsp;&nbsp;&nbsp;Option"*  
*Even when you use Blank option, create third column and leave it blank.*
*Fourth column is optional. you can omit.*

License
----------
Copyright &copy; 2013 Ayumu Hanba (ayumuhamba19&lt;at_mark&gt;gmail.com)  
Distributed under the [GPL License][GPL].

[GPL]: http://www.gnu.org/licenses/gpl.html
