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


Given /^there's an expedition to Mars$/ do
  
end

Given /^there's an area to explore in Mars$/ do

end

Given /^there's a (\d+)x(\d+) recognized area to explore in Mars$/ do |width, height|
  io.inputs << "#{width}x#{height}"
  start_expedition
end

Given /^I have a rover at position (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  initialize_rover_position x.to_i, y.to_i, orientation
end

Given /^I have a rover at the initial position$/ do
  initialize_rover_position 0, 0, 'N'
end

Then /^I should be prompted to provide the size of the area to explore$/ do
  io.outputs.should include "What is the size of the area that you would like to explore:"
end

Then /^the start position of the rover$/ do
  io.outputs.should include "Please enter rover instructions:"
end

When /^I indicate I want to start exploring an area of (\d+)x(\d+) starting at (\d+),(\d+),'(.)'$/ do |width, height, start_x, start_y, orientation|
  io.inputs << "#{width}x#{height}"
  start_expedition
  initialize_rover_position start_x.to_i,start_y.to_i, orientation
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

When /^I send the following rover instructions "(.*?)"$/ do |instructions|
  ins_chars     = instructions.gsub(/\s/, "").chars.to_a
  width, height = *ins_chars.shift(2)
  grid_dimensions([width.to_i, height.to_i])
  x,y,orientation = *ins_chars.shift(3)
  initialize_rover_position(x.to_i,y.to_i,orientation)
  ins_chars.each do |ins|
    send_instruction(ins)
  end  
end

Then /^the final rover positions should be "(.*?)"$/ do |positions|
  current_rover_position.to_s.should eq positions
end

When /^I start the exploration program$/ do
  io.inputs << "3x3"
  start_expedition
end

When /^I send the '(.*)' to the rover$/ do |instruction|
  instruction.split(',').each do |ins|
    send_instruction(ins)
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

def initialize_rover_position(x, y, orientation)
  add_position_to_rover Position.new(x, y, orientation)
  @is_rover_active = true
end

def is_rover_active
  @is_rover_active
end

def all_rover_positions
  rovers
end

def send_instruction(new_instruction)
  return unless @is_rover_active
  next_position = movements_from_current_orientation[new_instruction].call(current_rover_position)

  if is_outside_of_grid?(next_position)
    add_position_to_rover(next_position)
  else
    @is_rover_active = false
  end
end

def start_expedition
  io.puts("What is the size of the area that you would like to explore:")
  width, height = io.gets.split("x").map(&:to_i)
  grid_dimensions([width, height])
  io.puts("Please enter rover instructions:")
end

def current_rover_position
  rovers.last
end

def add_position_to_rover(position)
  rovers << position
end

def grid_dimensions(width_height = nil)
  @grid ||= width_height
end

def grid_width
  @grid.first
end

def grid_height
  @grid.last
end

def is_outside_of_grid?(position)
  position.x >= 0 && position.x < grid_width && position.y >= 0 && position.y < grid_height
end

def rovers
  @rovers ||= []
end