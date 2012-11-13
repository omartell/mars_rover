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

Given /^there's a (\d+)x(\d+) recognized area to explore in Mars$/ do |width, height|
  io.inputs << "#{width}x#{height}"
end

When /^I indicate that I want to start the expedition$/ do
  start_expedition
end

Then /^I should be asked the size of the area to explore$/ do
  io.outputs.should include "What is the size of the area that you would like to explore:"
end

Then /^I should see that the area to explore is (\d+)x(\d+)$/ do |width, height|
  area_to_explore.should eq [3,3]
end

Then /^that a rover is ready to receive instructions at (\d+),(\d+)$/ do |x, y|
  io.outputs.should include "Please provide instructions:"
  rovers.should eq [[0,0]]
end

Given /^I have a rover at the initial position$/ do
  rovers << [0,0]
end

Then /^the rover should be in position (\d+),(\d+)$/ do |x, y|
  rovers.should eq [[x.to_i,y.to_i]]
end

When /^I send the 'F' to the rover$/ do
  x,y = rovers.shift
  rovers << [x, y + 1]
end

When /^I send the 'R' to the rover$/ do
  x,y = rovers.shift
  rovers << [x + 1, y]
end

def start_expedition
  io.puts("What is the size of the area that you would like to explore:")
  area_to_explore(io.gets.split("x").map(&:to_i))
  io.puts("Please provide instructions:")
  rovers << [0,0]
end

def area_to_explore(area = nil)
  @area ||= area
end

def rovers
  @rovers ||= []
end