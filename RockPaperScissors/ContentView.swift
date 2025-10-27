//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Rob Downing on 2025-10-26.
//

import SwiftUI
import UIKit // for haptic feedback

struct ContentView: View {
    @State private var moves = ["🪨 Rock", "📄 Paper", "✂️ Scissors"]
    @State private var appChoice = Int.random(in: 0..<3)
    @State private var playerScore = 0
    @State private var systemScore = 0
    @State private var shouldWin = Bool.random()
    @State private var roundsToWin = 3
    @State private var showingResult = false
    @State private var resultMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // MARK: Scoreboard
                VStack {
                    Text("Scoreboard")
                        .font(.headline)
                    HStack(spacing: 40) {
                        Label("\(playerScore)", systemImage: "person.fill")
                            .symbolEffect(.bounce, value: playerScore) // simple animation
                        Label("\(systemScore)", systemImage: "cpu.fill")
                            .symbolEffect(.bounce, value: systemScore)
                    }
                    .font(.title.bold())
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // MARK: System move display
                VStack(spacing: 8) {
                    Text("System chose:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(moves[appChoice])
                        .font(.largeTitle.bold())
                    Text(showingResult ? resultMessage : "Make your move")
                        .font(.title3)
                        .foregroundColor(.accentColor)
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // MARK: Player buttons
                HStack(spacing: 20) {
                    ForEach(moves.indices, id: \.self) { index in
                        Button {
                            playerTapped(index)
                        } label: {
                            Text(moves[index])
                                .font(.title3.bold())
                                .frame(minWidth: 90)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                Spacer()

                // MARK: Rounds picker
                VStack(spacing: 8) {
                    Text("Match Length")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Picker("Best of", selection: $roundsToWin) {
                        Text("Best of 3").tag(3)
                        Text("Best of 5").tag(5)
                        Text("Best of 7").tag(7)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 220)
                }
            }
            .padding()
            .navigationTitle("Rock • Paper • Scissors")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Restart", action: resetGame)
                }
            }
            .background(Color(.systemBackground))
        }
    }

    // MARK: Game logic
    func playerTapped(_ index: Int) {
        let result = (index - appChoice + 3) % 3
        let generator = UINotificationFeedbackGenerator()

        if (result == 1 && shouldWin) || (result == 2 && !shouldWin) {
            playerScore += 1
            resultMessage = "You chose correctly!"
            generator.notificationOccurred(.success)
        } else {
            systemScore += 1
            resultMessage = "You chose poorly!"
            generator.notificationOccurred(.error)
        }

        showingResult = true
        nextRound()
    }

    func nextRound() {
        if playerScore >= (roundsToWin + 1) / 2 {
            resultMessage = "🎉 You won the match!"
        } else if systemScore >= (roundsToWin + 1) / 2 {
            resultMessage = "💀 The system won!"
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showingResult = false
                appChoice = Int.random(in: 0..<3)
                shouldWin.toggle()
            }
        }
    }

    func resetGame() {
        playerScore = 0
        systemScore = 0
        appChoice = Int.random(in: 0..<3)
        shouldWin = Bool.random()
        showingResult = false
        resultMessage = ""
    }
}

#Preview {
    ContentView()
}
