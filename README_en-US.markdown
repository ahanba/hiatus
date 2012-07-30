hiatus
===========================
**hiatus** is a QA (Quality Assurance) tool for localization.  
For more details, please see http://www.slideshare.net/ahanba/how-to-use-hiatus

What you can check?
------
+ **Glossary** (support RegExp)
+ **Monolingual from Source or Target segment** (this is for StyleGuide. Support RegExp)
+ **Inconsistency** (both Source => Target and Target => Source)
+ **Numbers** (detect the numbers not exist in Source text)
+ **TTX, XLZ tag check** (both Missing and Added one)
+ **Length** (the length of Source and Target is different more/less than +- 50%)
+ **Skipped Translation, Blank**
+ **Alphabet or Numeric figures in the Target not exist in the Source** (only when Target is non-Alphabet language)
+ **Alphabet or Numeric figures in the Source not exist in the Target** (only when Source is non-Alphabet language)

Which files can be checked?
------
+ XLZ (for example, Idiom)
+ TTX
+ TMX
+ TXT (tab-separated file)
+ CSV (LocStudio dump by CSVDump add-in)
+ XLS/XLSX (read as column A = Souorce, column B = Target, column C = Comment)
+ RTF/DOC/DOCX (Trados format bilingual)
+ TBX

Features
--------
+ 英語の原形を用語集の原文に指定した場合は、活用形まで拡張して検索対象に含めます。  
  オプションで機能のオン/オフを設定可能。  
  例: **write**であれば、**write|writes|writing|wrote|written**の活用形すべてにヒットします
+ 入力ファイルがユニコード系(UTF-8|UTF-16)であれば、多言語でも文字化けせずに表示できます。
+ 主観ではありますが、実際仕事現場で使う人間が作成しているので、出力レポートの見やすさ/使いやすさは高いと思います。
+ コードを公開してるので、なにがチェックされる (逆にされない) のか、読めば確認できます。そういう点ではリスクも含め全体を把握できます。

Environment
--------
Ruby 1.9.2 or 1.9.3  
Windows XP、Windows 7 Japanese  

Windows での文字化け回避のため、内部でShift-JISにしているので、デフォルトでは日本語OS環境でしか動きません (たぶん)。  
すこし調整すれば他の言語のOSでも動くと思います  

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
       bilingual: チェック対象のバイリンガルファイルがあるパス  
       output: レポートの出力先  
       report: レポートの出力フォーマット (現在xlsのみ)  
       source: 原文言語  
       target: 訳文言語  
       glossary: 用語集ファイルのパス  
       monolingual: 単一言語用のチェックファイルのパス  

    check:　実行したいチェックをtrueにし、実行しないものはfalseにする  
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
       filter_by: フィルタしたい時に文字列を記入する。XLZのNoteでフィルタします。ここに書いた文字列と完全一致したときのみチェックされます  
       ignore100: true/false。TTX/XLZで100%をチェック対象外にしたい時はtrue、そうでないときはfalse  
       ignoreICE: true/false。XLZでICE Matchをチェック対象外にしたい時はtrue、そうでないときはfalse  

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

オプションは
+ **i**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Ignore Case + オートコンバージョンを行う*
+ **m**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*multiline + オートコンバージョンを行う*
+ **e**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Extended + オートコンバージョンを行う*  
+ **#**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*必ず冒頭に書く。自分で正規表現を書くとき。オートコンバージョンをオフにする。*  
の組み合わせまたは以下です。  
+ **z**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*正規表現は使用しないが、大文字小文字の区別のみ無効にしたいとき*
+ **空欄**&nbsp;&nbsp;&nbsp;&nbsp;*コンバージョンなし。大文字小文字の区別あり。書いたまま*  

正規表現については、[rubular](http://rubular.com/) で確認できます。  
*必ず「原文&nbsp;&nbsp;&nbsp;&nbsp;訳文&nbsp;&nbsp;&nbsp;&nbsp;オプション」の3列必要です。*  
*空欄にするときも、3列は作成して、値を空としてください*

オートコンバージョンとは、例えばwriteであれば、write|writes|writing|wrote|writtenの活用形すべてにヒットするようにツール側でコンバージョンをすることです。

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

sのときは、Source (=原文)を、tのときはTarget (=訳文)の方をチェックします。  
オプションは用語集ファイルのものと同じです。  

正規表現については、[rubular](http://rubular.com/) で確認できます。  
*必ず「sまたはt&nbsp;&nbsp;&nbsp;&nbsp;検索する文字列&nbsp;&nbsp;&nbsp;&nbsp;オプション」の3列は必要です。*  
*4列目は任意ですが、空欄にするときも、3列は作成して、値を空としてください*

License
----------
Copyright &copy; 2012 Ayumu Hanba  
Distributed under the [GPL License][GPL].

[GPL]: http://www.gnu.org/licenses/gpl.html
