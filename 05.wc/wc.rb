#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  params = setup
  # 引数
  unless ARGF.argv.empty?
    files = ARGF.argv
    files.each do |file|
      content = File.read(file)
      show_result(content, params)
      print " #{file}\n"
    end
  end
  # パイプ
  if File.pipe?($stdin)
    content = $stdin.read(&:chomp)
    show_result(content, params)
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

def show_result(content, params)
  if params.empty?
    print " #{count_row(content)}  #{count_word(content)}  #{count_byte(content)} "
  else
    print " #{count_row(content)} " if params.include?(:l)
    print " #{count_word(content)} " if params.include?(:w)
    print " #{count_byte(content)} " if params.include?(:c)
  end
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
