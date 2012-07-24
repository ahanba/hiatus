hiatus
===========================
hiatus is a QA (Quality Assurance) tool for localization.  
For more details, please see http://www.slideshare.net/ahanba/how-to-use-hiatus

検出可能なチェック項目
------
+ 用語集 (正規表現対応)
+ 原文/訳文どちらか一方からの文字列検出チェック (正規表現対応)
+ Inconsistency (原文 => 訳文、訳文 => 原文の両方可)
+ 数値 (原文にない数値をエラー検出)
+ TTX、XLZでのタグの追加削除検出
+ 長さ (原文と訳文の長さが一定割合異常異る)
+ 翻訳抜け、空欄
+ 原文にない英数文字列の検出 (訳文が非アルファベット言語の時のみ有効)
+ 訳文にある英数文字列が原文にない場合の検出 (原文が非アルファベット言語の時のみ有効)

対象ファイル (拡張子)
------
1. XLZ (Idiomなど)
2. TTX
3. TMX
4. TXT (シンプルなタブ区切り)
5. CSV (LocStudioをCSVDumpで出力したものに対応)
6. XLS/XLSX (A列 = 原文、B列 = 訳文、C列 = コメントとして読み込みます)
7. RTF/DOC/DOCX (Trados 形式のバイリンガル)
8. TBX

特長
--------
+ 英語の原形を用語集の原文に指定した場合は、活用形まで拡張して検索対象に含めます。  
  オプションで機能のオン/オフを設定可能。
  例: writeであれば、write|writes|writing|wrote|writtenの活用形すべてにヒットします

+ 入力ファイルがユニコード系(UTF-8|UTF-16)であれば、多言語でも文字化けせずに表示できます

動作環境
--------
Ruby 1.9.2 or 1.9.3  
Windows XP、Windows 7 Japanese  

Windows での文字化け回避のため、内部でShift-JISにしているので、デフォルトでは日本語OS環境でしか動きません (たぶん)。  
すこし調整すれば他の言語のOSでも動くと思います  

必要なライブラリ
---------
tk (Ruby インストール時に tk もインストールすること)  
gem install nokogiri  
gem install zip  

設定方法
---------
config.yamlに必要な情報を記載して、hiatus.rbを実行すると、エラーレポートが生成されます

###入力項目の詳細は以下###

     required:  
       bilingual: チェック対象のバイリンガルファイルがあるパス  
       output: レポートの出力先  
       report: レポートの出力フォーマット (現在xlsのみ)  
       source: 原文言語  
       target: 訳文言語  
       glossary: 用語集ファイルのパス  
       monolingual: 単一言語用のチェックファイルのパス  

    check:　>実行したいチェックをtrueにし、実行しないものはfalseにする  
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
テキストファイルで保存します。  
UTF-8 without BOMがおすすめですが、エンコードは自動判定されるので、ほかのエンコードでも動くと思います。  
入力形式は以下

**原文	訳文	オプション**  
スペースはタブ。「原文[tab]訳文[tab]オプション」  

オプションは
+ i (Ignore Case)
+ m (multiline)
+ e (Extended)
の組み合わせまたは以下です。
+ # (自分で正規表現を書くとき。ツール側でのコンバージョンは何も行わない。)
+ z (正規表現は使用しないが、大文字小文字の区別のみ無効にしたいとき)
+ 空欄 (コンバージョンなし。大文字小文字の区別あり。書いたまま)

      First Server	 ファースト サーバー	i
      node	ノード
　　　　  delegate	委譲する	i
      install	インストール	i


正規表現については、[rubular](http://rubular.com/) で確認できます。オプションを空欄にすると正規表現がオフになります。  
*必ず「原文	訳文	オプション」の3列必要です。*  
*空欄にするときも、3列は作成して、値を空としてください*


単一言語用チェックファイルの設定
--------
テキストファイルで保存します。  
UTF-8 without BOMがおすすめですが、エンコードは自動判定されるので、ほかのエンコードでも動くと思います。  
入力形式は以下

**s/t	検索する文字列	オプション	表示メッセージ**  
スペースはタブ。「s/t[tab]検索する文字列[tab]オプション[tab]表示メッセージ」  

    t	；	#	全角セミコロン；を使用しない
    t	[［］]	#	全角角括弧 ［］ を使用しない
    t	[０１２３４５６７８９]+	#	全角数字を禁止
    s	not	z	否定文？

s/tはsまたはtと入力します。  
sのときは、Source (=原文)を、tのときは　Target (=訳文)の方をチェックします。  
オプションはi (Ignore Case), m (multiline), e (Extended)の組み合わせです。  

正規表現については、[rubular](http://rubular.com/) で確認できます。オプションを空欄にすると正規表現がオフになります。  
*必ず「s/t	検索する文字列	オプション」の3列必要です。*  
*4列目は任意ですが、空欄にするときも、3列は作成して、値を空としてください*

ライセンス
----------
Copyright &copy; 2012 Ayumu Hanba  
Distributed under the [MIT License][mit].

[MIT]: http://www.opensource.org/licenses/mit-license.php
