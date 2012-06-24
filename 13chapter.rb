#encoding: utf-8

person = Hash.new
person['tanaka'] = '田中'
person['さとう'] = '佐藤'

p person['tanaka'] #=> "田中"
p person['さとう'] #=> "佐藤"

h1 = {"a" => "えー", "b" => "びー"}
p h1["a"] #=> "えー"

# 1.9からは下記も可能
h2 = {a: "エー", b: "ビー"}
p h2 #=> {:a=>"エー", :b=>"ビー"}
p h2[:a] #=> "エー"

# Hash.new 引数がデフォルト値になる
h1 = Hash.new
h2 = Hash.new("")
p h1["not_key"] #=> nil
p h2["not_key"] #=> ""

# 値の登録にstoreとfetchメソッドを使用可能
# fetchはキーが登録されていない場合に例外を発生させる
h = Hash.new
h.store("R", "Ruby")
p h.fetch("R") #=> "Ruby"
#p h.fetch("U") #=> key not found: "U" (KeyError)

# 「第2引数を指定すればキーが登録されていない場合のデフォルト値になる」と本には書いてあるが、
# ならなかった。バージョンの問題？

# キーや値をまとめて取り出すためのメソッド
# each_key, each_value, each
h = Hash.new
h = {"ruby" => "るびー", "perl" => "ぱーる", "php" => "ぴーえいちぴー"}
h.each_key do |key|
	p key
end
# "ruby"
# "perl"
# "php"

h.each do |key, val|
	p key
	p val
end
# ハッシュを配列に治すことも可能（to_aは非推奨とか書いてなかったっけかな？）
p h.to_a #=> [["ruby", "るびー"], ["perl", "ぱーる"], ["php", "ぴーえいちぴー"]]

# ハッシュを作る際のデフォルト値
h = Hash.new(1)
p h["a"] #=> 1

# キーによって異なる値を返させたい場合や、すべてのキーに対する値が共有されることを避けたい場合は
# ブロックを指定する
h = Hash.new{|hash, key|
	hash[key] = key.upcase
}
h["a"] = "a"

p h["a"] #=> "a"
p h["b"] #=> "B"

p h.fetch("b", "(undef)") #=> "B" ...やっぱりfetchの第2引数は全く効かない。。

# ハッシュがあるオブジェクトをキーとして持っているか調べる
p h.key?("a")     #=> true
p h.has_key?("a") #=> true
p h.include?("b") #=> true
p h.member?("b")  #=> true
# 上の4つはデフォルト値が与えられてるからキーがなにであれtrueを返す。これ注意必要。
h = Hash.new
p h.member?("b") #=> false ...ということ。

# ハッシュがあるオブジェクトを値として持っているかを調べる
h = {"ruby" => "るびー", "perl" => "ぱーる", "php" => "ぴーえいちぴー"}
p h.value?("るびー") #=> true
p h.has_value?("z")  #=> false

# 大きさなど
p h.size   #=> 3
p h.length #=> 3
p h.empty? #=> false

# キーを指定して削除
h.delete("ruby")
p h #=> {"perl"=>"ぱーる", "php"=>"ぴーえいちぴー"}

# 引数にブロックを指定すると、キーが存在しなかった場合、ブロックを実行した結果を返す
p h.delete("python"){|key| "no #{key}"} #=> "no python"

# 条件指定して削除も可能 delete_ifとrejectは同義
p h.delete_if{|key, value| key == "php"} #=> {"perl"=>"ぱーる"}
p h.reject{|key, value| value == "ぴーえいちぴー"} #=> {"perl"=>"ぱーる"}
# reject!は当てはまらなかった際の返り値が違う
p h.delete_if{|key, value| key == "python"} #=> {"perl"=>"ぱーる"} ...元のハッシュを返す
p h.reject!{|key, value| value == "ぱいそん"} #=> nil ...nilを返す。ただし破壊的メソッドの時だけ。

# ハッシュを空にする
h = {'a'=>'A', 'b'=>'B', 'c'=>'C'}
p h.clear #=> {}

#  以下の違いに注意
h = {'k1'=>'v1'}
g = h
h.clear
p g #=> {} ...これ参照渡しみたいになってるってことだよな

h = {'k2'=>'v2'}
g = h
h = Hash.new
p g #=> {"k2"=>"v2"} ...newした時点で見てる先が違うようになるって感じかな
# メソッドは変数に対してではなく変数が参照しているオブジェクトに対して操作を行う

# ハッシュのハッシュ（ネスト）
table = {'A' => {'a' => 'x', 'b' => 'y'},
				 'B' => {'a' => 'v', 'b' => 'z'}}
p table['A']['a'] #=> "x"
p table['B']['b'] #=> "z"


# 単語数のカウント

count = Hash.new(0) #=> {}
## 単語の集計
while line = gets # getsだけでファイル行毎に読み込むのができるんだな
	words = line.split #=> splitは引数を省略すると空白文字による分割
	words.each do |word|
		count[word] += 1 # countっていう配列にwordをキーとするハッシュに数字を入れてる
                     # 同じ単語があったら同じキーのとこに入るからその時＋１する。
	end
end
## 結果の出力
count.sort{|a, b|
	a[1] <=> b[1] # 左が大きければ１，等しければ０，右が大きければ−１
                # このaとbに入ってるものがわからん
								# countをsortメソッドで取り出すとそれぞれの値は配列として取り出される
								#=> ['単語', '出現回数']
}.each do |key, value|
	print "#{key}: #{value}\n"
end
