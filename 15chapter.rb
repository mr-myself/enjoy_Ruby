# encoding: utf-8

# ----- IOクラス ----- #
# 標準入力
## 組み込み定数STDINか、グローバル変数$stdin

# 標準出力
## 組み込み定数STDOUTか、グローバル変数$stdout

# 標準エラー
## 組み込み定数STDERRか、グローバル変数$stderr

$stdout.print "Output to $stdout.\n"
$stderr.print "Output to $stderr.\n"

# 出力ファイルにリダイレクトすると
# 標準出力への書き込みはファイルに書き込まれ、標準エラー出力への書き込みのみが
# 画面に表示される
## > ruby 15chapter.rb > log.txt

# IOオブジェクトがコンソールに関連付けられているか確認
if $stdin.tty?
  print "Stdin is a TTY\n"
else
  print "Stdin is not a TTY\n"
end
#=> Stdin is a TTY

# ファイルへの入出力
# io = open(file, mode)
# io = File.open(file, mode)
# io.close
## 1つのプログラムが同時に開けるファイル数には制限があるのでなるべく閉じるべき
## opneメソッドにブロックを渡せばcloseメソッドの省略可
File.open("foo.txt") do |io|
  while line = io.gets

  end
end

io = File.open("foo.txt")
io.close
p io.closed? #=> true

# 一度に読み込みたい場合はFile.readメソッドも可
data = File.read("foo.txt")

# open-uriライブラリを使うとHTTPやFTPのURLを普通のファイルのように開くことができる
# File.readではなくopenメソッドを使用する
=begin
require "open-uri"

#HTTP経由でデータを取得

open("http://ruby-lang.org") do |io|
  puts io.read
end
=end

#FTP経由でデータを取得
=begin
open("ftp://www.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7.tar.gz") do |io|
  open("ruby-1.8.7.tar.gz", "w") do |f|
    f.write(io.read)
  end
end
=end

# HTTPでは日本語か英語どちらかのページを返すかなどの内容が必要
# Accept-Language
# openメソッドの第2引数にハッシュ形式のオプションとして渡す
=begin
require "open-uri"

options = {
  "Accept-Language" => "ja, en;q=0.5"
}
open("http://ruby-lang.org", options){|io|
  puts io.read
}
=end


# ----- stringioライブラリ ----- #
# 実際にコンソールに出力を行なってしまうとプログラムからそれを取り出すことができない
# IOオブジェクトの振りをするオブジェクトに出力をしてあと確認する

require "stringio"

io = StringIO.new
io.puts("A")
io.puts("B")
io.puts("C")
io.rewind
p io.read #=> "A\nB\nC\n"


require "stringio"

io = StringIO.new("A\nB\nC\n")
p io.gets #=> "A\n"
p io.gets #=> "B\n"
p io.gets #=> "C\n"


# 基本的な入出力操作
## io.gets(rs)
## io.each(rs)
## io.each_line(rs)
## io.readlines(rs)
# IOクラスのオブジェクトioからデータを1行読み込む
# 行の区切りは引数で指定。デフォルトでは改行が行区切り
# 行の末尾の改行を含む文字列が返されるので、削除するにはchomp!メソッドが便利

# getsメソッドは入力の終わりに達してからさらに読み込むとnilを返す
# 終わりまで読み込んだかどうかはeof?メソッドで確認できる

=begin
while line = io.gets # getsメソッドを使う際のイディオムとも言える書き方
  line.chomp!
end
p io.eof?
=end

=begin
io.each do |line| # 上に書いた通り、io.eachで1行ずつ読み込める
  line.chomp!
end
=end

# readlinesメソッドを使って一気に終わりまで読んで、
# 各業を要素とする配列を取得することも可能
=begin
ary = io.readlines
ary.each do |line|
  line.chomp!
end
=end


# io.lineno
# getsやeachを使うとナン業まで読み込んだかが自動的に記録される
# それを取得可能。変更も可能
## 次は標準入力を1行ずつ読み込んで、先頭行番号を追加して出力
=begin
while line = $stdin.gets # 動かしてみるとどういうことかわかりやすい
  printf("%3d %s", $stdin.lineno, line)
end
=end

