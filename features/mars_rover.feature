Feature:
  Control the rovers that will find the hidden treasures
  in the mars surface.

Scenario: Deploying a rover to mars surface
  Given there's a 3x3 recognized area to explore in Mars
  When I indicate that I want to start the expedition
  Then I should be asked the size of the area to explore
  And I should see that the area to explore is 3x3
  And that a rover is ready to receive instructions at 0,0

Scenario: Moving the rover forward
  Given there's a 3x3 recognized area to explore in Mars
  And I have a rover at the initial position
  When I send the forward instruction to the rover
  Then the rover should be in position 0,1