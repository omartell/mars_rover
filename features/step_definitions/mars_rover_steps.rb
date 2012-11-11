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
  @io ||= IO.new()
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
  io.inputs.should include "#{width}x#{height}"
end

Then /^that the rover should be ready to receive instructions$/ do
  io.outputs.should include "Please provide instructions:"
end

def start_expedition
  io.puts("What is the size of the area that you would like to explore:")
  io.gets
  io.puts("Please provide instructions:")
end