#encoding: utf-8

# 演算子
=begin
・左側の式から順に評価される
・論理式の真偽が決定すると、残りの式は評価されない
・最後に評価された式の値が論理式全体の値となる
=end
var = Array.new
var || "Ruby"
# ・varがオブジェクトを参照していたらその値
# ・varがnilまたはfalseの場合は、文字列"Ruby"

name = "Ruby"
if var != nil
  name = var
end

# 上のコードと同じ事を1行でできる

name = var || "Ruby" # この書き方は変数にデフォルト値を与える場合のイディオム
# 順番に評価されるから。varが偽の時しか"Ruby"は参照されない

ary = Array.new
item = nil
if ary
  item = ary[0]
end

# 上と同じ事を1行で

item = ary && ary[0]


# 条件演算子(三項演算子)
a = 1
b = 2
v = (a > b) ? a : b
p v #=> 2

p var2 ||=1 #=> 1


# 範囲演算子
# Range.new(1, 10)
# 1..10
sum = 0
for i in 1..5
  sum += i
end
puts sum #=> 15

alpha = ["a", "b", "c", "d", "e"]
alpha[2..4] = ["C", "D", "E"]
p alpha #=> ["a", "b", "C", "D", "E"]
# 「x...y」は、yを範囲に含めない

# 演算子を定義
# 二項演算子, 単項演算子
class Vector
  attr_reader :x, :y
  def initialize(x=0, y=0)
    @x, @y = x, y
  end

  def inspect
    "(#{@x}, #{@y})"
  end

  def +(other)
    Vector.new(@x + other.x, @y + other.y)
  end

  def -(other)
    Vector.new(@x - other.x, @y - other.y)
  end

  def +@
    self.dup
  end

  def -@
    Vector.new(-@x, -@y)
  end

  def ~@
    Vector.new(-@y, -@x)
  end

  def [](idx)
    case idx
    when 0
      @x
    when 1
      @y
    else
      raise ArgumentError, "out of range '#{idx}'"
    end
  end

  def []=(idx, val)
    case idx
    when 0
      @x = val
    when 1
      @y = val
    else
      raise ArgmentError, "out of range '#{idx}'"
    end
  end
end

vec0 = Vector.new(3, 6)
vec1 = Vector.new(1, 8)

p vec0 #=> (3, 6)
p vec1 #=> (1, 8)
p vec0 + vec1 #=> (4, 14)
p vec0 - vec1 #=> (2, -2)

vec = Vector.new(3, 6)
p +vec #=> (3, 6)
p -vec #=> (-3, -6)
p ~vec #=> (-6, -3)

vec = Vector.new(3, 6)
p vec[0]
p vec[1] = 2
p vec[1]
p vec[2]
