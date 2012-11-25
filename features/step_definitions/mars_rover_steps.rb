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
  @mission.last_deployed_rover.last_known_position.to_s.should eq "#{x} #{y} #{orientation}"
end

Then /^that a rover is ready to receive instructions at (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  @mission.last_deployed_rover.current_position.to_s.should eq "#{x} #{y} #{orientation}"
end

Then /^the rover should be in position (\d+),(\d+),'(.)'$/ do |x, y, orientation|
  @mission.last_deployed_rover.current_position.to_s.should eq "#{x} #{y} #{orientation}"
end

Then /^the rover should be lost$/ do
  @mission.last_deployed_rover.lost?.should eq true
end

Then /^the final rover positions should be "(.*?)"$/ do |positions|
  @mission.rovers.flat_map(&:current_position).map(&:to_s).join(" ").should eq positions
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
  @parser  = InstructionParser.new(raw_instruction)
  @mission = MarsMission.new(*@parser.grid_instructions)
  @mission.deploy_rovers(@parser.rovers_instructions)
end

class InstructionParser
  def initialize(raw_instruction)
    @raw_instruction = raw_instruction
  end

  def rovers_instructions
    @raw_instruction.scan(/(\d \d [W,N,S,E]) (\w+)\s?/).map do |position, commands|
      x,y,orientation = *position.gsub(/\s/, "").chars
      [Position.new(x.to_i,y.to_i,orientation), commands.chars]
    end
  end

  def grid_instructions
    width,height = *@raw_instruction[0..2].gsub(/\s/, "").chars
    [width.to_i, height.to_i]
  end
end

class MarsMission
  def initialize(grid_width, grid_height)
    @grid_width  = grid_width
    @grid_height = grid_height
    @rovers = []
  end

  def deploy_rovers(instructions)
    instructions.each do |position, commands|
      build_rover(position).execute_commands(commands)
    end
  end

  def last_deployed_rover
    @rovers.last
  end

  def rovers
    @rovers.dup
  end

  private
  
  def build_rover(position)
    rover = Rover.new(position, @grid_width, @grid_height)
    @rovers << rover
    rover
  end
end

SURFACE_MAP = {
  'N' => {'R' => ->(p){ p.east  }, 'L' => ->(p){ p.west  }, 'F' => ->(p){ p.y_plus } },
  'W' => {'R' => ->(p){ p.north }, 'L' => ->(p){ p.south }, 'F' => ->(p){ p.x_minus } },
  'S' => {'R' => ->(p){ p.west  }, 'L' => ->(p){ p.east  }, 'F' => ->(p){ p.y_minus } },
  'E' => {'R' => ->(p){ p.south }, 'L' => ->(p){ p.north }, 'F' => ->(p){ p.x_plus } },
}

class Rover
  attr_reader :last_known_position
  def initialize(initial_position, grid_width, grid_height)
    @positions      = []
    @grid_width     = grid_width
    @grid_height    = grid_height
    @positions << initial_position
  end

  def current_position
    @positions.last
  end

  def positions
    @positions.dup
  end

  def execute_command(command)
    next_position = SURFACE_MAP.fetch(current_position.orientation).fetch(command).call(current_position)
    if lost?
      @last_known_position = @positions[-2]
    else
      @positions << next_position
    end
  end

  def execute_commands(commands)
    commands.each{ |c| execute_command(c) }
  end

  def lost?
    current_position.x < 0 || current_position.x >= @grid_width || current_position.y < 0 || current_position.y >= @grid_height
  end
end