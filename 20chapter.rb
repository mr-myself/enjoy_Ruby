# encofing: utf-8

# ----- ブロック----- #

5.times do
  puts "test"
end

sum = 0
(1..5).each do |i|
   sum += i
end

puts sum #=> 15

fruits = ['banana', 'momo']
fruits.each do |elem|
  puts elem
end

sum = 0
outcome = {'join cost'=>1000, 'strap'=>300, 'kaihi'=>200}
# ブロック変数をひとつにすれば['join cost', 1000]のように
# キーと値という組み合わせの配列が渡される
# ふたつにすればそれぞれが入る形
outcome.each do |item|
  p item
end

# ファイルの場合テキストファイルの1行を要素の単位としている
f = File.open("foo.txt")
p f
f.each_line do |line| # each_lineとしても同じ結果
  print line
end
f.close

# あと処理を確実に実行させる
File.open("foo.txt") do |f|
  f.each_line do |line|
     p line
  end
end
# File.openメソッドにブロックを与えた場合は、
# ブロック内の処理が終了してメソッドから抜ける前にファイルを閉じてくれる


# sort
array = ['an', 'beside', 'controll']
sorted = array.sort do |a, b|
  b <=> a # <=> は左が大きければ1、等しければ0、右が大きければ−1を返す
end
p sorted #=> ["controll", "beside", "an"]

sorted = array.sort do |a, b|
  a.length <=> b.length
end
p sorted #=> ["an", "beside", "controll"]

# sortするにあたって何回lengthメソッドが呼び出されるか
ary = %w(1 2 3 4 5 6 7 8 9)
num = 0
ary.sort do |a, b|
  num += 2
  a.length <=> b.length
end
p num #=> 16
# 無駄に呼び出される

ary = %w(1 2 3 4 5 6 7 8 9)
num = 0
ary.sort_by do |item|
  item.length
  num +=1
end
p num #=> 9

# ----- 本のリストクラスを作る ----- #
class Book
  attr_accessor :title, :author, :genre
  def initialize(title, author, genre=nil)
    @title = title
    @author = author
    @genre = genre
  end
end

class BookList
  def initialize()
    @booklist = Array.new
  end

  def add(book)
    @booklist.push(book)
  end

  def length
    @booklist.length
  end

  def [](n=book)
    @booklist[n] = book
  end

  def [](n)
    @booklist[n]
  end

  def delete
    @booklist.delete(book)
  end

  def each
    @booklist.each do |book|
      yield book
    end
  end

  def each_title
    @booklist.each do |book|
      yield book.title
    end
  end

  def each_title_author
    @booklist.each do |book|
      yield book.title, book.author
    end
  end

  def find_by_author(author)
    if block_given? # ブロックが与えられていたら
      @booklist.each do |book|
        if author =~ book.author
          yield book
        end
      end
    else # ブロックがない場合
=begin 普通にやったら
    result = []
      @booklist.each do |book|
        if author =~ book.author
          result << book
        end
        reutrn result
      end
=end
    # Enumerable#selectメソッドを使う
      @booklist.select do |book|
        author =~ book.author
      end
    end
  end
end

booklist = BookList.new
b1 = Book.new("semete,honkakurashiku", "heijokyo")
b2 = Book.new("Neo Aqua III", "Neo Aqua")

booklist.add(b1)
booklist.add(b2)

p booklist[0].title #=> "semete,honkakurashiku"
p booklist[1].title #=> "Neo Aqua III"

booklist.each_title_author do |title, author|
  puts 'start!'
  p title, author
end

author_regexp = /heijokyo/
booklist.each do |book|
  if author_regexp =~ book.author
    print book.title
  end
end
booklist.find_by_author(/heijokyo/) do |book|
  p book.title
end

books = booklist.find_by_author(/heijokyo/)
puts '!!check!!'
p books #=> [#<Book:0x97a5dd8 @title="semete,honkakurashiku", @author="heijokyo", @genre=nil>]


# Procメソッドとしてブロックを渡す
pr = Proc.new do
  p 'a'
end

p 'b'

pr.call() # callメソッドが呼ばれて初めて処理開始
#=> 'b'
#=> 'a'

# メソッドからメソッドにブロックを変数を使って明示的に渡す
# &を付けて渡すことができる
def foo(a, b, &block)
  p "begin block"
  foo2(a, b, &block)
  p "end block"
end

def foo2(a, b, &block)
  p "begin block2"
  block.call(a, b)
  p "end block 2"
end

foo("a1", "b1") do |a, b|
  p a
  p b
end
=begin
#=>
"begin block"
"begin block2"
"a1"
"b1"
"end block 2"
"end block"
=end


# Enumeratorクラス
str = "abcde"
enum = str.enum_for(:each_char)
ary = enum.each do |char|
  p char
end

ary = enum.collect do |char|
  char
end
p ary #=> ["a", "b", "c", "d", "e"]
