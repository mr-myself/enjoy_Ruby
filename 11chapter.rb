# encoding: utf-8

# githubに上げる発想がなかったので、途中から。
# 11章p205

# 配列の要素削除
# delete_if, rejectは同様の使い方
del = [1, 2, 3, 4, 5, 6]
del.delete_if {|i| i<4} # 条件付けて削除
p del #=> [4, 5, 6]

# 配列のユニーク値を返す
uni = [1, 2, 2, 3, 4, 4, 5]
p uni.uniq #=> [1, 2, 3, 4, 5]

# 配列の平坦化
flat = [1, [2, 3], ['test1', 'test2', 'test3'], [4]]
p flat.flatten #=> [1, 2, 3, "test1", "test2", "test3", 4]

# 配列を逆順
rev = [1, 2, 3]
p rev.reverse #=> [3, 2, 1] 文字列でも同様

# 配列の並べ替え(詳しくは後の章で)
sor = [2, 4, 3, 9, 0, 1]
p sor.sort #=> [0, 1, 2, 3, 4, 9]



# collectメソッド(mapと同様の働き？)
# ある操作を行なった結果を集めて1つの配列にして返す
col = [1, 2, 3, 4, 5]
col2 = col.collect{|i| i += 2}
p col2 #=> [3, 4, 5, 6, 7]

#------------------------------
list = ['a', 'b', 'c', 'd']
for i in 0..3
  puts "#{i}番目"
end

list = [1, 2, 3, 4, 5]
sum = 0
for i in 0..4
  sum += list[i]
end
puts sum

list = [1, 2, 3, 4, 5]
sum = 0
list.each do |num|
  sum += num
end
puts sum
#------------------------------


# eachで回すとindexがわからないが、
# each_with_indexでそれを解決できる
list = ['a', 'b', 'c', 'd']
list.each_with_index do |elem, i|
  puts "#{i}番目の要素は→#{elem}"
end
#=> 0番目の要素は→a
#=> 1番目の要素は→b
#=> 2番目の要素は→c
#=> 3番目の要素は→d


# 配列の要素を1つずつ取り除いていって、最後には空になるようにする
items = ['ab', 'cd', 'ef', 'gh']
items_return = []
while item = items.pop
  items_return << item+'ほんまかいな'
    # itemインスタンス自体を更新して文字列を追加する場合は
    # concatメソッドを使用= item.concat('ほんまかいな')
end
p items         #=> []
p items_return  #=> ["ghほんまかいな", "efほんまかいな",
                #     "cdほんまかいな", "abほんまかいな"]


# 行列をつくる
# 1, 2, 3
# 4, 5, 6
# 7, 8, 9
determinant = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
p determinant[1][2] #=> 6



# ----- 配列の初期化の注意 ----- #

initialize = Array.new(3, [0, 0, 0])
p initialize #=> [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
initialize[0][1] = 2
p initialize # [[0, 2, 0], [0, 2, 0], [0, 2, 0]]
# これはinitializeの3つの要素がすべて同じ[0, 0, 0]を
# 見に行っているために起こる

# newメソッドに要素数とブロックを指定すると、
# 要素数回ブロックを起動して、その返り値が要素にセットされる
# こうすると書く要素が同じオブジェクトを参照しなくなる
initialize2 = Array.new(3) do
  [0, 0, 0]
end
p initialize2 #=> [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
initialize2[0][1] = 2
p initialize2 #=> [[0, 2, 0], [0, 0, 0], [0, 0, 0]]

initialize3 = Array.new(5) {|i| i + 1}
p initialize3 #=> [1, 2, 3, 4, 5]



# ----- 複数の値に並行してアクセス ----- #

ary1 = [1, 2, 3, 4, 5]
ary2 = [10, 20, 30, 40, 50]
ary3 = [100, 200, 300, 400, 500]

i = 0
result = []
while i < ary1.length # lengthは5やけどiは0からやからね〜(・∀・)
  result << ary1[i] + ary2[i] + ary3[i]
  i += 1
end
p result #=> [111, 222, 333, 444, 555]

# 上記でもできるが、下記のzipメソッドを使ったやり方でより簡単に可能
# zipはレシーバと引数から渡された配列の要素を1つずつ取り出して
# そのたびにブロックを起動
ary1 = [1, 2, 3, 4, 5]
ary2 = [10, 20, 30, 40, 50]
ary3 = [100, 200, 300, 400, 500]

result = []
ary1.zip(ary2, ary3) do |a, b, c|
  result << a + b + c
end
p result #=> [111, 222, 333, 444, 555]

