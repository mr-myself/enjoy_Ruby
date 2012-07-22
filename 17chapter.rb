# encoding: utf-8

# Rubyには3種類の日付や時刻を表すクラスが提供されている
# Timeクラス（システムの制限を受ける、システムに対する操作を行う場合に有用）
# dateライブラリ（日付を表現するDateクラスと日付と時刻を表現するDateTimeクラス）

Time.new; Time.now # 現在時刻
p Time.new #=> 2012-07-18 08:11:59 +0900
p Time.now #=> 2012-07-18 08:11:59 +0900

# 取得した時刻の要素を求める
t = Time.now
p t       #=> 2012-07-18 08:14:12 +0900
p t.year  #=> 2012
p t.month #=> 7
p t.day   #=> 18

# 【時刻の要素に関するメソッド】
# hour, min, sec,  to_i(1970年1月1日0時からの秒数),
# wday(週の何日目か(日曜日を0とする))、mday(月の何日目か(dayメソッドと同じ))
# yday(年の何日目か(1月1日を1とする))、zone(タイムゾーン)

# 指定した時刻を表すTimeオブジェクトを得る
t = Time.mktime(2012, 7, 18, 8, 20, 59)
p t #=> 2012-07-18 08:20:59 +0900

# ファイルの時刻
# atime(ファイルを最後に参照した時刻), mtime(ファイルを最後に修正した時刻), ctime(ファイルの状態を最後に変更した時刻)
filename = "foo"
open(filename, "w").close

st = File.stat(filename) # File.staメソッドを使って、
                         # ファイルやディレクトリの属性を取得できる
p st.ctime
p st.mtime
p st.atime
# File.utimeを使って最終参照時刻と最終修正時刻の変更可能

# 時刻の計算
t1 = Time.now
#sleep(10) # 10秒待つ
sleep(3) # 10秒待つ
t2 = Time.now
p t1 < t2 #=> true
p t2 - t1 #=> 10.024499757

# Timeオブジェクトに足したり引いたり
t = Time.now
p t #=> 2012-07-18 08:33:29 +0900
t2 = t + 60 * 60 * 24 # 24時間分プラス
p t2 #=> 2012-07-19 08:33:29 +0900

# 時刻のフォーマットもいろいろ
# 時刻を文字列にしたいときはt.strftime(format) or t.to_sで取得可能
t = Time.now
p t.to_s #=> "2012-07-18 08:37:16 +0900"
p t.strftime("%a %b %d %H:%M:%S %z %Y") #=> "Wed Jul 18 08:38:46 +0900 2012"

# 電子メールのヘッダ情報に含まれる形式
require 'time'

t = Time.now
p t.rfc2822 #=> "Wed, 18 Jul 2012 08:42:21 +0900"

# 国際標準に則った形式でフォーマット
require 'time'

t = Time.now
p t.iso8601 #=> "2012-07-18T08:43:45+09:00"

# ローカルタイム
t = Time.now
p t #=> 2012-07-18 08:46:55 +0900
t.utc # utcは世界協定時
p t   #=> 2012-07-17 23:46:55 UTC
t.localtime
p t #=> 2012-07-18 08:46:55 +0900

# 文字列の解析
require 'time'

p Time.parse("Sat Oct 17 11:54:15 UTC 2009") #=> 2009-10-17 11:54:15 UTC
p Time.parse("2009/07/19") #=> 2009-07-19 00:00:00 +0900
p Time.parse("H21.07.19") #=> 2009-07-19 00:00:00 +0900


# ----- DateTimeクラス ----- #
require 'date'

# 現在時刻を取得, 時刻のフォーマット, 文字列の解析についてはTimeクラスと同じことができる

# to_timeメソッドでDateTimeオブジェクトからTimeオブジェクトを生成
d = DateTime.now
p d.to_time #=> 2012-07-19 17:30:06 +0900

# DateTimeクラスとTimeクラスの違い
=begin
Timeクラスはもともとコンピューターの内部で利用されている時刻を
Rubyから利用するためのクラス
DateTimeはシステムの機能を利用せずに時刻を表現しているので
プラットフォームの違いによる互換性の問題はない
=end

# 時差の扱いの違い
require 'date'

t = DateTime.now
p t.offset #=> (3/8) 8分の3時間、つまり9時間の時差があることがわかる

# 同じ時刻で時差の異なるDateTimeオブジェクトを得る
t1 = DateTime.now
t2 = t1.new_offset(0)
puts t1 #=> 2012-07-19T19:59:19+09:00
puts t2 #=> 2012-07-19T10:59:19+00:00

# 差が1日未満の場合はRationalオブジェクトを使用
Rational(1, 86400) # 86400が分母は秒単位
Rational(1, 24) # 24が分母は時間単位

require 'date'

t1 = DateTime.now
t2 = t1 + Rational(5, 24)
puts t1 #=> 2012-07-22T15:18:12+09:00
puts t2 #=> 2012-07-22T20:18:12+09:00

# 得られたRationalを秒数などの数値に変換するには
# 適当な分母をかけた後でto_iやto_fを使って整数や浮動小数点数に変換

require 'date'

t = DateTime.now
p (t.offset * 24).to_i    #=> 9
p (t.offset * 1440).to_i  #=> 540
p (t.offset * 86400).to_i #=> 32400

# Dateクラスを使って日付を求める
require 'date'
d = Date.today
puts d #=> 2012-07-22

# 月末の日付を−1で指定できる。閏年にも対応
require 'date'
d = Date.new(2012, 7, -1) #=> 2012-07-31
puts d

# >>演算子で後の月の同日を表すDateオブジェクト、
# <<演算子で前の月の同日を表すDateオブジェクトを得られる
require 'date'
d = Date.today
puts d
puts d >> 1 #=> 2012-08-22
puts d >> 100 #=> 2020-11-22
puts d << 1 #=> 2012-06-22
puts d << 100 #=> 2004-03-22

# DateクラスもTimeクラスと同様にstrftimeを使って日付を文字列に
# するためのフォーマットで指定できる。ただし時刻に相当する部分はすべて0になる
require 'date'
t = Date.today
p t.strftime("%Y/%m/%d %H:%M:%S") #=> "2012/07/22 00:00:00"
