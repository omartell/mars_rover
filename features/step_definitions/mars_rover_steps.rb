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

When /^I start the exploration program$/ do
  io.inputs << "3x3"
  start_expedition
end

When /^I send the 'F' to the rover$/ do
  next_position = movements[current_rover_position.orientation]['F'][current_rover_position]
  add_position_to_rover next_position
end

When /^I send the 'R' to the rover$/ do
  send_orientation_instruction('R')
end

When /^I send the 'L' to the rover$/ do
  send_orientation_instruction('L')
end

Position = Struct.new(:x, :y, :orientation)

def movements
  {
    'N' => {'R' => 'E', 'L' => 'W', 'F' => ->(position){ Position.new(position.x   ,position.y+1, position.orientation) } },
    'W' => {'R' => 'N', 'L' => 'S', 'F' => ->(position){ Position.new(position.x-1 ,position.y  , position.orientation) } },
    'S' => {'R' => 'W', 'L' => 'E', 'F' => ->(position){ Position.new(position.x   ,position.y-1, position.orientation) } },
    'E' => {'R' => 'S', 'L' => 'N', 'F' => ->(position){ Position.new(position.x+1 ,position.y  , position.orientation) } },
  }
end

def move_rover_to(x, y, orientation)
  add_position_to_rover Position.new(x, y, orientation)
end

def send_orientation_instruction(orientation)
  add_position_to_rover Position.new current_rover_position.x, current_rover_position.y, movements[current_rover_position.orientation][orientation]
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