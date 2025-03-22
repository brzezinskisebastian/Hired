//
//  ContentView.swift
//  Hired
//
//  Created by Sebastian Brzeziński on 22/03/2025.
//
import SwiftUI

struct ContentView: View {
    @State private var buttonOffset: CGFloat = 0
    @State private var showButton = true
    @State private var showThinkingCircle = false
    @State private var statusText: String = ""
    @State private var showHired = false
    @State private var progressValue: CGFloat = 0
    @State private var showConfetti = false
    @State private var showLookingForJob = true
    
    let statusMessages = [
        "Checking positions...",
        "Checking possibilities...",
        "Checking opportunities...",
        "Validating results...",
        "One moment more...",
        "Gathering references...",
        "Verifying credentials...",
        "Analyzing your profile...",
        "Matching with roles..."
    ]
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            Text("Looking for a new job?")
                .foregroundColor(.gray)
                .font(.custom("Avenir", size: 28))
                .offset(x: 0, y: -100)
                .opacity(showLookingForJob ? 1 : 0)
                .animation(.easeInOut(duration: 2.0), value: showLookingForJob)
            
            Button(action: {
                buttonTapped()
            }) {
                Text("Check for Position")
                    .font(.custom("Avenir", size: 24))
                    .foregroundColor(.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 22)
                    .background(Color("ButtonColor"))
                    .cornerRadius(12)
            }
            .shadow(color: .gray, radius: 5, x: 0, y: 4)
            .opacity(showButton ? 1 : 0)
            .animation(.easeInOut(duration: 2.0), value: showButton)
            .disabled(!showButton)
            
            if !statusText.isEmpty {
                Text(statusText)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .offset(y: 100)
                    .transition(.opacity)
            }
            
            if showThinkingCircle && !showHired {
                ProgressBar(progress: progressValue)
                    .frame(width: 300, height: 10)
                    .offset(y: 160)
                    .transition(.opacity)
            }
            
            if showHired {
                Text("Hired!")
                    .font(.custom("Avenir", size: 50))
                    .fontWeight(.bold)
                    .foregroundColor(Color("ButtonColor"))
                    .transition(.scale)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                            withAnimation {
                                showConfetti = true
                            }
                        }
                    }
            }
            
            if showConfetti {
                ConfettiView()
            }
        }
    }
    
    private func buttonTapped() {
        withAnimation(.easeInOut(duration: 2.0)) {
            showLookingForJob = false
            showButton = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showThinkingCircle = true
            startStatusSequence()
        }
    }
    
    private func startStatusSequence() {
        let interval: Double = 2.0
        
        for i in 0..<statusMessages.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + (interval * Double(i))) {
                withAnimation {
                    statusText = statusMessages[i]
                    progressValue = CGFloat(i + 1) / CGFloat(statusMessages.count)
                }
            }
        }
        
        let totalTime = interval * Double(statusMessages.count)
        DispatchQueue.main.asyncAfter(deadline: .now() + totalTime) {
            withAnimation {
                showThinkingCircle = false
                statusText = ""
                progressValue = 1.0
                showHired = true
            }
        }
    }
}

struct ProgressBar: View {
    let progress: CGFloat
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .cornerRadius(5)
            
            Rectangle()
                .fill(Color("ButtonColor"))
                .cornerRadius(5)
                .frame(width: 300 * progress)
        }
        .frame(height: 10)
        .animation(.easeInOut, value: progress)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
