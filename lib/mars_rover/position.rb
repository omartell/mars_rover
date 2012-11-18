module MarsRover
  Position = Struct.new(:x, :y, :orientation) do
    def x_minus
      self.class.new x-1, y, orientation
    end

    def x_plus
      self.class.new x+1, y, orientation
    end

    def y_plus
      self.class.new x, y+1, orientation
    end

    def y_minus
      self.class.new x, y-1, orientation
    end

    def west
      self.class.new x, y, "W"
    end 

    def south
      self.class.new x, y, "S"
    end

    def north
      self.class.new x, y, "N"
    end

    def east
      self.class.new x, y, "E"
    end
  end
end