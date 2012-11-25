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

def add_to_one_line_initialization(input)
  @inputs ||= ""
  if @inputs.size > 1
    input  = " #{input}"
  end
  @inputs << input
end

def one_line_initialization
  @inputs
end

Given /^there's an expedition to Mars$/ do
  
end

Given /^there's an area to explore in Mars$/ do

end

Given /^there's a (\d+)x(\d+) recognized area to explore in Mars$/ do |width, height|
  add_to_one_line_initialization "#{width} #{height}"
end

Given /^I have a rover at position (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  add_to_one_line_initialization "#{x} #{y} #{orientation}"
end

Given /^I have a rover at the initial position$/ do
  add_to_one_line_initialization "0 0 N"
end

Then /^the last known position should be (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  @station.rovers.map(&:last_known_position).map(&:to_s).should eq ["#{x} #{y} #{orientation}"]
end

Then /^that a rover is ready to receive instructions at (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  @station.rovers_status.should eq "#{x} #{y} #{orientation}"
end

Then /^the rover should be in position (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  @station.rovers_status.should eq "#{x} #{y} #{orientation}"
end

Then /^the rover should be lost$/ do
  @station.rovers_status.should eq "LOST"
end

Then /^the final rover positions should be "(.*?)"$/ do |positions|
  @station.rovers_status.should eq positions
end

Then /^I should be offered the option to specify my game in one line$/ do
  io.outputs.should include "What's the grid size to explore and your rovers movements? Format: width height (x y orientation movements+)+"
end

When /^I start the exploration program$/ do
  start_expedition
end

When /^I send the '(.*)' to the rover$/ do |instruction|
  add_to_one_line_initialization instruction.split(',').join("")
  io.inputs << one_line_initialization
  start_expedition
end

When /^the game starts$/ do
  io.inputs << "3 3 0 0 N RFLLFFFF"
  start_expedition
end

When /^I send the following rover instructions "(.*?)"$/ do |instructions|
  io.inputs << instructions
  start_expedition
end

def start_expedition
  io.puts("What's the grid size to explore and your rovers movements? Format: width height (x y orientation movements+)+")
  raw_instruction = io.gets
  @parser  = MarsRover::InstructionParser.new(raw_instruction)
  @station = MarsRover::Station.new(*@parser.grid_instructions)
  @station.deploy_rovers(@parser.rovers_instructions)
end