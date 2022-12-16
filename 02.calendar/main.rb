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
  puts calender +=" #{days.join(' ')}\n"

  create_body(year, month)
end

private

def create_body(year, month)
  calender_body = ''
  first_date = Date.new(year, month, 1)
  wday = first_date.wday

  print calender_body += ('   ' * wday)

  (first_date..Date.new(year, month, -1)).map do |date|
    if date == Date.today
      print " \e[35m#{date.day.to_s.rjust(2)}\e[0m"
    else
      print " #{date.day.to_s.rjust(2)}"
    end

    print "\n" if date.saturday?
  end
end

create_calender
