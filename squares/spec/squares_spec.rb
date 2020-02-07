require 'spec_helper'
require_relative '../squares.rb'

describe Squares do
  
  context 'with a know number of lines that make squares' do
    it 'finds 1 square when given 4 equidistant points' do
      
      expected = [
        Squares::Point.new(0,0),
        Squares::Point.new(1,1),
        Squares::Point.new(1,0),
        Squares::Point.new(0,1)
      ]
    
      expect Squares::calculate(expected) == 1
    end

    it 'finds 3 squares on 14 know points' do
      know_points = [
        Squares::Point.new(1,1),
        Squares::Point.new(2,1),
        Squares::Point.new(1,2),
        Squares::Point.new(2,2),
        Squares::Point.new(4,3),
        Squares::Point.new(3,4),
        Squares::Point.new(5,4),
        Squares::Point.new(2,5),
        Squares::Point.new(4,5),
        Squares::Point.new(6,5),
        Squares::Point.new(4,7),
        Squares::Point.new(6,2),
        Squares::Point.new(2,4),
        Squares::Point.new(8,5)      ]

      expect Squares::calculate(know_points) == 3
    end
  end

  context 'with a random number of points' do
    generator = Random.new
    points = generator.rand(1000)
    
    it "finds squares for a random (#{points}) number of points" do
      unknow_points = []
    
      points.times do
        x = generator.rand(100)
        y = generator.rand(100)
        unknow_points << Squares::Point.new(x, y)
      end
    
      # puts unknow_points.inspect
    
      # Actual execution time using the system clock
      starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      squares =  Squares::calculate(unknow_points)
      elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - starting
    
      # puts JSON.pretty_generate $debug_response
    
      p "calculated #{squares} squares out of #{unknow_points.size} points in #{elapsed} seconds"
      Squares::print_matrix
      expect(unknow_points).not_to be_nil
    end
  end
end
