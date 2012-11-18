Feature:
  Control the rovers that will find the hidden treasures
  in the mars surface.

Scenario: Prompting the user for inputs
  Given there's an expedition to Mars
  When I start the exploration program
  Then I should be prompted to provide the size of the area to explore
  And the start position of the rover

Scenario: Deploying a rover to mars surface
  Given there's an area to explore in Mars
  When I indicate I want to start exploring an area of 3x3 starting at 0,0,'N'
  Then I should get a confirmation that the area to explore is 3x3
  And that a rover is ready to receive instructions at 0,0,'N'

Scenario: Sending the 'F' command
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at the initial position
  When I send the 'F' to the rover
  Then the rover should be in position 0,1,'N'

Scenario: Sending the 'R' command
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at the initial position
  When I send the 'R' to the rover
  Then the rover should be in position 0,0,'E'

Scenario: Sending the 'L' command
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at the initial position
  When I send the 'L' to the rover
  Then the rover should be in position 0,0,'W'

Scenario: Sending a sequence of left orientation commands
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at the initial position
  When I send the 'L,L,L' to the rover
  Then the rover should be in position 0,0,'E'

Scenario: Sending a sequence of right orientation commands
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at the initial position
  When I send the 'R,R,R' to the rover
  Then the rover should be in position 0,0,'W'

Scenario: Sending a sequence of 'F' commands when orientations is 'N'
  Given there's a 4x4 recognized area to explore in Mars
  And I have a rover at the initial position
  When I send the 'F,F,F' to the rover
  Then the rover should be in position 0,3,'N'

Scenario: Sending a sequence of 'F' commands when orientation is 'E'
  Given there's a 4x4 recognized area to explore in Mars
  And I have a rover at position 0,0,'E'
  When I send the 'F,F,F' to the rover
  Then the rover should be in position 3,0,'E'

Scenario: Sending a sequence of 'F' commands when orientation is 'S'
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at position 0,3,'S'
  When I send the 'F,F,F' to the rover
  Then the rover should be in position 0,0,'S'

Scenario: Sending a sequence of 'F' commands when orientation is 'W'
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at position 3,0,'W'
  When I send the 'F,F,F' to the rover
  Then the rover should be in position 0,0,'W'

Scenario: Sending a sequence of various commands
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at position 0,0,'E'
  When I send the 'F,L,F,R,F' to the rover
  Then the rover should be in position 2,1,'E'

Scenario: Going outside of the grid, x < 0
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at position 0,0,'W'
  When I send the 'F' to the rover
  Then the rover should be lost

Scenario: Going outside of the grid, x > width
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at position 2,0,'E'
  When I send the 'F' to the rover
  Then the rover should be lost

Scenario: Going outside of the grid, y > height
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at position 0,0,'S'
  When I send the 'F' to the rover
  Then the rover should be lost

Scenario: Going outside of the grid, y < height
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at position 0,2,'N'
  When I send the 'F' to the rover
  Then the rover should be lost

Scenario: The rover ignores commands after is lost
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at position 0,0,'N'
  When I send the 'R,F,L,L,F,F,F,F' to the rover
  Then the rover should be lost
  And the last known position should be 0,0,'W'

Scenario: Supporting a one line initialization
  Given there's an expedition to Mars
  When I send the following rover instructions "3 3 0 0 N RFLLFFFF"
  Then the final rover positions should be "0 0 W"