#encoding: utf-8

# 文字列の作り方
str = "文字列"
str2 = "結合させた#{str}"
p str2 #=> "結合させた文字列"

# ダブルクオーテーションと同等
desc = %Q{Rubyの文字列には「''」も「""」も使われます}
# シングルクォーテーションと同等
str = %q|Ruby said, 'Hello, world'|

# ----- ヒアドキュメント ----- #
# 「<<- "EOB"」を使うと行頭の空白文字とタブ文字が無視される
2.times do |i|
	2.times do |j|
		print(<<-"EOB")
i: #{i}
j: #{j}
i*j = #{i*j}
	EOB
	end
end
#=> i: 0
#=> j: 0
#=> i*j = 0
#=> i: 0
#=> j: 1
#=> i*j = 0
#=> i: 1
#=> j: 0
#=> i*j = 0
#=> i: 1
#=> j: 1
#=> i*j = 1

# 代入方法
str = <<-EOB
Hello!
Hello!
Hello!
EOB
p str #=> "Hello!\nHello!\nHello!\n"


# ----- printfとsprintf ----- #
num = 123
printf("%d\n", num)   #=> 123 ...%dは整数指定
printf("%4d\n", num)  #=>  123
printf("%04d\n", num) #=> 0123
printf("%+d\n", num)  #=> +123　...+や-を先頭に必ずつける指定ができる

# 同様のことが文字列でも可能
str = "Ruby"
printf("Hello,%s!\n", str) #=> Hello,Ruby! ...%sは文字列指定
printf("Hello,%8s!\n", str) #=> Hello,    Ruby!
printf("Hello,%-8s!\n", str) #=> Hello,Ruby    ! ...マイナスを指定すると左詰め

# sprintfはprintfと同様の結果を文字列オブジェクトとして生成できる
num = 123
num = sprintf("%06d", num)
p num #=> "000123"
# --------------------------- #


# 文字列が空かどうか調べる
p "".empty?    #=> true
p "foo".empty? #=> false

# 文字列の大きさ
p "1.9からは日本語文字列に対応".length #=> 15
p "1.9からは日本語文字列に対応".bytesize #=> 39 ...v1.8まではこちらが返ってくる

# 文字列を分割
str = "Ruby: split: the: difference"
column = str.split(/:/)
p column #=> ["Ruby", " split", " the", " difference"]
# バイト数で指定して分割することも可能
str = "Ruby split the difference"
column = str.unpack("a4a6a4a*") #=> 「*」は残り全部
p column #=> ["Ruby", " split", " the", " difference"]



# ----- エンコーディング ----- #
# 行頭の #encoding: utf-8 だけでは不十分な場合がある
# encode!("utf-8") などで明示的に変換
# open-uriなどでネットワーク越しにファイルを取得する場合、
# 適切な文字コードが分かる場合はforce_encodingメソッドを使用


# 文字列の結合
hello = 'hello'
world = 'world'
p hello + world #=> "helloworld"

hello = 'hello'
world = 'world'
hello << world
p hello #=> "helloworld"

hello = 'hello'
world = 'world'
p hello.concat(world) #=> "helloworld"

# 文字列の大小関係
p ("aaa" < "b") #=> true

# 改行文字の削除
# chop(必ず末尾1文字削除) & chomp（末尾が改行の場合のみ削除）
str = 'abc'
p str.chomp #=> 'abc'
p str.chop #=> 'ab'
str = "abc\ndef\n"
print str.chomp #=> printだと"abc", pだと"abc\ndef"で出力されるのはなんでやろ？

# while文とchompを組み合わせて使うと便利
=begin
while line = gets
	line.chomp!
	lineの処理
end
=end

# 文字列の検索 index（左側から）メソッドとrindex（右側(right)から）メソッド
str_index = "today is another day"
p str_index.index("day") #=> 2
p str_index.rindex("day") #=> 17
# 見つからなかった場合はnilを返す
# 含まれるかどうかだけ
p str_index.include?("day") #=> true

# s[n..m] n番目からm番目までを操作
# s[n, len] n番目からlen個を操作
str = 'abcde'
str[2, 1] = 'C'
p str #=> "abCde"


# ----- Enumerableメソッド ----- #
# 1.9からはStringクラスからeachメソッドがなくなった。
# each_line, each_byte, each_char（文字単位）を利用

# each_lineメソッドで取り出した行をcollectメソッドで処理
str = "あ\nい\nう\n"
tmp = str.each_line.collect do |line|
	line.chomp * 3
end
p tmp #=> ["あああ", "いいい", "ううう"]

# each_charメソッドで取り出した値をcollect
str = "abcdefg"
temp = str.each_char.collect do |line|
	line * 2
end
p temp #=> ["aa", "bb", "cc", "dd", "ee", "ff", "gg"]
# 配列で帰ってきてるところだけ注意かな(・∀・)

# 文字列の先頭と御末尾にある空白文字を削除
str = " abc d efg "
p str.strip #=> "abc d efg"

# ----- その他便利メソッド ----- #
str.upcase     #=> 大文字に変換
str.downcase   #=> 小文字に変換
str.swapcase   #=> 大文字を小文字に、小文字を大文字に変換
str.capitalize #=> 最初の文字を大文字に、以降の文字を小文字に変換

# 正規表現を使わない単純な置換
p "abc".tr("bc", "Aa") #=> "aAa"
p "日本語はいけるんか？".tr("はいけるんか？", "いけた！") #=> "日本語いけた！！！！" なぜかビックリマーク複製（笑）

# 日本語文字コードの変換

# nkfライブラリ
require "nkf"
# EUC-JPの文字列をUTF-8に変換する場合
euc_str = "日本語の文字列"
ut8_str = NKF.nkf("-E -w -xm0", euc_str)

# Ruby1.9で単に文字コード変換を行う場合はNKFモジュールやIconvクラスではなく、
# encodeメソッドを使うのがおすすめ by たのるび
#encoding: euc-jp
str = "日本語EUCの文字列"
str.encode!("utf-8")
p str.encoding #=> #<Encoding:UTF-8>
