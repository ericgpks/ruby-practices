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
  Dir.glob('*').sort
end

def create_columns(files)
  file_list_table = []
  files_count = files.length
  # 横方向に配置する数
  horizontal_count = HORIZONTAL_COUNT
  # 縦方向に配置する数
  if files_count % HORIZONTAL_COUNT == 0
    vertical_count = files_count / horizontal_count
  else
    vertical_count = (files_count / horizontal_count) + 1
  end

  files.each_slice(vertical_count).to_a.map do |column|
    (HORIZONTAL_COUNT - column.count).times do
      column << nil
    end
    file_list_table << column
  end
  file_list_table
end

main
