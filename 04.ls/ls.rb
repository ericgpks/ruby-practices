#!/usr/bin/env ruby
# frozen_string_literal: true

HORIZONTAL_COUNT = 3
def main
  files = setup
  table = []
  file_index = 0

  table = create_columns(table, files, file_index)

  results = table.transpose
  results.each { |result| puts result.join(' ') }
end

private

def setup
  files = []
  files = Dir.glob('*').sort
end

def create_columns(table, files, file_index)
  files_count = files.length
  # 横方向に配置する数
  horizontal_count = HORIZONTAL_COUNT
  # 縦方向に配置する数
  vertical_count = (files_count / horizontal_count) + 1

  horizontal_count.times do |_hi|
    column = []
    vertical_count.times do |_vi|
      column << files[file_index]
      file_index += 1
    end
    table << column
  end
  table
end

main
