IO = Struct.new(nil) do
  attr_reader :outputs, :inputs
  def gets
    inputs.first
  end

  def puts(message)
    @outputs ||= []
    @outputs << message
    @outputs
  end

  def inputs
    @inputs ||= []
  end
end

def io
  @io ||= IO.new
end


Given /^there's an expedition to Mars$/ do
  
end

Given /^there's an area to explore in Mars$/ do

end

Given /^there's a (\d+)x(\d+) recognized area to explore in Mars$/ do |width, height|
  io.inputs << "#{width}x#{height}"
  start_expedition
end

Given /^I have a rover at position (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  move_rover_to x.to_i, y.to_i, orientation
end

Given /^I have a rover at the initial position$/ do
  move_rover_to 0, 0, 'N'
end

Then /^I should be prompted to provide the size of the area to explore$/ do
  io.outputs.should include "What is the size of the area that you would like to explore:"
end

Then /^the start position of the rover$/ do
  io.outputs.should include "Please provide instructions for the first rover:"
end

When /^I indicate I want to start exploring an area of (\d+)x(\d+) starting at (\d+),(\d+),'(.)'$/ do |width, height, start_x, start_y, orientation|
  io.inputs << "#{width}x#{height}"
  start_expedition
end

Then /^I should get a confirmation that the area to explore is (\d+)x(\d+)$/ do |arg1, arg2|
  area_to_explore.should eq [3,3]
end

Then /^that a rover is ready to receive instructions at (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  io.outputs.should include "Please provide instructions for the first rover:"
  rovers.should eq [Position.new(0, 0, 'N')]
end

Then /^the rover should be in position (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  current_rover_position.should eq Position.new(x.to_i, y.to_i, orientation)
end

Then /^the rover should be lost$/ do
  current_rover_position.should eq nil
end

When /^I start the exploration program$/ do
  io.inputs << "3x3"
  start_expedition
end

When /^I send the 'F' to the rover$/ do
  width     = area_to_explore.first
  height    = area_to_explore.last
  next_move = send_instruction('F')

  if next_move.x >= 0 && next_move.x < width && next_move.y >= 0 && next_move.y < height
    add_position_to_rover next_move
  else
    add_position_to_rover nil
  end
end

When /^I send the 'R' to the rover$/ do
  add_position_to_rover send_instruction('R')
end

When /^I send the 'L' to the rover$/ do
   add_position_to_rover send_instruction('L')
end

Position = Struct.new(:x, :y, :orientation) do
  def x_minus
    self.class.new x-1, y, orientation
  end

  def x_plus
    self.class.new x+1, y, orientation
  end

  def y_plus
    self.class.new x, y+1, orientation
  end

  def y_minus
    self.class.new x, y-1, orientation
  end

  def west
    self.class.new x, y, "W"
  end 

  def south
    self.class.new x, y, "S"
  end

  def north
    self.class.new x, y, "N"
  end

  def east
    self.class.new x, y, "E"
  end
end

def movements_from_current_orientation
  {
    'N' => {'R' => ->(p){ p.east  }, 'L' => ->(p){ p.west  }, 'F' => ->(p){ p.y_plus } },
    'W' => {'R' => ->(p){ p.north }, 'L' => ->(p){ p.south }, 'F' => ->(p){ p.x_minus } },
    'S' => {'R' => ->(p){ p.west  }, 'L' => ->(p){ p.east  }, 'F' => ->(p){ p.y_minus } },
    'E' => {'R' => ->(p){ p.south }, 'L' => ->(p){ p.north }, 'F' => ->(p){ p.x_plus } },
  }[current_rover_position.orientation]
end

def move_rover_to(x, y, orientation)
  add_position_to_rover Position.new(x, y, orientation)
end

def send_instruction(new_instruction)
   movements_from_current_orientation[new_instruction].call(current_rover_position)
end

def start_expedition
  io.puts("What is the size of the area that you would like to explore:")
  area_to_explore(io.gets.split("x").map(&:to_i))
  io.puts("Please provide instructions for the first rover:")
  add_position_to_rover Position.new(0,0, 'N')
end

def current_rover_position
  rovers.last
end

def add_position_to_rover(position)
  rovers << position
end

def area_to_explore(area = nil)
  @area ||= area
end

def rovers
  @rovers ||= []
end