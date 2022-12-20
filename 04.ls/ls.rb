#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

# 横方向に配置する数
HORIZONTAL_COUNT = 3

def main
  files = setup

  file_list_table = create_columns(files)

  results = file_list_table.transpose
  results.each { |result| puts result.join(' ') }
end

private

def setup
  @options = {}
  OptionParser.new do |o|
    o.on('-a') { |v| @options[:a] = v }
  end
  if ARGV.include?('-a')
    Dir.glob('*', File::FNM_DOTMATCH, sort: true)
  else
    Dir.glob('*', sort: true)
  end
end

def create_columns(files)
  file_list_table = []
  files_count = files.length
  # 縦方向に配置する数
  vertical_count = files_count / HORIZONTAL_COUNT
  vertical_count += 1 if files_count % HORIZONTAL_COUNT != 0

  files.each_slice(vertical_count).map do |column|
    column << nil while column.count < HORIZONTAL_COUNT
    column
  end
end

main
