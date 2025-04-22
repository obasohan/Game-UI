//
//  ContentView.swift
//  Project 3
//
//  Created by Aisosa Obasohan on 17/01/2025.
//

import SwiftUI

struct FlagImage: View {
   let text: String
    
    var body: some View {
        Image(text)
            .cornerRadius(6)
            .shadow(radius: 1)
    }
}


struct ContentView: View {
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var isTapped = false
    @State private var feedback = ""
    @State private var userScore = 0
    @State private var questionCounter = 1
    @State private var gameOver = false
    @State private var animationAmount = 0.0
    @State private var selectedFlag : Int?
  
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            
            VStack(spacing:40) {
                
                Spacer()
                Spacer()
                
                
                VStack(spacing:12) {
                    Text("Guess the flag")
                        .font(.title2)
                    Text(countries[correctAnswer])
                        .font(.largeTitle.weight(.bold))
                }
                
                
                ForEach(0...2, id:\.self) { number in
                    Button() {
                        systemResponse(number)
                        selectedFlag = number
                        withAnimation {
                            animationAmount += 360
                        }
                    } label: {
                        FlagImage(text:countries[number])
                    }
                    .rotation3DEffect(.degrees(selectedFlag == number ? animationAmount : 0), axis: (x:0, y:1, z:0))
                    .opacity(selectedFlag == nil || selectedFlag == number ? 1 : 0.25)
                    .blur(radius: selectedFlag == nil || selectedFlag == number ? 1 : 0.25)
                }
                
                
                Spacer()
                
                
                Text("Score: \(userScore)")
                    .font(.title3)
                
                Spacer()
                Spacer()
            }
            
        }
        .alert (feedback, isPresented: $isTapped) {
            Button("Continue", action: nextQuestion)
        } message: {
            Text("Your score is \(userScore)")
        }
        
        .alert ("Gameover", isPresented: $gameOver){
            Button("Restart Game", action: resetGame)
        } message: {
            Text("Final score: \(userScore)")
        }
    }
    
    
    
    func systemResponse (_ number: Int) {
        if number == correctAnswer {
            feedback = "Correct!"
            userScore += 1
            
        } else {
            let requireThe = ["UK", "US"]
            let userInput = countries[number]
            
            if requireThe.contains(userInput) {
                feedback = "Wrong! This is the flag of the \"\(countries[number])\""
            } else {
                feedback = "Wrong! This is the flag of \"\(countries[number])\""
            }
            
            
            if userScore > 0 {
                userScore -= 1
            }
            
        }
        
        
        if questionCounter == 8 {
            gameOver = true
        } else {
            isTapped = true
        }
        
    }
    
    
    func nextQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
        animationAmount = 0
        selectedFlag = nil
    }
    
    
    func resetGame() {
        questionCounter = 0
        userScore = 0
        countries = ContentView.allCountries
        nextQuestion()
        
    }
    
}

#Preview {
    ContentView()
}
