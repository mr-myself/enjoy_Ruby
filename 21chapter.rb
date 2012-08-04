# encoding: utf-8

# ----- Mix-in ----- #
module M
  def meth
    puts 'meth'
  end
end

class C
  include M
end

c = C.new
c.meth #=> 'meth'


class Book
  include Comparable

  def <=>(other)
    t = @genre.to_s <=> other.genre.to_s
    return t if t !=0
    return @title <=> other.title
  end

  attr_accessor :title, :author, :genre
  def initialize(title, author, genre=nil)
    @title = title
    @author = author
    @genre = genre
  end
end

ary = []
ary << Book.new("Software", "Rocker", "SF")
ary << Book.new("BABEL-17", "Delany", "SF")
ary << Book.new("Programing Perl", "Wall", "Computer")
ary << Book.new("Programing Pearls", "Bentley", "Computer")

ary.sort.each do |book|
  printf "%-10s %-20s %s\n",
    book.genre, book.title, book.author
end

module Enumerable
  def collect
    ary = []
    each do |item|
      ret = yiekd(item)
      ary.push(ret)
    end
    return ary
  end
end


# -------------------

module M
  def meth()
    puts 'M#meth'
  end
end

class C
  include M
  def meth()
    puts 'C#meth'
  end
end

c = C.new
c.meth #=> C#meth →同じ名前がある場合、引用元のクラスの方が優先される


module M1
end

module M2
end
class C
  include M1
  include M2
end

p C.ancestors #=> [C, M2, M1, M, Object, Kernel, BasicObject]
              # あとからインクルードされたものが優先される
              # Kernelとはpメソッドやraiseメソッドのような
              # どのオブジェクトにも属さない昨日が実装されたモジュール
              # BasicObjectは1.9から導入された最小限の機能しか持たないクラス

# インクルードが入れ子になった場合も検索順は順になる

# 同じモジュールを2階以上インクルードした場合、2回目以降は無視される

# ----- 特異メソッド ----- #
# インスタンスメソッドをクラスとは関係なく個々のオブジェクトに定義することもできる
str = 'たのしいRuby'
def str.edition(n)
  "#{self}　第#{n}版"
end

p str.edition(3) #=> "たのしいRuby　第3版"
# このeditionメソッドはこのオ振ジェクトに対してのみ呼び出せる
# このようにオブジェクトに直接関連づいたメソッドを特異メソッドという

# 特異クラス
str2 = 'マジたのしいRuby'
class << str2
  def edition(n)
    "#{self} 第#{n}版"
  end
end

p str2.edition(3) #=> "マジたのしいRuby 第3版"
# 特異クラスはそのオブジェクトが属するクラスよりも優先される

# extendメソッドでモジュールを特異クラスにインクルードしてオブジェクトにモジュールの機能を追加
module Edition
  def edition(n)
    "#{self} 第#{n}版"
  end
end

str3 = "ホンマにたのしいRuby"
str3.extend(Edition) # モジュールをオブジェクトにMix-inする

p str3.edition(5) #=> "ホンマにたのしいRuby 第5版"


# クラスに対してextendメソッドによってクラスメソッドを追加し、
# includeメソッドによってインスタンスメソッドを追加
module ClassMethod
  def cmethod
    puts 'class method'
  end
end

module InstanceMethods
  def imethod
    puts 'instatnce method'
  end
end

class MyClass
  # extendするとクラスメソッドを追加できる
  extend ClassMethod
  # includeするとインスタンスメソッドを追加できる
  include InstanceMethods
end

MyClass.cmethod #=> class method
# MyClass.imethodはインスタンスメソッドなのでエラー
MyClass.new.imethod #=> instatnce method

# クラスメソッドはレシーバがクラス自体
# インスタンスメソッドはオブジェクトがレシーバってところがごっちゃになるから注意！(・∀・)
