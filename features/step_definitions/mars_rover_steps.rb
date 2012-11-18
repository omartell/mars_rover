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
  move_rover_to [x.to_i, y.to_i, orientation]
end

Given /^I have a rover at the initial position$/ do
  move_rover_to [0, 0, 'N']
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
  rovers.should eq [[ 0, 0, 'N']]
end

Then /^the rover should be in position (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  rovers.last.should eq [x.to_i,y.to_i, orientation]
end

When /^I start the exploration program$/ do
  io.inputs << "3x3"
  start_expedition
end

When /^I send the 'F' to the rover$/ do
  current_position = rovers.last

  if current_position.last == "N" || current_position.last == "S"
    move_rover_to [current_position.first, current_position[1] + movements[current_position.last]['F'] ,current_position.last]
  elsif current_position.last == "W" || current_position.last == "E"
    move_rover_to [current_position[0] + movements[current_position.last]['F'], current_position[1], current_position.last]
  end
end

When /^I send the 'R' to the rover$/ do
  current_position = rovers.last
  move_rover_to [current_position.first,current_position[1], movements[current_position.last]['R']]
end

When /^I send the 'L' to the rover$/ do
  current_position = rovers.last
  move_rover_to [current_position.first,current_position[1], movements[current_position.last]['L']]
end

def movements
  {
    'N' => {'R' => 'E', 'L' => 'W', 'F' => 1 },
    'W' => {'R' => 'N', 'L' => 'S', 'F' =>-1 },
    'S' => {'R' => 'W', 'L' => 'E', 'F' =>-1 },
    'E' => {'R' => 'S', 'L' => 'N', 'F' => 1 },
  }
end

def start_expedition
  io.puts("What is the size of the area that you would like to explore:")
  area_to_explore(io.gets.split("x").map(&:to_i))
  io.puts("Please provide instructions for the first rover:")
  move_rover_to [0,0, 'N']
end

def move_rover_to(position)
  rovers << position
end

def area_to_explore(area = nil)
  @area ||= area
end

def rovers
  @rovers ||= []
end