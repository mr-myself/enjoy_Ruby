#encoding: utf-8

# 正規表現オブジェクト
re = Regexp.new("Ruby")

# //かオブジェクト作るか%r(), %r<>, %r||, %r!!など
# 正規表現(=~)でマッチしない場合はnil、マッチした場合は文字列が始まる位置を返す

# メタ文字...「^」行頭、「$」行末
#            「\A」文字列の先頭、「\z」文字列の末尾

# いくつかの文字のうち、その1つを指定したい
# []を使う
## [AB] ...AまたはB
## [ABC] ...AまたはBまたはC ちなみに[]の中の順番は関係ない

# ひとかたまりの文字の範囲を指定するには
# 「-」を使う
## [A-Z] ...AからZまでのアルファベットの大文字全部
## [0-9] ...0から9までの数字全部
## [A-Za-z] ...AからZまでのアルファベットの大文字小文字全部

# 「-」は[]の中の最初か最後の文字として使うと単なる「-」の文字になる
## [A-Za-z0-9_-] ...アルファベットと数字全部と「_」と「-」
## また、[]の中で「^」を使うと、そこで指定されたもの以外の文字を表す
## [^a-zA-Z] ...アルファベット以外の文字

# 任意の文字とのマッチング
# 「.」は任意の1文字とのマッチ

# バックスラッシュを使ったパターン

## 「\」+「アルファベット1文字」で表現できる

## 「\s」 ...空白、タブ、改行文字、改頁文字とマッチ

## 「\d」 ...0から9までの数字とマッチ

## 「\w」 ...英数字にマッチする

## バックスラッシュのあとにメタ文字を書くことでメタ文字をその文字そのものとしてマッチできる

# 繰り返し
## 「*」 ...0回以上の繰り返し。その文字がでてこなくてもマッチすることに注意
## 「+」 ...1回以上の繰り返し
## 「?」 ...0回または1回の繰り返し

# 最短マッチ
## 「*?」 ...0回以上の繰り返しのうち最短の部分
## 「+?」 ...1回以上の繰り返しのうち最短の部分

# （）を使うと、複数の文字列の繰返しが表現できる
## /^(ABC)*$/など

# 「|」を使って幾つかの候補の中からどれか1つに当てはまるものにマッチ
## /^(ABC|DEF)$/など

# quoteでメタ文字すべてをエスケープ
# よって、quoteを使うと、メタ文字をメタ文字として使用できない
re1 = Regexp.new("abc*def") #「*」はcの0回以上のと解釈さてている
re2 = Regexp.new(Regexp.quote("abc*def"))
p (re1 =~ "abc*def") #=> nil
p (re2 =~ "abc*def") #=> 0


# ----- 正規表現のオプション ----- #
# /.../といったバックスラッシュの後ろに続けて「/.../ei」のように書く
# Regexp.newメソッドではオプション定数(Regexp::IGNORECASEなど。オプション文字ではない)を第2引数に指定できる。指定しないときはnilを与える
Regexp.new("Rubyスクリプト", nil)

## i ...アルファベットの大文字と小文字の違いを無視

## s, e, u, n ...文字コードを指定する
##               順に、Shift_JIS, EUC-JP, UTF-8, nは文字コードを意識しないマッチング

## x...正規表現内の空白と、「#」の後ろの文字を無視。#を使ってコメントが書けるようになる

## m...「.」が改行文字にもマッチする


# ----- キャプチャ ----- #
/(.)(.)(.)/ =~ "abc"
first = $1
second = $2
third = $3
p first  #=> "a"
p second #=> "b"
p third  #=> "c"

# ()を使うと、複数のパターンをまとめる場合にも用いられる書き方であるため、
# 不便な場合がある。必要のないパターンをまとめる場合は(?:)を使う
/(.)(\d\d)+(.)/ =~ "123456" #=> 「(\d\d)+」の部分はラストの部分にマッチする感じ。
                            #=> 「(\d\d)+?」と書くと、最短マッチなので"23"が得られる
p $1 #=> "1"
p $2 #=> "45"
p $3 #=> "6"

/(.)(?:\d\d)+(.)/ =~ "123456"
p $1 #=> "1"
p $2 #=> "6"


# 「$数字」以外にもあり、
# 「$`」はマッチした部分より前の文字列、「$&」は街した部分そのものの文字列、「$'」はマッチした部分より後ろの文字列
/C./ =~ "ABCDEF"
p $` #=> "AB"
p $& #=> "CD"
p $' #=> "EF"

# subとgsub
# マッチさせた部分を別の文字列に置き換えるメソッド
# subは最初にマッチした部分だけ、gsubはマッチする部分すべてを置き換え

str = "abc   def   g   hi"
p str.sub(/\s+/, ' ')  #=> "abc def   g   hi"
p str.gsub(/\s+/, ' ') #=> "abc def g hi"

# ブロックを取ることも可能。マッチした部分がブロックに返る
str = "abracatabra"
nstr = str.sub(/.a/) do |matched|
  '<' + matched.upcase + '>' #=> ただ<>と文字列結合してるだけ
end
p nstr #=> "ab<RA>catabra"

# scanメソッド
# 置換はしない。マッチした部分に何らかの処理を行うときに使う
"abracatabra".scan(/.a/) do |matched|
  p matched #=> "ra", "ca", "ta", "ra"
end
# また、正規表現の中で()が使われていると、
# そこにマッチした部分を配列にして返す
"abracatabra".scan(/(.)(a)/) do |matched|
  p matched #=> ["r", "a"]
            #=> ["c", "a"]
            #=> ["t", "a"]
            #=> ["r", "a"]
end
# さらに、ここでブロックの変数を()の数だけ並べると、
# 配列ではなくそれぞれの要素を取り出すことができる
"abracatabra".scan(/(.)(a)/) do |a, b|
  p a + "-" + b #=> "r-a"
                #=> "c-a"
                #=> "t-a"
                #=> "r-a"
end
# ブロックが使われていない場合、マッチした文字列の配列を返す
p "abracatabra".scan(/.a/) #=> ["ra", "ca", "ta", "ra"]

# ----- 正規表現の例 ----- #
str = "http://www.ruby-lang.org/ja/"
%r|http://([^/]*)/| =~ str
print "server address: ", $1, "\n" #=> server address: www.ruby-lang.org
