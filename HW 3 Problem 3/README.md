# Monte-Carlo-Integration
SwiftUI version of the Monte Carlo Integration program to determine the value of PI

I was inspired to post this by Rhett Allain's [work](https://www.wired.com/2017/03/hey-can-find-pi-random-walk-heres/) on calculating Pi based upon a random walk. Another method that you can use to calculate Pi based upon random numbers relies upon Monte Carlo Integration of a Unit Circle. Here is SwiftUI code that compiles on for a Mac, iPad, and iPhone that you can use to explore Monte Carlo integration. Increasing the number of guesses, gives you are better value of Pi within the limits of computational error.

The classes MonteCarloCircle and BoundingBox perform the bulk of the computations. The DrawingView displays the points used in the calculation. The ContentView sets up the bulk of the Graphical User Interface (GUI).
