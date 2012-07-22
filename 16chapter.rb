# encoding: utf-8

# ファイル名を変更
#File.rename("before.txt", "after.txt")

# すでに存在するディレクトリに移動
#File.rename("data.txt", "backup/data.txt")

# ファイルをコピー
def copy(from, to)
  open(from) do |input|
    open(to, w) do |output|
      output.write(input.read)
    end
  end
end

# 上記のコピーはライブラリの読み込みで簡単にできる
require "fileutils"
=begin
FileUtils.cp("data.txt", "backup/data.txt")
FileUtils.mv("data.txt", "backup/data1.txt")
=end

# ファイル削除
#File.delete("foo")

# カレントディレクトリの取得
p Dir.pwd #=> "/home/homepage/Club_Programing/Enjoy-Ruby"
Dir.chdir("../")
p Dir.pwd #=> "/home/homepage/Club_Programing"
io = open("Ruby-Twitter/tw_bot.rb")
io.close

# ディレクトリの内容を読む
dir = Dir.open("../Club_Programing")
while name = dir.read
  p name #=> "."
         #   ".."
         #   "Ruby-Twitter"
         #   "Enjoy-Ruby"
         #   "JavaScript"
         #   "Perl-TDD"
end
dir.close

# eachでも書ける
dir = Dir.open("../Club_Programing")
dir.each do |name|
  p name
end
dir.close

# ブロック与えればcloseの省略もできる
Dir.open("../Club_Programing") do |dir|
  dir.each do |name|
    p name
  end
end

=begin
def traverse(path)
  if File.directory?(path)
    dir = Dir.open(path)
    while name = dir.read
      next if name == "."
      next if name == ".."
      traverse(path + "/" + name) # traverseメソッドは指定したディレクトリ以下のすべてのファイル名を出力
    end
    dir.close
  else
    process_file(path)
  end
end

def process_file(path)
  puts path
end

traverse(ARGV[0])
=end

# DIr.globメソッド ...ワイルドカードが使えるようになる

=begin
def traverse(path)
  Dir.glob(["#{path}/**/*", "#{path}/**/.*"]).each do |name| # **/* カレントディレクトリ以下のすべてのファイル名を取得
    unless File.directory?(name)
      process_file(name)
    end
  end
end
=end

Dir.mkdir("temp") # 新しいディレクトリ作成
Dir.rmdir("temp") # ディレクトリ削除


# ファイル/usr/local/bin/rubyのユーザー名とグループ名を表示する
require 'etc'

st = File.stat("/usr/local/bin/ruby")
pw = Etc.getpwuid(st.uid)
p pw.name #=> root
gr = Etc.getgrgid(st.gid)
p gr.name #=> root


filename = "foo"
open(filename, "w").close

st = File.stat(filename)
p st.ctime #=> 2012-07-12 09:02:46 +0900
p st.mtime #=> 2012-07-12 09:02:46 +0900
p st.atime #=> 2012-07-12 09:02:46 +0900

File.utime(Time.now-100, Time.now-100, filename)
st = File.stat(filename)
p st.ctime #=> 2012-07-12 09:02:46 +0900
p st.mtime
p st.atime

# 所有者権限の変更
# File.chmod(0755, "text.txt")

# ファイル名の操作
# ファイルのパス名のうち、一番後ろの"/"以降の部分を返す
p File.basename("/usr/local/bin/ruby") #=> ruby


# ----- ファイル操作関連のライブラリ ----- #
# findライブラリ

require 'find'

IGNORES = [ /^\./, /^CVS$/, /^RCS$/ ]

def listdir(top)
  Find.find(top) do |path|
    if FileTest.directory?(path) # pathがディレクトリならば
      dir, base = File.split(path) # パス名pathをディレクトリ名の部分と
                                   # ファイル名の部分に分解し、2つの要素からなる配列を返す
      IGNORES.each do |re|
        if re =~ base # 無視したいディレクトリの場合
          Find.prune  # それ以下の検索を省略
        end
      end
      puts path
    end
  end
end

listdir(ARGV[0])


# ----- tempfileライブラリ ----- #
# ----- fileutilsライブラリ ----- #

