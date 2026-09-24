//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nicole Kong Mei Ning on 21/09/2026.
//

// intuition: 12 countries in the poolm 3 visible per round, full reshuffle between rounds

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Ukraine", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var selectedFlag = -1
    @State private var questionsAsked = 0
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack {
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.white)
                    .padding(.top)
                
                Text("Score: \(score)")
                    .font(.title2.bold())
                    .foregroundStyle(Color.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                }
                
                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        Image(countries[number])
                            .clipShape(.capsule)
                            .shadow(radius: 5)
                    }
                    .rotation3DEffect(
                        .degrees(selectedFlag == number ? 360 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                    .animation(.default, value: selectedFlag)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button(questionsAsked == 8 ? "Restart" : "Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        questionsAsked += 1
        
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        if questionsAsked == 8 {
            scoreTitle = "Game Over!"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        if questionsAsked == 8 {
            score = 0
            questionsAsked = 0
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = -1
    }
}

#Preview {
    ContentView()
}
