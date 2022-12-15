#!/usr/bin/env ruby

# frozen_string_literal: true

require 'date'
require 'optparse'

def create_calender
  params = {}
  opt = OptionParser.new
  opt.on('-m VAL') { |v| params[:m] = v }
  opt.on('-y [VAL]') { |v| params[:y] = v }
  opt.parse!(ARGV, into: params)
  calender = ''

  year = params[:y].nil? ? Date.today.year : params[:y].to_i
  month = params[:m].nil? ? Date.today.month : params[:m].to_i

  calender += "       #{month.to_s.rjust(2)}月 #{year}\n"

  days = %w[日 月 火 水 木 金 土]
  calender += " #{days.join(' ')}\n"

  create_body(calender, year, month)
end

private

def create_body(calender, year, month)
  wday = Date.new(year, month, 1).wday

  if wday != 0
    wday.times do
      calender += " #{' '.rjust(2)}"
    end
  end
  (Date.new(year, month, 1)..Date.new(year, month, -1)).each do |date|
    calender += if date == Date.today
                  " \e[35m#{date.day.to_s.rjust(2)}\e[0m"
                else
                  " #{date.day.to_s.rjust(2)}"
                end

    calender += "\n" if date.saturday?
  end
  calender
end

puts create_calender
