#encoding: utf-8

# ----- 11章　練習問題 ----- #

# (1) 1から100までの整数が照準に並ぶ配列
a = Array.new(100){|i| i+1}
=begin
Answer: a = []
        100.times{|i| a[i] = i + 1}
=end


# (2) (1)の配列を100倍した配列。また、新しい配列を作成せずにすべての要素を100倍
a2 = a.collect{|i| i*100}
a.collect!{|i| i*100}


# (3) (1)の配列から3の倍数だけ取り出す。また、新しい配列を作成せずに3の倍数以外の数を削除
a = Array.new(100){|i| i+1}
a3 = []
a.each do |elem|
  if elem%3 == 0 then
    a3 << elem
  end
end

a.delete_if{|i| i%3 != 0}
=begin
Answer: a3 = a.reject{|i| i%3 != 0}
        rejectとdelete_ifはほぼ同義。
# 条件に当てはまるものだけ返す、selectもある
a4 = a.select{|i| i%3 == 0}
=end


# (4) (1)の配列を逆順に並べ替える
a = Array.new(100){|i| i+1}
a.reverse
=begin
*知らなかったのでメモ
「<=>」という演算子は、左が大きければ1、等しければ0、右が大きければ-1を返す
=end


# (5) (1)の配列に含まれる整数の和
sum = 0
a.each do |i|
  sum += i # endのあとのsumが答え
end
=begin
sum = 0
a.each{|i| sum += i}
とやると、1行で書ける

injectを使うともっと簡単
a.inhect(0){|sum, i| sum += i}
# injectの使い方については
  http://d.hatena.ne.jp/kenkitii/20090114/ruby_inject
  が、わかりやすい
=end


# (6) 1から100の整数を含む配列から10この要素を含む配列を10個取り出す。
#     取り出したすべての配列をresultに格納する時、???に当てはまる式は？
ary = Array.new(100){|i| i+1}
result = Array.new
10.times do |i|
#  result << ary[???]
end
=begin
Answer: ary[i*10, 10]
引数2個目で必要な要素の数を指定できる
=end


# (7) 数値からなるnum1とnum2のそれらの個々の要素を足しあわせた要素からなる
#     配列を返すメソッドsum_arrayを定義

def sum_array(ary1, ary2)
  sum_ary = []
  ary1.each do |i|
    ary2.each do |i2|
      sum_ary << i + i2
    end
  end
end

=begin
def sum_array(ary1, ary2)
  result = Array.new
  i = 0
  ary1.each do |elem1|
    result << elem1 + ary[i]
    i+=1
  end
  return result
end

def sum_array_zip(ary1, ary2)
  result = Array.new
  ary1.zip(ary2){|a, b| result << a + b}
  return result
end
=end
