require 'set'
require 'json'

module Squares
  
  $debug_response = {}
  $plane_lines = []
  $points = []

  CSI = "\e[".freeze

  class Point
    attr_accessor :x, :y
    def initialize(x, y)
      @x = x
      @y = y
    end
    
    def same? point
      self.x == point.x and self.y == point.y
    end
    
    def to_s
      "(#{@x},#{@y})"
    end
    
    def > point
      return self.x > point.x || (self.x == point.x && self.y > point.y)
    end
  end
  
  class Line
    attr_accessor :p1, :p2, :median_point, :median_size
    def initialize(p1, p2)
      @p1 = p1 > p2 ? p1 : p2
      @p2 = p2 > p1 ? p1 : p2
      calculate_median_point
      calculate_median_size
    end
    
    def to_s
      "[#{p1.to_s},#{p2.to_s}]"
    end
    
    def key
      "#{@median_size},#{@median_point}"
    end
    
    def eql? line
      self.hash == line.hash
    end
    
    def hash
      self.to_s.hash
    end
    
    private
    def calculate_median_point
      np1 = ((@p2.x - @p1.x).to_f/2) + @p1.x
      np2 = ((@p2.y - @p1.y).to_f/2) + @p1.y
      @median_point = Point.new(np1, np2)
    end
    
    def calculate_median_size
      @median_size = Math.sqrt((p2.x - p1.x)**2 + (p2.y-p1.y)**2)
    end
    
  end
  
  def self.calculate points
    $points = points
    
    lines = {}
    
    points.each do |p1|
      points.each do |p2|
        unless p1.same? p2
          line = Line.new(p1, p2)
          $plane_lines << line
          if lines[line.key].nil?
            lines[line.key] = []
            lines[line.key] << line
          else
            lines[line.key] << line unless lines[line.key].last.hash == line.hash || lines[line.key].first.hash == line.hash
          end
        end
      end
    end
    
    $debug_response = lines
    
    lines.select{|a,b| b.size > 1}.size
  end

  def self.print_matrix
    m = []
    max_x = 0
    max_y = 0
    $points.each do |point|
      max_x = max_x > point.x ? max_x : point.x
      max_y = max_y > point.y ? max_y : point.y
      m[point.x] = [] if m[point.x].nil?
      m[point.x][point.y] = true
    end

    (0..max_x).each do |i|
      m[i] = [] if m[i].nil?
      (0..max_y).each do |z|
        m[i][z] == false if m[i][z].nil?
      end
    end

    m.each_with_index{|line, row| line.each_with_index{|c, column|
      move_to(row, column)
      if c
        print 'x'
      else
        print '.'
      end
      }
    }

    nil
  end

  def self.move_to(row = nil, column = nil)
    return CSI + 'H' if row.nil? && column.nil?
    print(CSI + "#{column};#{row}H")
  end
end
