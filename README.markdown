hiatus
===========================
**hiatus** is a localization QA tool, reads various bilingual files, runs checks and reports the errors found.  
For more details, please see  
Slide: [http://www.slideshare.net/ahanba/how-to-use-hiatus](http://www.slideshare.net/ahanba/how-to-use-hiatus)  
Demo: [http://youtu.be/6yaiI0OS-3c](http://youtu.be/6yaiI0OS-3c)  

Check Items
------
+ **Glossary** (RegExp supported)
+ **Source or Target Segment (simple Term & Style check)** (RegExp supported)
+ **Inconsistency** (two way - both Source <=> Target)
+ **Numbers** (detect the numbers in Source but NOT in Target)
+ **TTX, XLZ, SDLXLIFF Tag Check** (Missing or Added one)
+ **Length** (the length of Source and Target is different more/less than +/- 50%)
+ **Skipped Translation, Blank**
+ **Alphanumeric Strings in Target but NOT in Source** (valid only when Target is non-Alphabet language: unsourced)
+ **Alphanumeric Strings in Source but NOT in Target** (valid only when Source is non-Alphabet language: unsourced_rev)

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
  Example: hiatus converts **write** into **write|writes|writing|wrote|written**, and all of these terms are detected.
+ As long as the encode of bilingual file is UTF-8/UTF-16, no garbage occurs in multiple languages, such as Japanese, Chinese, Korean, Thai, etc.
+ Simple output report (XLS). Easy to filter.
+ Source code is published - you can see what can be checked, what can NOT be checked.

Environment
--------
Ruby 1.9.2 or 1.9.3  
Windows XP, Windows 7
*Although I have not tested it, I think hiatus works on other language environments. OS default encoding is set dynamically.

Ruby Libraries Required
---------
**tk** (install tk when install [Ruby](http://rubyinstaller.org/))  
gem install **nokogiri**  
gem install **zip**  

How to use hiatus?
---------
Fill in necessary items on **config.yaml**, and run **hiatus.rb**.  
Then error report will be generated.

###About config.yaml###

     required:  
       bilingual: Folder path of the target bilingual files (including subfolders)  
       output: Folder path of the output report  
       report: Format of the output report (Currently, only xls)  
       source: Source Language  
       target: Target Language  
       glossary:   Folder path of the Glossary files (including subfolders)
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
  
     option:  
       filter_by: For XLZ - Only when the "Note" value is same as this value, the entry will be checked. Other entries will be skipped.   
       ignore100: true/false. For TTX/XLZ/SDLXLIFF, when true, 100% match will be skipped.  
       ignoreICE: true/false. For XLZ/SDLXLIFF, when true, ICE match will be skipped.  

How to create Glossary file?
------------
The format is Tab Separated Text file (TSV file).  
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
*Third column is always required - "SourceTerm&nbsp;&nbsp;&nbsp;&nbsp;TargetTerm&nbsp;&nbsp;&nbsp;&nbsp;Option"*  
*Even when you use Blank option, create 3rd column and leave there blank*

Auto Conversion is a function to convert dictionary form into active possible forms.  
For example, **write** is converted into **write|writes|writing|wrote|written**, and all of these are detected.  

How to create Monolingual file?
--------
Tab Separated Text file (TSV file).  
UTF-8 without BOM is recommended, however, you can use other char code as it is automatically detected by NKF library.   
See below and the sample files in !Sample_files folder.   

**Monolingual File Format** 

**s or t&nbsp;&nbsp;&nbsp;&nbsp;SearchTerm&nbsp;&nbsp;&nbsp;&nbsp;Option&nbsp;&nbsp;&nbsp;&nbsp;Message to display**  
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
*Third column is always required - "s or t&nbsp;&nbsp;&nbsp;&nbsp;SearchTerm&nbsp;&nbsp;&nbsp;&nbsp;Option"*  
*Even when you use Blank option, create 3rd column and leave there blank.*
*4th column is optional. you can omit.*

License
----------
Copyright &copy; 2012 Ayumu Hanba (ayumuhamba19 at_mark gmail.com)  
Distributed under the [GPL License][GPL].

[GPL]: http://www.gnu.org/licenses/gpl.html