# io.read(size) サイズを指定して読み込み。指定しなければ終わりまで一気に読み込んで全体を返す
File.open("foo.txt") do |io|
  p io.read(5) #=> "this "
  p io.read #=> "is sample program.\nこれはサンプルです\nHello, Ruby.\n\n"
end

# 文字列に改行文字を補ってから出力
# Stringクラス以外のオブジェクトを渡したときはto_sメソッドを呼び出して文字列にする
$stdout.puts "foo", "bar", "baz" #=> foo bar baz

# 引数に指定した文字列を出力。複数の引数を受け取れる。String以外は文字列変換
io.print

# 書式指定付き出力
p io.printf("%4d", 123) #=> nil, 使い方がよくわからん

# io.write(str)
size = $stdout.write("Hello.\n") #=> Hello.
p size #=> 7

# io << str 引数で指定した文字列を出力
p io << "foo" << "bar" # つなげて書くこともできる


# ----- ファイルポインタ ----- #
# pos...現在のファイルポインタの位置
# pos=...ファイルポインタの位置を変更
File.open("foo.txt") do |io|
  p io.read(5) #=> "this "
  p io.pos #=> 5
  io.pos = 0
  p io.gets #=> "this is sample program.\n"
end

# ファイルポインタをファイルの先頭に戻す
File.open("foo.txt") do |io|
  p io.gets #=> "this is sample program.\n"
  io.rewind
  p io.gets #=> "this is sample program.\n"
  p io.gets #=> "これはサンプルです\n"
end

# ファイルの長さを引数で指定したサイズに切り詰め
io.truncate(0)     # ファイルサイズを0にする
io.truncate(io.pos) # 現在のファイルポインタ以降のデータを削除する

# バイナリモードとテキストモード...よくわからなかったので出てきた時


# ----- バッファリング ----- #
# IOオブジェクトに書き込み、writeやprintでIOオブジェクトに操作を行うと、
# プログラム内部の領域にいったんコピーを作成する（この領域をバッファという）
# このように中間のバッファを使ってデータを処理することをバッファリングという
# バッファに一定のサイズのデータが蓄えられると、出力を行いバッファを空にする

# 標準出力と標準エラー出力のうち、標準エラー出力はバッファリングを全く行わない
$stdout.print "out1 "
$stderr.print "err1 "
$stdout.print "out2 "
$stdout.print "out3 "
$stderr.print "err2\n"
$stdout.print "out4\n"
# 本によるとerr部分が先に出力されるって書いてあるけど、普通にこの順に出力されてもおた

# io.flushで強制的に出力させて即座に反映させることもできる
$stdout.print "out1 "; $stdout.flush
$stderr.print "err1 "
$stdout.print "out2 "; $stdout.flush
$stdout.print "out3 "; $stdout.flush
$stderr.print "err2\n"
$stdout.print "out4\n"

# 上記のように書かなくとも、io.sync = true を使えば、バッファの度にflushが呼ばれるようになる
$stdout.sync = true
$stdout.print "out1 "
$stderr.print "err1 "
$stdout.print "out2 "
$stdout.print "out3 "
$stderr.print "err2\n"
$stdout.print "out4\n"


# ----- コマンドとのやり取り ----- #
# Ruby以外の他のコマンドを利用してデータを処理するときに使う
# IO.popen(command, mode) ...mode省略時は"r"とみなされる

# 拡張子が.gzの場合、gunzipコマンドで展開したデータを処理するサンプル
=begin
pattern = Regexp.new(ARGV[0])
filename = ARGV[1]
if /.gz$/ =~ filename
  file = IO.popen("gunzip -c #{filename}")
else
  file = File.open(filename)
end
while text = file.gets do
  if pattern =~ text
    print text
  end
end
=end

# openメソッドの引数にパイプ記号をつけたコマンドを渡すとIO.popenと同じ
filename = ARGV[0]
open("|gunzip -c #{filename}") do |io|
  while line = io.gets
    print line
  end
end

# IOクラスのエンコーディング
p Encoding.default_external #=> #<Encoding:UTF-8>
p Encoding.default_internal #=> nil
# IOオブジェクトにエンコーディング情報設定するにはio.set_encodingを使うか
# File.openメソッドの引数として指定

