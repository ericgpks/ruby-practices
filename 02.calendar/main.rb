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
  days.each do |day|
    calender += " #{day}"
  end
  calender += "\n"

  create_body(calender, year, month)
end

private

def create_body(calender, year, month)
  cwday = Date.new(year, month, 1).cwday
  last_date = Date.new(year, month, -1).day

  (1..last_date).each do |day|
    if day == 1 && cwday != 7
      cwday.times do
        calender += " #{' '.rjust(2)}"
      end
    end
    calender += if Date.new(year, month, day) == Date.today
                  " \e[35m#{day.to_s.rjust(2)}\e[0m"
                else
                  " #{day.to_s.rjust(2)}"
                end

    calender += "\n" if Date.new(year, month, day).cwday == 6
  end
  calender
end

puts create_calender
