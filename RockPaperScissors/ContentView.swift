import SwiftUI

struct ContentView: View {
    // MARK: - Game State
    @State private var moves = ["Rock", "Paper", "Scissors"]
    @State private var appChoice = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var playerScore = 0
    @State private var systemScore = 0
    @State private var showingResult = false
    @State private var resultMessage = ""
    @State private var matchOver = false
    @State private var roundsToWin = 3

    // Computed threshold (e.g. best of 3 ⇒ first to 2)
    private var winThreshold: Int { (roundsToWin / 2) + 1 }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: Header
            headerBar

            // MARK: Main content
            VStack(spacing: 32) {
                scoreBoard
                challengeArea
                controlButtons
                settingsPanel
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
        }
        .alert("Round Result", isPresented: $showingResult) {
            Button("Continue", action: nextRound)
        } message: {
            Text(resultMessage)
        }
        .alert("Match Over", isPresented: $matchOver) {
            Button("Restart", action: resetGame)
        } message: {
            Text(finalMessage)
        }
    }

    // MARK: - Header
    private var headerBar: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.accentColor)
                Text("Rock • Paper • Scissors")
                    .font(.headline.weight(.semibold))
                Spacer()
            }
            .padding(.horizontal)
            .frame(height: 44)
            .background(Color(.systemGray6))
            Divider() // subtle console-style separator
        }
    }

    // MARK: - Scoreboard
    private var scoreBoard: some View {
        HStack(spacing: 24) {
            scoreCard(label: "You", score: playerScore, color: .accentColor)
            scoreCard(label: "System", score: systemScore, color: .gray)
        }
    }

    private func scoreCard(label: String, score: Int, color: Color) -> some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(score)")
                .font(.largeTitle.bold())
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Challenge display
    private var challengeArea: some View {
        VStack(spacing: 8) {
            Text("System chose:")
                .font(.headline)
                .foregroundColor(.secondary)

            Text(moves[appChoice])
                .font(.system(size: 40, weight: .bold))

            Text(resultMessageDisplay)
                .font(.title3.weight(.medium))
                .foregroundColor(.accentColor)
                .padding(.top, 6)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var resultMessageDisplay: String {
        if showingResult {
            return resultMessage
        } else {
            return "Make your move"
        }
    }

    // MARK: - Controls
    private var controlButtons: some View {
        HStack(spacing: 24) {
            ForEach(0..<moves.count, id: \.self) { index in
                Button(moves[index]) {
                    playerTapped(index)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    // MARK: - Settings
    private var settingsPanel: some View {
        VStack(spacing: 12) {
            Text("Match length: Best of \(roundsToWin)")
                .font(.footnote)
                .foregroundColor(.secondary)

            Picker("Best of", selection: $roundsToWin) {
                Text("3").tag(3)
                Text("5").tag(5)
                Text("7").tag(7)
            }
            .pickerStyle(.segmented)
            .frame(width: 220)
        }
        .padding(.top, 12)
    }

    // MARK: - Game Logic
    private func playerTapped(_ number: Int) {
        let result = (number - appChoice + 3) % 3
        let playerWon = (result == 1)

        if result == 0 {
            resultMessage = "It's a draw."
        } else if playerWon {
            resultMessage = "You chose correctly!"
            playerScore += 1
        } else {
            resultMessage = "You chose poorly."
            systemScore += 1
        }

        showingResult = true
        checkForMatchEnd()
    }

    private func checkForMatchEnd() {
        if playerScore == winThreshold || systemScore == winThreshold {
            matchOver = true
        }
    }

    private func nextRound() {
        appChoice = Int.random(in: 0...2)
        shouldWin.toggle()
        showingResult = false
    }

    private func resetGame() {
        playerScore = 0
        systemScore = 0
        appChoice = Int.random(in: 0...2)
        shouldWin = Bool.random()
        showingResult = false
        matchOver = false
    }

    private var finalMessage: String {
        if playerScore > systemScore {
            return "You won the match!"
        } else if systemScore > playerScore {
            return "System wins the match."
        } else {
            return "It’s a draw overall."
        }
    }
}

#Preview { ContentView() }
