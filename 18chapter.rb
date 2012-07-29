#encoding: utf-8
=begin

コマンドラインオプション
* -c :文法チェック
* -d :デバッグモードの設定
  $DEBUG変数を使うことができる
  -dを指定すると$DEBUGがtrueになる
    print some_var if $DEBUG
  は、普段は何もしないがデバッグ時には変数some_varの値を表示する
  ※これできるけどエラー出る。要確認

* -s :スクリプトにスイッチを与える
      ruby -s switch.rb -test -foo
=end

# -w 冗長モード
class WarningTest
  def initialize
    @test = "test"
  end

  def test
    print @tset, "\n" # @testを@tsetとミスタイプ
  end
end

sample_test = WarningTest.new
sample_test.test #=> -w で実行した場合、18chapter.rb:24: warning: instance variable @tset not initialized
                 #   と警告を出してくれる

# ワンライナーの実行
# ruby -e 'puts "Hello, World!"'

# Unixでは先頭に#!/usr/bin/rubyと書くとRubyのスクリプトを実行ファイルのように扱える


# __File__と__LINE__ 実行中のプログラムのファイル名と行番号を表す。デバッグ時に便利
puts "file #{__FILE__}: #{__LINE__}"

# __FILE__の使い方。サンプルコードを書く場合に利用する
class Foo
  def initialize
    puts "foo!"
  end
end

if __FILE__ == $0 # $0は組み込み変数$PROGRAM_FILEの別名
  Foo.new # サンプルコード
end
# $0で見ているため、ライブラリとして読み込まれた場合にif以下は一致しない。
# この機能を利用してプログラムをライブラリ自身に埋め込んだりできる

# __method__で現在のメソッド名を取得することもできる
class Foo
  def my_method
    p __method__
  end
end

Foo.new.my_method #=> :my_method


# alias:すでに存在するメソッドに別の名前を割り当てたい場合
class C1  # C1クラスの定義
  def hello
    "hello"
  end
end

class C2 < C1 # C1クラスを継承してC2クラスの定義
  alias old_hello hello # 別名old_helloを設定

  def hello
    "#{old_hello}, again"
  end
end

obj = C2.new
p obj.old_hello #=> "hello"
p obj.hello #=> "hello, again"
# C1を直接変更しているわけではないのでC1.new.old_helloとかはできない

# undef: 定義されたメソッドをなかったことにできる
# undef メソッド名


# ----- 多重代入 ----- #
@a = 'a'
@b = 'b'
@c = 'c'

@a, @b, @c = 'a', 'b', 'c' # 上記を多重代入する

# メソッドから複数の返り値を受け取る
def coordinate()
  x = "x"
  y = "y"
  z = "z"

  return x, y, z
end

a, b, c = coordinate()
p a, b, c #=> "x"
          #=> "y"
          #=> "z"

# 例えば変数の値を入れ替えるときに便利
a, b = 0, 1
tmp = a # 途中で値をなくしてしまうことがないように一時変数に入れる
a = b
b = tmp
p [a, b] #=> [1, 0]

# 多重代入を利用すると1行で可能
a, b = 0, 1
a, b = b, a
p [a, b] #=> [1, 0]

# 配列を代入するときにサ変に複数の変数があると、自動的に多重代入
ary = [1, 2]
a, b = ary
p a #=> 1
p b #=> 2

# 配列の先頭だけ取り出したい場合は次のようにも書ける（普通に0番指定でいいと思うけど）
ary = [1, 2]
a, = ary
p a #=> 1


# ----- メソッドに応用 ----- #
# 配列を展開してメソッドの引数にする
def foo(a, b, c)
  a + b + c
end
ary = [2, 3]
p foo(1, *ary) #=> 6
               # 「*配列」で、配列そのものではなく、配列の要素が先頭から順にメソッドに渡される

# 引数の数が決められないメソッドは次のようにして与えられた引数をまとめて配列として得られる
def foo(*args)
  p args
end

foo(1, 2, 3, "test") #=> [1, 2, 3, "test"]

# sprintfのように少なくとも1つは指定しなければならない場合
def meth(arg, *args)
  p arg
  p args
end

meth(1)       #=> 1
meth(1, 2, 3) #=> [2, 3]

def a(a, *b, c)
  p [a, b, c]
end

a(1, 2, 3, 4, 5, 6) #=> [1, [2, 3, 4, 5], 6]


# 入れ子になった配列の要素を取り出す
ary = [1, [2, 3], 4]
a, b, c = ary
p a #=> 1
p b #=> [2, 3]
p c #=> 4

ary = [1, [2, 3], 4]
a, (b1, b2), c = ary # 配列に対応する形で代入する
p a  #=> 1
p b1 #=> 2
p b2 #=> 3
p c  #=> 4


# もう少し複雑なものを取得
hash = { :a=>100, :b=>200, :c=>300 }
hash.each_with_index do |(key, value), index|
  p [key, value, index] #=> [:a, 100, 0]
                        #=> [:b, 200, 1]
                        #=> [:c, 300, 2]
end

hash = { :a=>10, :b=>20, :c=>30 }
hash.each_with_index do |index, key|
  p [index, key] #=> [[:a, 10], 0]
                 #=> [[:b, 20], 1]
                 #=> [[:c, 30], 2]
end


# ----- ローカル変数 ----- #
# 以下のvarはすべて異なる変数
var = 1 # ファイル内のvar
class Foo
  var = 2 # クラス定義内のvar
  def meth
    var = 3 # メソッド定義内のvar
  end
end


def local_scope_test(n)
  if n > 0
    positive = true
  elsif n < 0
    negative = true
  else
    zero = true
  end
  return [positive, negative, zero]
end

p local_scope_test(1) #=> [true, nil, nil]
p local_scope_test(-1) #=> [nil, true, nil]
p local_scope_test(0) #=> [nil, nil, true]

# 上記のような場合ですべて初期化しなければならないのは手間なので、
# 変数を参照している箇所よりも前の行で代入文が存在する場合は
# 変数が暗黙に初期化されてnilが返されるルールになっている

x = 1
ary = [1, 2, 3]

ary.each do |x|
  # 何もしない
end

p x #=> 1

# ruby1.9以降ではブロック変数は常にブロック内でのみ有効

x = y = z = 0 # x, y, zを初期化
ary = [1, 2, 3]

ary.each do |x; y| # ブロック変数x, ブロックローカル変数yを使用
                   # ブロックローカル変数はブロック変数の後に;で区切って定義
  y = x
  z = x
  p [x, y, z] #=> [1, 1, 1]
              #=> [2, 2, 2]
              #=> [3, 3, 3]
end

p [x, y, z] #=> [0, 0, 3]
