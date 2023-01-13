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
    files = $stdin.read(&:chomp)
    show_pipe_result(files)
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

def show_result(files, params)
  files.each do |file|
    content = File.readlines(file)
    if params.empty?
      print " #{count_row(content)}  #{count_word(content)}  #{count_bite(content)} "
    else
      print " #{count_row(content)} " if params.include?(:l)
      print " #{count_word(content)} " if params.include?(:w)
      print " #{count_bite(content)} " if params.include?(:c)
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

def count_byte(content)
  content.to_s.size
end

def count_row(content)
  content.length
end

def count_word(content)
  content.join.split(/\s+/).count
end

main
