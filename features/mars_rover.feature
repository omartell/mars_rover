Feature:
  Control the rovers that will find the hidden treasures
  in the mars surface.

Scenario: Deploying a rover to mars surface
  Given there's a 3x3 recognized area to explore in Mars
  When I indicate that I want to start the expedition
  Then I should be asked the size of the area to explore
  And I should see that the area to explore is 3x3
  And that the rover should be ready to receive instructions