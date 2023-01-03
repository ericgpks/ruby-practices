#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  params = setup
  files = setup_files
  files.each do |file|
    if params.empty?
      print " #{count_row(file)}  #{count_word(file)}  #{count_bite(file)} "
    else
      print " #{count_row(file)} " if params.include?(:l)
      print " #{count_word(file)} " if params.include?(:w)
      print " #{count_bite(file)} " if params.include?(:c)
    end
    print " #{file}\n"
  end
end

def setup
  opt = OptionParser.new
  params = {}
  opt.on('-l')
  opt.on('-w')
  opt.on('-c')
  opt.parse!(ARGV, into: params)
  params
end

def setup_files
  files = []
  # 引数
  files = ARGF.argv unless ARGF.argv.empty?
  # 標準入力
  files << ARGF.gets.chomp if files.empty?
  # パイプ
  if File.pipe?($stdin)
    files.each do |file_content|
      File.open('ls_file', 'w', 0o755) { |f| f.print file_content.to_s }
    end
    files = ['ls_file']
  end
  files
end

def count_bite(file)
  file.size
end

def count_row(file)
  File.open(file).readlines.count
end

def count_word(file)
  new_file = File.read(file).gsub(/\s+/, "\n")
  space_count = new_file.count("\n")
  if new_file[0] == "\n"
    space_count - 1
  else
    space_count
  end
end

main
