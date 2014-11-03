satori_dictionary - 里々書式辞書ローダ
========================================

これはなにか
----------------------------------------

これは伺か用SHIORIサブシステムである美代(Miyo)の辞書フィルタプラグインです。

里々書式辞書の読み込み機能を提供します。

インストール
----------------------------------------

### 一般

    npm install miyojs-filter-satori_dictionary

### ゴーストに追加する場合

ghost/masterをカレントディレクトリとして同様に

    npm install miyojs-filter-satori_dictionary

含まれるフィルタ
----------------------------------------

### satori_dictionary_load

辞書の読み込みフィルタです。

### satori_dictionary_initialize

辞書の読み込みフィルタで使うメソッドをMiyoのインスタンスに付加するフィルタです。

最初のsatori_dictionary_loadで自動的に呼ばれますが、satori_dictionary_loadを使わずに辞書をロードしたい場合などにお使いください。

依存
----------------------------------------

このフィルタが依存するものはありません。

使用方法
----------------------------------------

以下のようにロードする辞書を指定します。

    _load:
    	filters: [..., satori_dictionary_load, ...]
    	argument:
    		satori_dictionary_load:
    			files: [dicA.txt]
    			directories: [./mode1]
    			aitalk_id: OnSatoriAITalk

filesとdirectoriesは関係がなく、どちらか1つでも良いです。

どちらもゴーストルートからのパス(カレントディレクトリ)か絶対パスです。

directoriesは名前にかかわらずそのフォルダ内の全ファイルを読みます。

すでに辞書に同名のエントリがあり、なおかつそれが配列でなかったときは読み込みが失敗します。

里々における名前のない「＊」が通常AIトークのエントリとして処理されますが、aitalk_idはそのIDを指定するものです。
指定しなければ「OnSatoriAITalk」が使われます。

このフィルタを実行した時点でMiyoのインスタンスには

- miyo.SatoriDictionaryLoader.load_file(file, options) - ファイル1つを里々辞書として読み込む
- miyo.SatoriDictionaryLoader.load_str(str, filepath, options) - 文字列を里々辞書として読み込む

が追加されています。

filepathは任意で、エラー時のファイル名として扱われます。

optionsは連想配列で、aitalk_idキーを指定できます。

satori_dictionary_loadを使わずにこれらメソッドを使う場合はsatori_dictionary_initializeを実行してください。

    _load:
    	filters: [..., satori_dictionary_initialize, ...]

注意
----------------------------------------

このフィルタは里々辞書のエントリ分割部分を処理するのみで、エントリの中身については処理しません。

つまりこのフィルタのみ使った場合は（１）や：はそのまま出力されます。

エントリの中身について里々辞書書式のように扱う場合は[miyojs-filter-satori_template](https://github.com/Narazaka/miyojs-filter-satori_template.git)等を使ってください。

これらエントリの分割とその内容のテンプレート処理は機能分離ができるものですので、個別のフィルタに分けられています。
