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
  vertical_count = files_count <= HORIZONTAL_COUNT ? files : (files_count / horizontal_count) + 1

  files.each_slice(vertical_count).to_a.map do |column|
    unless column.count == HORIZONTAL_COUNT
      (HORIZONTAL_COUNT - column.count).times do
        column << nil
      end
    end
    file_list_table << column
  end
  file_list_table
end

main
