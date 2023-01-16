#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  params = setup
  # 引数
  unless ARGF.argv.empty?
    files = ARGF.argv
    show_result_for_params(files, params)
  end

  # パイプ
  return unless File.pipe?($stdin)

  content = $stdin.read(&:chomp)
  show_result(content, params)
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

def show_result_for_params(files, params)
  total_row = 0
  total_byte = 0
  total_word = 0

  files.each do |file|
    content = File.read(file)
    row, word, byte = show_result(content, params)
    total_row += row
    total_byte += byte
    total_word += word
    print " #{file}\n"
  end
  return unless files.count > 1

  print " #{total_row}  #{total_word}  #{total_byte}  total"
end

def show_result(content, params)
  row, word, byte = calc(content)
  if params.empty?
    print " #{row}  #{word}  #{byte} "
  else
    print " #{row} " if params.include?(:l)
    print " #{word} " if params.include?(:w)
    print " #{byte} " if params.include?(:c)
  end
  [row, word, byte]
end

def calc(content)
  row_count = content.lines.count
  byte_count = content.bytesize
  word_count = content.to_s.gsub(/\s+/, "\n").count("\n")
  [row_count, word_count, byte_count]
end

main
