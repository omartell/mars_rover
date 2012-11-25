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
  current_rover.last_known_position.to_s.should eq "#{x} #{y} #{orientation}"
end

Then /^that a rover is ready to receive instructions at (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  current_rover.current_position.to_s.should eq "#{x} #{y} #{orientation}"
end

Then /^the rover should be in position (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  current_rover.current_position.to_s.should eq "#{x} #{y} #{orientation}"
end

Then /^the rover should be lost$/ do
  current_rover.active?.should eq false
end

Then /^the final rover positions should be "(.*?)"$/ do |positions|
  rovers.flat_map(&:current_position).map(&:to_s).join(" ").should eq positions
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
  initialize_grid_dimensions(*parse_grid_dimensions(raw_instruction))

  raw_instruction.scan(/(\d \d [W,N,S,E]) (\w+)\s?/).each do |position, commands|
    initialize_rover_position(*parse_rover_data(position))
    commands.chars.each do |command|
      current_rover.command(command)
    end
  end
end

def parse_rover_data(raw_position)
  x,y,orientation = *raw_position.gsub(/\s/, "").chars
  [x.to_i,y.to_i,orientation]
end

def parse_grid_dimensions(raw_instruction)
  width,height = *raw_instruction[0..2].gsub(/\s/, "").chars
  [width.to_i, height.to_i]
end

SURFACE_MAP = {
  'N' => {'R' => ->(p){ p.east  }, 'L' => ->(p){ p.west  }, 'F' => ->(p){ p.y_plus } },
  'W' => {'R' => ->(p){ p.north }, 'L' => ->(p){ p.south }, 'F' => ->(p){ p.x_minus } },
  'S' => {'R' => ->(p){ p.west  }, 'L' => ->(p){ p.east  }, 'F' => ->(p){ p.y_minus } },
  'E' => {'R' => ->(p){ p.south }, 'L' => ->(p){ p.north }, 'F' => ->(p){ p.x_plus } },
}

def initialize_rover_position(x, y, orientation)
  rover = Rover.new(Position.new(x, y, orientation), @grid_width, @grid_height)
  add_rover(rover)
end

def add_rover(rover)
  @rovers ||= []
  @rovers << rover
end

def rovers
  @rovers
end

def current_rover
  rovers.last
end

def initialize_grid_dimensions(width, height)
  @grid_width  = width
  @grid_height = height
end

class Rover
  attr_reader :positions, :lost_positions, :last_known_position
  def initialize(initial_position, grid_width, grid_height)
    @positions      = []
    @grid_width     = grid_width
    @grid_height    = grid_height
    @positions << initial_position
  end

  def current_position
    @positions.last
  end

  def command(command)
    next_position = SURFACE_MAP[current_position.orientation][command].call(current_position)
    if active?
      @positions << next_position
    else
      @last_known_position = @positions[-2]
    end
  end

  def active?
    current_position.x >= 0 && current_position.x < @grid_width && current_position.y >= 0 && current_position.y < @grid_height
  end
end