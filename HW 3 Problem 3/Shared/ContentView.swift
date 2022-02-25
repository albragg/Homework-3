//
//  ContentView.swift
//  Shared
//
//  Created by Jeff Terry on 12/31/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var overlapIntegral = 0.0
    @State var totalGuesses = 0.0
    @State var totalIntegral = 0.0
    @State var R = 0.0
    @State var a0 = 1.0
    @State var boxLength = 10.0
    @State var guessString = "23458"
    @State var rString = "0.0"
    @State var a0String = "1.0"
    @State var totalGuessString = "0"
    @State var piString = "0.0"
    @State var errorString = "0.0"
    @State var boxLengthString = "10.0"
    
    
    // Setup the GUI to monitor the data from the Monte Carlo Integral Calculator
    @ObservedObject var monteCarlo = MonteCarloCircle(withData: true)
    
    //Setup the GUI View
    var body: some View {
        HStack{
            
            VStack{
                
                VStack(alignment: .center) {
                    Text("Guesses")
                        .font(.callout)
                        .bold()
                    TextField("# Guesses", text: $guessString)
                        .padding()
                }
                .padding(.top, 5.0)
                
                VStack(alignment: .center) {
                    Text("Total Guesses")
                        .font(.callout)
                        .bold()
                    TextField("# Total Guesses", text: $totalGuessString)
                        .padding()
                }
                
                VStack(alignment: .center) {
                    Text("R")
                        .font(.callout)
                        .bold()
                    TextField("# R", text: $rString)
                        .padding()
                }
                .padding(.top, 5.0)
                
                VStack(alignment: .center) {
                    Text("a0")
                        .font(.callout)
                        .bold()
                    TextField("# a0", text: $a0String)
                        .padding()
                }
                VStack(alignment: .center) {
                    Text("Bounding Box Side Length")
                        .font(.callout)
                        .bold()
                    TextField("# boxLength", text: $boxLengthString)
                        .padding()
                }
                .padding(.top, 5.0)
                VStack(alignment: .center) {
                    Text("Integral")
                        .font(.callout)
                        .bold()
                    TextField("# Integral", text: $piString)
                        .padding()
                }
                
                VStack(alignment: .center) {
                    Text("Error")
                        .font(.callout)
                        .bold()
                    TextField("# Error", text: $errorString)
                        .padding()
                }
                
                Button("Cycle Calculation", action: {Task.init{await self.calculatePi()}})
                    .padding()
                    .disabled(monteCarlo.enableButton == false)
                
                Button("Clear", action: {self.clear()})
                    .padding(.bottom, 5.0)
                    .disabled(monteCarlo.enableButton == false)
                
                if (!monteCarlo.enableButton){
                    
                    ProgressView()
                }
                
                
            }
            .padding()
            
            //DrawingField
            
            
            drawingView(redLayer:$monteCarlo.insideData, blueLayer: $monteCarlo.outsideData)
                .padding()
                .aspectRatio(1, contentMode: .fit)
                .drawingGroup()
            // Stop the window shrinking to zero.
            Spacer()
            
        }
    }
    
    func calculatePi() async {
        
        
        monteCarlo.setButtonEnable(state: false)
        
        monteCarlo.guesses = Int(guessString)!
        monteCarlo.R = Double(rString) ?? 0.0 // need to pull it in
        monteCarlo.a0 = Double(a0String) ?? 1.0 //
        monteCarlo.boxSideLength = Double(boxLengthString) ?? 10.0
        monteCarlo.totalGuesses = Int(totalGuessString) ?? Int(0.0)
        
        await monteCarlo.calculatePI()
        
        totalGuessString = monteCarlo.totalGuessesString
        
        piString =  monteCarlo.piString
        
        errorString = monteCarlo.errorString
        
        monteCarlo.setButtonEnable(state: true)
        
    }
    
    func clear(){
        
        guessString = "23458"
        totalGuessString = "0.0"
        piString =  ""
        errorString = ""
        monteCarlo.totalGuesses = 0
        monteCarlo.totalIntegral = 0.0
        monteCarlo.insideData = []
        monteCarlo.outsideData = []
        monteCarlo.firstTimeThroughLoop = true
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 
