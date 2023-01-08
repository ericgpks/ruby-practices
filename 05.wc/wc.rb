#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  params = setup
  files = []
  # 引数
  unless ARGF.argv.empty?
    files = ARGF.argv
    show_result(files, params)
  end
  # パイプ
  if File.pipe?($stdin)
    files = readlines(&:chomp)
    show_pipe_result(files)
  end
  return unless files.empty?

  # 標準入力
  files << ARGF.gets.chomp
  show_result(files, params)
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

def show_result(files, params)
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

def show_pipe_result(files)
  # 行数
  print " #{files.length} "
  # 単語数
  print " #{files.to_s.gsub(/\s+/, "\n").count("\n")} "
  # サイズ
  print " #{files.to_s.bytesize} "
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
