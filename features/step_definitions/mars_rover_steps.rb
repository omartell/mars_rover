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

When /^I start the exploration program$/ do
  io.inputs << "3x3"
  start_expedition
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

Given /^there's a (\d+)x(\d+) recognized area to explore in Mars$/ do |width, height|

end

Then /^that a rover is ready to receive instructions at (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  io.outputs.should include "Please provide instructions for the first rover:"
  rovers.should eq [[ 0, 0, 'N']]
end

Given /^I have a rover at the initial position$/ do
  rovers << [0, 0, 'N']
end

Then /^the rover should be in position (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  rovers.last.should eq [x.to_i,y.to_i, orientation]
end

When /^I send the 'F' to the rover$/ do
  current_position = rovers.last
  if current_position.last == "N"
    rovers << [0, current_position[1] + 1, 'N']
  elsif current_position.last == "E"
    rovers << [current_position.first + 1, 0, 'E']
  elsif current_position.last == "S"
    rovers << [0, current_position[1] - 1, 'S']
  elsif current_position.last == "W"
    rovers << [current_position.first - 1, 0, 'W']
  end
end

When /^I send the 'R' to the rover$/ do
  right_orientations = {
    'N' => 'E',
    'W' => 'N',
    'S' => 'W',
    'E' => 'S',
  }
  current_position = rovers.last
  rovers << [0,0, right_orientations[current_position.last]]
end

When /^I send the 'L' to the rover$/ do
  left_orientations = {
    'N' => 'W',
    'W' => 'S',
    'S' => 'E',
    'E' => 'N',
  }
  current_position = rovers.last
  rovers << [0,0, left_orientations[current_position.last]]
end

Given /^I have a rover at position (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  rovers << [x.to_i, y.to_i, orientation]
end

def start_expedition
  io.puts("What is the size of the area that you would like to explore:")
  area_to_explore(io.gets.split("x").map(&:to_i))
  io.puts("Please provide instructions for the first rover:")
  rovers << [0,0, 'N']
end

def area_to_explore(area = nil)
  @area ||= area
end

def rovers
  @rovers ||= []
end