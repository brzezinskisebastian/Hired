import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Rectangle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size * 2)
                        .rotationEffect(particle.rotation)
                        .position(x: particle.x, y: particle.y)
                }
            }
            .onAppear {
                createParticles(in: geometry.size)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func createParticles(in size: CGSize) {
      
        particles.removeAll()
        

        for _ in 0..<50 {
            let id = UUID()
            let xStart = CGFloat.random(in: 0...size.width)
            let particleSize = CGFloat.random(in: 8...14)
            let color = [Color.yellow, Color.orange, Color.white, Color.red, Color.blue, Color.green, Color.purple].randomElement()!
            let rotation = Angle(degrees: Double.random(in: 0...360))
            
            // Losowy czas opadania dla danej cząsteczki
            let fallDuration = Double.random(in: 6...10)
            let anim = Animation.linear(duration: fallDuration)
            
            let particle = ConfettiParticle(
                id: id,
                x: xStart,
                y: -50,
                size: particleSize,
                color: color,
                rotation: rotation,
                animation: anim
            )
            particles.append(particle)
        }
        

        for i in 0..<particles.count {
            let delay = Double.random(in: 0.0...1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(particles[i].animation) {
             
                    let horizontalDrift = CGFloat.random(in: -100...100)
                    particles[i].x += horizontalDrift
                   
                    particles[i].y = size.height + 50
              
                    particles[i].rotation = Angle(degrees: Double.random(in: 0...720))
                }
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id: UUID
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let color: Color
    var rotation: Angle
    let animation: Animation
}
