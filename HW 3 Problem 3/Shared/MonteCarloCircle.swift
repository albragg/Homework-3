//
//  MonteCarloCircle.swift
//  Monte Carlo Integration
//
//  Created by Jeff Terry on 12/31/20.
//

import Foundation
import SwiftUI

class MonteCarloCircle: NSObject, ObservableObject {
    
    @MainActor @Published var insideData = [(xPoint: Double, yPoint: Double)]()
    @MainActor @Published var outsideData = [(xPoint: Double, yPoint: Double)]()
    @Published var totalGuessesString = ""
    @Published var guessesString = ""
    @Published var piString = ""
    @Published var errorString = ""
    @Published var enableButton = true
    @Published var rString = ""
    @Published var a0String = ""
    @Published var boxSideLengthString = ""
    
    var overlapIntegral = 0.0
    var exactAnswer = 0.0
    var error = 0.0 //error with respect to the exact answer
    var guesses = 1
    var totalGuesses = 0
    var totalIntegral = 0.0
    var boxSideLength = 10.0
    var firstTimeThroughLoop = true
    var a0 = 1.0
    var R = 0.0
    
    @MainActor init(withData data: Bool){
        
        super.init()
        
        insideData = []
        outsideData = []
        
    }


    /// calculate the value of π
    ///
    /// - Calculates the Value of π using Monte Carlo Integration
    ///
    /// - Parameter sender: Any
    func calculatePI() async {
        
        var maxGuesses = 0.0
        let boundingBoxCalculator = BoundingBox() ///Instantiates Class needed to calculate the area of the bounding box.
        
        
        maxGuesses = Double(guesses)
        
        let newValue = await calculateMonteCarloIntegral(minX: -boxSideLength / 2.0, maxX: boxSideLength / 2.0 , maxGuesses: maxGuesses)
        
        totalIntegral = totalIntegral + newValue
        
        totalGuesses = totalGuesses + guesses
        
        await updateTotalGuessesString(text: "\(totalGuesses)")
        
        //totalGuessesString = "\(totalGuesses)"
        
        ///Calculates the value of π from the area of a unit circle
        
        overlapIntegral = totalIntegral/Double(totalGuesses) * boundingBoxCalculator.calculateSurfaceArea(numberOfSides: 2, lengthOfSide1: boxSideLength, lengthOfSide2: boxSideLength, lengthOfSide3: 0.0)
        
        await updatePiString(text: "\(overlapIntegral)")
        
        //piString = "\(pi)"
        exactAnswer = analyticalOverlapIntPsi1SPsi1S(r: R, a0: a0)
       error = abs(overlapIntegral - exactAnswer) / exactAnswer
        
        await updateErrorString(text: "\(error)")
    }

  
    
    func psi1S(r: Double, a0: Double)-> Double{
        let psi = 1.0 / (sqrt(Double.pi)*pow(a0, 3.0/2.0)) * exp(-r/a0) // symmetric around theta, phi
        return psi
    }

    func analyticalOverlapIntPsi1SPsi1S(r: Double, a0: Double) -> Double {
        let ans = exp(-r/a0) * (1+r/a0+pow(r, 2.0)/(3.0*pow(a0, 2.0)))
        return ans
    }
    
    
    /// calculates the Monte Carlo Integral of a Circle
    ///
    /// - Parameters:
    ///   - minX, maxX: start and end points of integration
    ///   - maxGuesses: number of guesses to use in the calculaton
    /// - Returns: ratio of points inside to total guesses. Must mulitply by area of box in calling function
    func calculateMonteCarloIntegral(minX: Double, maxX: Double, maxGuesses: Double) async -> Double {
        
        var numberOfGuesses = 0.0
        var pointsInIntegral = 0.0
        var integral = 0.0
        var point = (xPoint: 0.0, yPoint: 0.0)
        let minYPoint = -boxSideLength / 2.0
        let maxYPoint = boxSideLength / 2.0
        
        var newInsidePoints : [(xPoint: Double, yPoint: Double)] = []
        var newOutsidePoints : [(xPoint: Double, yPoint: Double)] = []
        
        
        while numberOfGuesses < maxGuesses {
            
            /* Calculate 2 random values within the box */
            /* Determine the distance from that point to the origin */
            /* If the distance is less than the unit radius count the point being within the Unit Circle */
          
            point.xPoint = Double.random(in: minX...maxX)
            point.yPoint = Double.random(in: minYPoint...maxYPoint) // maximum value of plot
            
            // if inside the integral add to the number of points in the radius
            if((psi1S(r: point.xPoint + R/2.0, a0: a0) * psi1S(r: point.xPoint - R/2.0, a0: a0) - point.yPoint) >= 0.0 ){
                pointsInIntegral += 1.0
                
                
                newInsidePoints.append(point)
               
            }
            else { //if outside the circle do not add to the number of points in the radius
                
                
                newOutsidePoints.append(point)

                
            }
            
            numberOfGuesses += 1.0
            
            
            
            
            }

        
        integral = Double(pointsInIntegral)
        
        //Append the points to the arrays needed for the displays
        //Don't attempt to draw more than 250,000 points to keep the display updating speed reasonable.
        
        if ((totalGuesses < 500001) || (firstTimeThroughLoop)){
        
//            insideData.append(contentsOf: newInsidePoints)
//            outsideData.append(contentsOf: newOutsidePoints)
            
            var plotInsidePoints = newInsidePoints
            var plotOutsidePoints = newOutsidePoints
            
            if (newInsidePoints.count > 750001) {
                
                plotInsidePoints.removeSubrange(750001..<newInsidePoints.count)
            }
            
            if (newOutsidePoints.count > 750001){
                plotOutsidePoints.removeSubrange(750001..<newOutsidePoints.count)
                
            }
            
            await updateData(insidePoints: plotInsidePoints, outsidePoints: plotOutsidePoints)
            firstTimeThroughLoop = false
        }
        
        return integral
        }
    
    
    /// updateData
    /// The function runs on the main thread so it can update the GUI
    /// - Parameters:
    ///   - insidePoints: points inside the circle of the given radius
    ///   - outsidePoints: points outside the circle of the given radius
    @MainActor func updateData(insidePoints: [(xPoint: Double, yPoint: Double)] , outsidePoints: [(xPoint: Double, yPoint: Double)]){
        
        insideData.append(contentsOf: insidePoints)
        outsideData.append(contentsOf: outsidePoints)
    }
    
    /// updateTotalGuessesString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the number of total guesses
    @MainActor func updateTotalGuessesString(text:String){
        
        self.totalGuessesString = text
        
    }
    
    /// updatePiString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the current value of Pi
    @MainActor func updatePiString(text:String){
        
        self.piString = text
        
    }
    
    @MainActor func updateErrorString(text:String){
        
        self.errorString = text
        
    }
    
    
    
    /// setButton Enable
    /// Toggles the state of the Enable Button on the Main Thread
    /// - Parameter state: Boolean describing whether the button should be enabled.
    @MainActor func setButtonEnable(state: Bool){
        
        
        if state {
            
            Task.init {
                await MainActor.run {
                    
                    
                    self.enableButton = true
                }
            }
            
            
                
        }
        else{
            
            Task.init {
                await MainActor.run {
                    
                    
                    self.enableButton = false
                }
            }
                
        }
        
    }

}
