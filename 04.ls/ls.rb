#!/usr/bin/env ruby
# frozen_string_literal: true

HORIZONTAL_COUNT = 3
def main
  files = setup

  file_list_table = create_columns(files)

  results = file_list_table.transpose
  results.each { |result| puts result.join(' ') }
end

private

def setup
  files = []
  files = Dir.glob('*').sort
end

def create_columns(files)
  file_index = 0
  file_list_table = []
  files_count = files.length
  # 横方向に配置する数
  horizontal_count = HORIZONTAL_COUNT
  # 縦方向に配置する数
  if files_count <= HORIZONTAL_COUNT
    vertical_count = files
  else
    vertical_count = (files_count / horizontal_count) + 1
  end

  horizontal_count.times do |_hi|
    column = []
    vertical_count.times do |_vi|
      column << files[file_index]
      file_index += 1
    end
    file_list_table << column
  end
  file_list_table
end

main
