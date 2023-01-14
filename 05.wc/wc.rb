#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  params = setup
  # 引数
  pattern_params(params) unless ARGF.argv.empty?
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

def pattern_params(params)
  total_row = 0
  total_byte = 0
  total_word = 0
  files = ARGF.argv
  files.each do |file|
    content = File.read(file)
    row, byte, word = show_result(content, params)
    total_row += row
    total_byte += byte
    total_word += word
    print " #{file}\n"
  end
  return unless files.count > 1

  print " #{total_row}  #{total_word}  #{total_byte}  total"
end

def show_result(content, params)
  row = count_row(content)
  word = count_word(content)
  byte = count_byte(content)
  if params.empty?
    print " #{row}  #{word}  #{byte} "
  else
    print " #{row} " if params.include?(:l)
    print " #{word} " if params.include?(:w)
    print " #{byte} " if params.include?(:c)
  end
  [row, word, byte]
end

def count_byte(content)
  content.bytesize
end

def count_row(content)
  content.lines.count
end

def count_word(content)
  content.to_s.gsub(/\s+/, "\n").count("\n")
end

main
