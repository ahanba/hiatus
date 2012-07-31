hiatus
===========================
**hiatus** is a QA (Quality Assurance) tool for localization.  
For more details, please see http://www.slideshare.net/ahanba/how-to-use-hiatus

検出可能なチェック項目
------
+ **用語集** (正規表現対応)
+ **原文/訳文どちらか一方からの文字列検出チェック** (正規表現対応。スタイルガイドなどを想定)
+ **Inconsistency** (原文 => 訳文、訳文 => 原文の両方可)
+ **数値** (原文にない数値をエラー検出)
+ **TTX、XLZでのタグの追加削除検出**
+ **長さ** (原文と訳文の長さが一定割合以上異る)
+ **翻訳抜け、空欄**
+ **原文にない英数文字列の検出** (訳文が非アルファベット言語の時のみ有効)
+ **訳文にある英数文字列が原文にない場合の検出** (原文が非アルファベット言語の時のみ有効)

対象ファイル (拡張子)
------
+ XLZ (Idiomなど)
+ TTX
+ TMX
+ TXT (シンプルなタブ区切り)
+ CSV (LocStudioをCSVDumpで出力したものに対応)
+ XLS/XLSX (A列 = 原文、B列 = 訳文、C列 = コメントとして読み込みます)
+ RTF/DOC/DOCX (Trados 形式のバイリンガル)
+ TBX

特長
--------
+ 英語の原形を用語集の原文に指定した場合は、活用形まで拡張して検索対象に含めます。  
  オプションで機能のオン/オフを設定可能。  
  例: **write**であれば、**write|writes|writing|wrote|written**の活用形すべてにヒットします
+ 入力ファイルがユニコード系(UTF-8|UTF-16)であれば、多言語でも文字化けせずに表示できます。
+ 主観ではありますが、実際仕事現場で使う人間が作成しているので、出力レポートの見やすさ/使いやすさは高いと思います。
+ コードを公開してるので、なにがチェックされる (逆にされない) のか、読めば確認できます。そういう点ではリスクも含め全体を把握できます。

動作環境
--------
Ruby 1.9.2 or 1.9.3  
Windows XP、Windows 7 Japanese  

Windows での文字化け回避のため、内部でShift-JISにしているので、デフォルトでは日本語OS環境でしか動きません (たぶん)。  
すこし調整すれば他の言語のOSでも動くと思います  

必要なライブラリ
---------
**tk** ([Ruby](http://rubyinstaller.org/)インストール時に tk もインストールすること)  
gem install **nokogiri**  
gem install **zip**  

設定方法
---------
config.yamlに必要な情報を記載して、hiatus.rbを実行すると、エラーレポートが生成されます

###入力項目の詳細は以下###

     required:  
       bilingual: チェック対象のバイリンガルファイルがあるフォルダパス (サブフォルダ含む)  
       output: レポートの出力先フォルダパス  
       report: レポートの出力フォーマット (現在xlsのみ)  
       source: 原文言語  
       target: 訳文言語  
       glossary: 用語集ファイルのフォルダパス (サブフォルダ含む)  
       monolingual: 単一言語用のチェックファイルのフォルダパス (サブフォルダ含む)  

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

用語集ファイルの設定
------------
タブ区切りのテキストファイルを使用します (TSV ファイル)。  
UTF-8 without BOMがおすすめですが、エンコードは自動判定されるので、ほかのエンコードでも動くと思います。  
入力形式は以下

**原文&nbsp;&nbsp;&nbsp;&nbsp;訳文&nbsp;&nbsp;&nbsp;&nbsp;オプション**  
スペースはタブ。「原文[tab]訳文[tab]オプション」 

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

単一言語用チェックファイルの設定
--------
タブ区切りのテキストファイルを使用します (TSV ファイル)。  
UTF-8 without BOMがおすすめですが、エンコードは自動判定されるので、ほかのエンコードでも動くと思います。  
入力形式は以下

**sまたはt&nbsp;&nbsp;&nbsp;&nbsp;検索する文字列&nbsp;&nbsp;&nbsp;&nbsp;オプション&nbsp;&nbsp;&nbsp;&nbsp;表示メッセージ**  
スペースはタブ。「sまたはt[tab]検索する文字列[tab]オプション[tab]表示メッセージ」  

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

ライセンス
----------
Copyright &copy; 2012 Ayumu Hanba  
Distributed under the [GPL License][GPL].

[GPL]: http://www.gnu.org/licenses/gpl.html
