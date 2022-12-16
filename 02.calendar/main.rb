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

  calender += create_body(year, month)
end

private

def create_body(year, month)
  calender_body = ''
  wday = Date.new(year, month, 1).wday

  wday.times do
    calender_body += " #{' '.rjust(2)}"
  end

  calender_body += (Date.new(year, month, 1)..Date.new(year, month, -1)).map do |date|
    if date == Date.today
      " \e[35m#{date.day.to_s.rjust(2)}\e[0m"
    else
      " #{date.day.to_s.rjust(2)}"
    end

    "\n" if date.saturday?
  end.join
end

puts create_calender
