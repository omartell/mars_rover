module MarsRover
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
end