#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

# 横方向に配置する数
HORIZONTAL_COUNT = 3

def main
  files = setup
  if ARGV[0].include?('l')
    create_row(files)
  else
    file_list_table = create_columns(files)

    results = file_list_table.transpose
    results.each { |result| puts result.join(' ') }
  end
end

private

def setup
  files = []
  opts = OptionParser.new do |opts|
    opts.on('-a') { files = Dir.glob('*', File::FNM_DOTMATCH, sort: true) }
    opts.on('-r') { files = files.empty? ? Dir.glob('*', sort: true).reverse : files.reverse }
    opts.on('-l') { files = files.empty? ? Dir.glob('*', sort: true) : files}
    opts.parse(ARGV)
  end
  files
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

def create_row(files)
  files.each do |file|
    puts [
      # ファイルタイプ
      file_type(file),
      # パーミション
      permission(file),
      # ハードリンクの数
      File.stat(file).nlink.to_s.rjust(2),
      # オーナー名
      File.stat(file).uid.to_s.rjust(4),
      # グループ名
      File.stat(file).gid.to_s.rjust(4),
      # バイトサイズ
      File.stat(file).size.to_s.rjust(6),
      # タイムスタンプ
      File.stat(file).atime.strftime(' %b %d %H:%M'),
      # ファイル名
      " #{file}"
    ].join
  end
end

def file_type(file)
  # ファイルタイプ
  print({ file: '-', directory: 'd', link: 'l' }[File.ftype(file).to_sym])
end

def permission(file)
  permissions = File.stat(file).mode.to_s(8)[-3..-1]
  permissions.split('').each do |permission|
    print({ '1': '--x', '2': '-w-', '3': '-wx', '4': 'r--', '5': 'r-x', '6': 'rw-', '7': 'rwx' }[permission.to_sym])
  end
  print ' '
end

main
