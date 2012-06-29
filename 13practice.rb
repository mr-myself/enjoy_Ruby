#encoding: utf-8

# ----- 練習問題 ----- #

# (1) 曜日を表す英語と日本語の対応を表すハッシュを定義
wday = Hash.new
wday = {'sunday'=>'日曜日',
        'monday'=>'月曜日',
        'tuesday'=>'火曜日',
        'wednesday'=>'水曜日',
        'thursday'=>'木曜日',
        'friday'=>'金曜日',
        'saturday'=>'土曜日'
} # 改行してなかったけど解答見たらされててそっちの方が見やすいので
p wday['sunday']   #=> "日曜日"
p wday['thursday'] #=> "木曜日"


# (2) ハッシュのメソッドで(1)のペアの数を数える
p wday.size #=> 7


# (3) eachメソッドと(1)のwdayを使って例の文字列を出力
wday.each do |key, value|
  puts "「#{key}」は#{value}のことです。"
end

# 下記みたいにもかけるよ〜って解答にあったので一応
%w(sunday monday tuesday wednesday thursday friday saturday).each do |day|
  puts "「#{day}」は#{wday[day]}のことです。"
end

# (4) 空白とタブと改行で区切られた文字列をハッシュに変換するメソッドを定義
def str2hash(str)
  hash = Hash.new
  ary = str.split(/\s+/) # 半角空白、タブ、復帰、改行などは空白文字として扱われるのでこれだけで改行もタブもクリアできる
  count = ary.size
  a = 0
  for i in 0..count/2-1 do
    hash[ary[a]] = ary[a+1]
    a += 2
  end
  return hash
end

# 下記は解答のやり方。なるほどそうすればよかったのか・・・。賢い。。
def str2hash(str)
  hash = Hash.new
  array = str.split(/\s+/) # 半角空白、タブ、復帰、改行などは空白文字として扱われるのでこれだけで改行もタブもクリアできる
  while key = array.shift
    value = array.shift
    hash[key] = value
  end
  return hash
end

p str2hash("blue 青\nred 赤 green 緑") #=> {"blue"=>"青", "red"=>"赤", "green"=>"緑"}
