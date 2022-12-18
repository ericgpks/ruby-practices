#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'debug'

def main(scores, frame_count, ball_count, total_score)
  scores.each_with_index do |score, index|
    if frame_count == 10
      total_score = calc_last_frame(total_score, scores, score, index)
      break
    end
    if ball_count == 1
      if score == 'X'
        total_score, frame_count = calc_strike(total_score, frame_count, scores, index)
      else
        total_score += score.to_i
        ball_count += 1
      end
      next
    end
    next unless ball_count == 2

    total_score = calc_spare(total_score, scores, index) if (score.to_i + scores[index - 1].to_i) == 10
    total_score += score.to_i
    ball_count = 1
    frame_count += 1
  end
  total_score
end

def setup
  opt = OptionParser.new
  opt.on('-s VAL') { |v| p v }
  scores = opt.parse(ARGV)[0].split(',')

  frame_count = 1
  ball_count = 1
  total_score = 0
  [scores, frame_count, ball_count, total_score]
end

private

def calc_last_frame(total_score, scores, score, index)
  total_score += score == 'X' ? 10 : score.to_i
  total_score += scores[index + 1] == 'X' ? 10 : scores[index + 1].to_i
  unless scores[index + 2].nil?
    total_score += scores[index + 2] == 'X' ? 10 : scores[index + 2].to_i
  end
  total_score
end

def calc_strike(total_score, frame_count, scores, index)
  total_score += 10
  total_score += scores[index + 1] == 'X' ? 10 : scores[index + 1].to_i
  total_score += scores[index + 2] == 'X' ? 10 : scores[index + 2].to_i
  frame_count += 1
  [total_score, frame_count]
end

def calc_spare(total_score, scores, index)
  total_score += scores[index + 1] == 'X' ? 10 : scores[index + 1].to_i
  total_score
end

scores, frame_count, ball_count, total_score = setup
total_score = main(scores, frame_count, ball_count, total_score)
puts total_score
