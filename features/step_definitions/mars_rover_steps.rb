include MarsRover

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

Then /^I should get a confirmation that the area to explore is (\d+)x(\d+)$/ do |arg1, arg2|
  grid_dimensions.should eq [3,3]
end

Then /^the last known position should be (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  current_rover_position.to_s.should eq "#{x} #{y} #{orientation}"
end

Then /^that a rover is ready to receive instructions at (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  current_rover_position.to_s.should eq "#{x} #{y} #{orientation}"
end

Then /^the rover should be in position (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  current_rover_position.to_s.should eq "#{x} #{y} #{orientation}"
end

Then /^the rover should be lost$/ do
  is_rover_active.should eq false
end

Then /^the final rover positions should be "(.*?)"$/ do |positions|
  rovers.map(&:last).map(&:to_s).join(" ").should eq positions
end

Then /^I should be offered the option to specify my game in one line$/ do
  io.outputs.should include "What's the grid size to explore and your rovers movements? Format: width height (x y orientation movements+)+"
end

When /^I start the exploration program$/ do
  start_expedition
end

When /^I send the '(.*)' to the rover$/ do |instruction|
  add_to_one_line_initialization instruction.split(',').join(" ")
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
  raw_instruction = io.gets.gsub(/\s/, "").chars.to_a
  grid_dimensions = raw_instruction[0..1]
  rover_data      = raw_instruction[2..4]
  commands        = raw_instruction[5..12]
  if raw_instruction.size > 13
    rover_data2     = raw_instruction[13..15]
    commands2       = raw_instruction[16..-1]
  end

  initialize_grid_dimensions(*parse_grid_dimensions(grid_dimensions))
  initialize_rover_position(*parse_rover_data(rover_data))
  commands.each do |instruction|
    send_instruction(instruction)
  end
  if raw_instruction.size > 13
    initialize_rover_position(*parse_rover_data(rover_data2))
    commands2.each do |instruction|
      send_instruction(instruction)
    end
  end
end

def parse_rover_data(instruction_chars)
  x,y,orientation   = *instruction_chars
  [x.to_i,y.to_i,orientation]
end

def parse_grid_dimensions(instruction_chars)
  width,height = *instruction_chars
  [width.to_i, height.to_i]
end

MOVEMENTS = {
  'N' => {'R' => ->(p){ p.east  }, 'L' => ->(p){ p.west  }, 'F' => ->(p){ p.y_plus } },
  'W' => {'R' => ->(p){ p.north }, 'L' => ->(p){ p.south }, 'F' => ->(p){ p.x_minus } },
  'S' => {'R' => ->(p){ p.west  }, 'L' => ->(p){ p.east  }, 'F' => ->(p){ p.y_minus } },
  'E' => {'R' => ->(p){ p.south }, 'L' => ->(p){ p.north }, 'F' => ->(p){ p.x_plus } },
}

def initialize_rover_position(x, y, orientation)
  rover = add_position_to_rover Position.new(x, y, orientation)
  add_rover rover
  @is_rover_active = true
end

def is_rover_active
  @is_rover_active
end

def send_instruction(new_instruction)
  return unless @is_rover_active
  next_position = MOVEMENTS[current_rover_position.orientation][new_instruction].call(current_rover_position)

  if is_outside_of_grid?(next_position)
    add_position_to_rover(next_position)
  else
    @is_rover_active = false
  end
end

def add_rover(rover)
  @rovers ||= []
  @rovers << rover
end

def rovers
  @rovers
end

def current_rover_position
  rover_positions.last
end

def add_position_to_rover(position)
  rover_positions << position
  rover_positions
end

def initialize_grid_dimensions(width, height)
  @grid_width  = width
  @grid_height = height
end

def is_outside_of_grid?(position)
  position.x >= 0 && position.x < @grid_width && position.y >= 0 && position.y < @grid_height
end

def rover_positions
  @rover_positions ||= []
end