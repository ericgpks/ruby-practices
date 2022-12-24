#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

# 横方向に配置する数
HORIZONTAL_COUNT = 3

def main
  if ARGV.include?('-l')
    create_row
  else
    files = setup

    file_list_table = create_columns(files)

    results = file_list_table.transpose
    results.each { |result| puts result.join(' ') }
  end
end

private

def setup
  option = ARGV.include?('-a') ? File::FNM_DOTMATCH : 0
  files = Dir.glob('*', option, sort: true)
  ARGV.include?('-r') ? files.reverse : files
end

def create_columns(files)
  files_count = files.length
  # 縦方向に配置する数
  vertical_count = files_count / HORIZONTAL_COUNT
  vertical_count += 1 if files_count % HORIZONTAL_COUNT != 0

  files.each_slice(vertical_count).map do |column|
    column << nil while column.count < HORIZONTAL_COUNT
    column
  end
end

def create_row
  files = Dir.glob('*', sort: true).to_a
  files.each do |file|
    row = []
    # ファイルタイプ
    row << file_type(file)
    # パーミション
    row << permission(file)
    # ハードリンクの数
    row << File.stat(file).nlink.to_s.rjust(2)
    # オーナー名
    row << File.stat(file).uid.to_s.rjust(4)
    # グループ名
    row << File.stat(file).gid.to_s.rjust(4)
    # バイトサイズ
    row << File.stat(file).size.to_s.rjust(6)
    # タイムスタンプ
    row << File.stat(file).atime.strftime(' %b %d %H:%M')
    # ファイル名
    row << " #{file}"
    puts row.join
  end
end

def file_type(file)
  # ファイルタイプ
  case File.ftype(file)
  when 'file'
    print '-'
  when 'directory'
    print 'd'
  when 'link'
    print 'l'
  else
    print ''
  end
end

def permission(file)
  permissions = File.stat(file).mode.to_s(8)[3..5]
  permissions.split('').each do |permission|
    case permission
    when '1'
      print '--x'
    when '2'
      print '-w-'
    when '3'
      print '-wx'
    when '4'
      print 'r--'
    when '5'
      print 'r-x'
    when '6'
      print 'rw-'
    when '7'
      print 'rwx'
    end
  end
  print ' '
end

main
