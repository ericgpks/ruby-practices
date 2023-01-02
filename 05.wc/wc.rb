#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  files = ARGV
  files = Dir.glob('*', sort: true) if files.empty?
  params = setup
  files.each do |file|
    print " #{count_row(file)} " if params.include?(:l) || params.empty?
    print " #{count_word(file)} " if params.include?(:w) || params.empty?
    print " #{count_bite(file)} " if params.include?(:c) || params.empty?
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
