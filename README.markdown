hiatus
===========================
**hiatus** is a QA (Quality Assurance) tool for localization.  
For more details, please see  
Slide: [http://www.slideshare.net/ahanba/how-to-use-hiatus](http://www.slideshare.net/ahanba/how-to-use-hiatus)  
Demo: [http://youtu.be/6yaiI0OS-3c](http://youtu.be/6yaiI0OS-3c)  

What you can check?
------
+ **Glossary** (support RegExp)
+ **Monolingual of Source or Target segment** (this is for StyleGuide. Support RegExp)
+ **Inconsistency** (both Source => Target and Target => Source)
+ **Numbers** (detect the numbers not exist in Source text, but exist in Target text)
+ **TTX, XLZ tag check** (both Missing and Added one)
+ **Length** (the length of Source and Target is different more/less than +/- 50%)
+ **Skipped Translation, Blank**
+ **Alphabet or Numeric figures in the Target not exist in the Source** (only when Target is non-Alphabet language)
+ **Alphabet or Numeric figures in the Source not exist in the Target** (only when Source is non-Alphabet language)
ch
Which files can be checked?
------
+ XLZ (for example, Idiom)
+ TTX
+ TMX
+ TXT (tab-separated file)
+ CSV (LocStudio dump by CSVDump add-in)
+ XLS/XLSX (read as column A = Source, column B = Target, column C = Comment)
+ RTF/DOC/DOCX (Trados format bilingual)
+ TBX

Features
--------
+ For English, Dictionary form is converted to possible active forms (Optional, you can check on/off this conversion option).    
  Example: **write** is converted to **write|writes|writing|wrote|written**, and all of these terms are detected.
+ If the encode of target file is unicode (UTF-8|UTF-16), no garbage happens for multiple languages, such as Japanese, Chinese, Korean, Thai, etc.
+ Output report (XLS) is easy to use (read/filter). You can use it for the next QA process without additional work.
+ Source code is published here, so you can understand the tool comprehensively - what is checked, what is NOT checked. Also you can fix it when you find the error.

Environment
--------
Ruby 1.9.2 or 1.9.3  
Windows XP, Windows 7 Japanese  

By default, this tool is designed for Japanese Windows OS, that means default OS encode is set to Shift-JIS. So this won't work on other language environment.  
If you want to use this in other language, you have to modify a bit or contact me. It is not difficult work  

Ruby Libraries required
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
       bilingual: Folder path to the bilingual files to check (subfolder included)  
       output: Folder path of the output report generated  
       report: Format of the output report (Currently, only xls)  
       source: Source Language  
       target: Target Language  
       glossary:   Folder path to the Glossary files (subfolder included)
       monolingual: Folder path to the Moolingual files (subfolder included) 

    check:　Choose true or false for each check.
       glossary: true  
       inconsistency_s2t: true  
       inconsistency_t2s: true  
       missingtag: true  
       skip: true  
       monolingual: true  
       numbers: true  
       unsourced: true  
       length: false  
  
     option:  
       filter_by: For XLZ, only when the "Note" value is same as this value, the entry is checked. Other entries are skipped.   
       ignore100: true/false. For TTX & XLZ, when this is true, 100% match is skipped.  
       ignoreICE: true/false. For XLZ, when this is true, ICE match is skipped.  

How to create Glossary file?
------------
Tab Separated Text file (TSV file).  
UTF-8 without BOM is recommended, however, you can use other char code as it is automatically detected by NKF library.  
Use following tab-separated format  

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
+ **#**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Turn Auto Conversion OFF. When you write RegExp by yourself, add # at the beginning*  
Or  
+ **z**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*No Conversion. No RegExp. Only Case-Insensitive*
+ **Blank**&nbsp;&nbsp;&nbsp;&nbsp;*No Conversion. No RegExp. Case-Sensitive. In short, as is*  

You can check Ruby RegExp on [rubular](http://rubular.com/).  
*Always three columns necessary - "SourceTerm&nbsp;&nbsp;&nbsp;&nbsp;TargetTerm&nbsp;&nbsp;&nbsp;&nbsp;Option"*  
*When you use Blank option, create 3rd column and leave there blank*
*Otherwise, an error will be happened and doesn't work*

Auto Conversion is a function to convert dictionary form to active possible forms.  
For example, write is converted to write|writes|writing|wrote|written, and all of these are detected.  

How to create Monolingual file?
--------
Tab Separated Text file (TSV file).  
UTF-8 without BOM is recommended, however, you can use other char code as it is automatically detected by NKF library.   
Use following tab-separated format  

**s or t&nbsp;&nbsp;&nbsp;&nbsp;SearchTerm&nbsp;&nbsp;&nbsp;&nbsp;Option&nbsp;&nbsp;&nbsp;&nbsp;Message to display**  
Assume space as a Tab - "s or t[tab]SearchTerm[tab]Option[tab]Message to display"  

	t	；	#	全角セミコロン；を使用しない
	t	[\p{Katakana}ー]・	#	カタカナ間の中黒を使用しない
	t	[０１２３４５６７８９]+	#	全角数字を禁止
	s	not	z	否定文？
	t	Shared Document	#i	Windows のファイル パスはローカライズする（共有ドキュメント）。

If you choose s, Source text is searched, and if t, Target text is searched.  
Available options are same as Glossary. 

You can check Ruby RegExp on [rubular](http://rubular.com/).  
*Always three columns necessary - "s or t&nbsp;&nbsp;&nbsp;&nbsp;SearchTerm&nbsp;&nbsp;&nbsp;&nbsp;Option"*  
*When you use Blank option, create 3rd column and leave there blank. 4th column is an option. It is optional*
*Otherwise, an error will be happened and doesn't work*

License
----------
Copyright &copy; 2012 Ayumu Hanba  
Distributed under the [GPL License][GPL].

[GPL]: http://www.gnu.org/licenses/gpl.html
