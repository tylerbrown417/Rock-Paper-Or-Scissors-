//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Tyler Brown on 2/1/21.
//

import SwiftUI

struct ImageView: View {
    var imageName: String
    
    var body: some View {
        Text("\(imageName)")
            .padding()
            .padding()
                .background(Color.white)
            .cornerRadius(30)
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.black, lineWidth: 3))
            .shadow(color: .gray, radius: 3)
            .font(.largeTitle)
    }
}




class StopWatch: ObservableObject {
    enum swMode {
        case running
        case stopped
    }
    @Published var secondsElapsed = 0.00
    @Published var timer = Timer()
    @Published var mode: swMode = .stopped
    
    func start() {
        mode = .running
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                self.secondsElapsed += 0.01
            }
    }
    func stop() {
        timer.invalidate()
        mode = .stopped
            }
    }

struct ContentView: View {
    
    @State private var currentState = Int.random(in: 0...2)
    @State private var winOrLose = Int.random(in: 0...1)
    @State private var pChoice = 2
    @State private var scoreTitle = ""
    @State private var roundNumber = 1
    @State private var gameOver = false
    @State private var pScore = 0
    @State private var pCOrI = ""
    
    @ObservedObject var stopWatch = StopWatch()
    
    var states = ["🪨", "📄", "✂️"]
    var playerChoice = ["🪨", "📄", "✂️"]
    var wol = ["Win", "Lose"]
    
    
    
    var correctOutcome: Int {
        
        if winOrLose == 0 {
            
            if currentState == 0 {
                return 1
            } else if currentState == 1 {
                return 2
            } else if currentState == 2 {
                return 0
            } else {
                return 5
                }
        }
        
        if winOrLose == 1 {
            
            if currentState == 0 {
                return 2
            } else if currentState == 1 {
                return 0
            } else if currentState == 2 {
                return 1
            } else {
                return 5
                }
        }
        return 5
        
    }
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 300) {
            Text("Rock, Paper, or Scissors?")
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontWeight(.black)
                
            
            Spacer()
            }
        
            VStack(spacing: 30) {

            VStack() {
                ForEach(0..<1) { number in
                    ImageView(imageName: states[currentState])
                }
            }
                
                VStack() {
                    ForEach(0..<1) { number in
                        Text("You must: \(wol[winOrLose])")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .fontWeight(.black)
                    }
                }
                
                HStack(alignment: .center, spacing: 30) {
                    Button(action: {
                        pChoice = 0
                        self.startTimer()
                        self.chosen()
                        self.newState()
                    }) {
                        ImageView(imageName: "🪨")
                    }
                Button(action: {
                    pChoice = 1
                    self.startTimer()
                    self.chosen()
                    self.newState()
                }) {
                    ImageView(imageName: "📄")
                }
                Button(action: {
                    pChoice = 2
                    self.startTimer()
                    self.chosen()
                    self.newState()
                }) {
                    ImageView(imageName: "✂️")
                    }
                }
                
                HStack(spacing: 30) {
                    Text("Round: \(roundNumber)/10")
                        .font(.largeTitle)
                        .foregroundColor(Color.gray)
                        .fontWeight(.black)
                    Text ("Score: \(pScore)")
                        .font(.largeTitle)
                        .foregroundColor(Color.gray)
                        .fontWeight(.black)
                }
                
                Text("\(pCOrI)")
                    .foregroundColor(pCOrI == "Correct!" ? Color.green : Color.red)
                    .font(.largeTitle)
                    .fontWeight(.black)
                
                VStack() {
                    Text(String(format: "%.2f", stopWatch.secondsElapsed))
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .fontWeight(.black)
                }
                
                }
            }
        .alert(isPresented: $gameOver) {
            Alert(title: Text("Game over"), message: Text("You scored \(pScore) points"), dismissButton: .default(Text("New game")){
            self.newGame()
            })
        }
    }
    
    
    func startTimer() {
        if stopWatch.secondsElapsed == 0.00 {
            self.stopWatch.start()
        }
    }
        
    func newGame() {
        currentState = Int.random(in: 0...2)
        winOrLose = Int.random(in: 0...1)
        pScore = 0
        roundNumber = 1
        pCOrI = ""
        stopWatch.secondsElapsed = 0.00
    }
    
    
    
    func chosen() {
        
        if pChoice == correctOutcome {
            pCOrI = "Correct!"
        } else {
            pCOrI = "Incorrect"
        }
        
        if pChoice == correctOutcome {
            pScore += 10
        }
        
        
    }
    

    func newState() {
        
        if roundNumber == 10 {
            gameOver = true
            self.stopWatch.stop()
        }
        
        currentState = Int.random(in: 0...2)
        winOrLose = Int.random(in: 0...1)
        roundNumber += 1
        
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        }
    }
}
