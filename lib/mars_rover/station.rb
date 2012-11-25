module MarsRover
  class Station
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

    def rovers_status
      @rovers.map do |rover|
        rover.lost? ? "LOST": rover.current_position.to_s
      end.join(" ")
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
end