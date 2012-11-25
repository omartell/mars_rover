module MarsRover
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
end