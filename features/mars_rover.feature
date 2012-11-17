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

Scenario: Sending a sequence of orientation commands
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at the initial position
  When I send the 'L' to the rover
  And I send the 'L' to the rover
  Then the rover should be in position 0,0,'S'

Scenario: Sending a sequence of orientation commands
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at the initial position
  When I send the 'L' to the rover
  And I send the 'L' to the rover
  And I send the 'L' to the rover
  Then the rover should be in position 0,0,'E'

Scenario: Sending a sequence of orientation commands
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at the initial position
  When I send the 'R' to the rover
  And I send the 'R' to the rover
  And I send the 'R' to the rover
  Then the rover should be in position 0,0,'W'


