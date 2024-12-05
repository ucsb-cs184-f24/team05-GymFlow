import SwiftUI
import Combine

struct BusyLevelView: View {
    @ObservedObject var model: BusyLevelModel
    @State private var needleAngle: Double = 0 // State variable for the needle's angle

    var body: some View {
        ZStack {
            // Background set to white
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 60) {
                // Title
                Text("Gym Busy Level")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(.black)
                    .padding(.top, -20)
                                
                // Speedometer
                ZStack {
                    // Speedometer arc
                    SpeedometerArc()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .yellow, .red]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 20
                        )
                        .frame(width: 250, height: 250)

                    // Speedometer needle
                    NeedleView(angle: needleAngle)
                        .stroke(Color.black, lineWidth: 4) // Changed needle color to black for visibility
                        .frame(width: 210, height: 210)

                    // Labels for empty and full
                    HStack {
                        Text("Empty")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)
                            .offset(x: -50, y: 20)
                        Spacer()
                        Text("Full")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)
                            .offset(x: 40, y: 20)
                    }
                    .frame(width: 200, height: 200)
                }
                .frame(height: 220)
                .onChange(of: model.busyLevelText) { newBusyLevel in
                    // Smoothly update the needle angle when busy level changes
                    withAnimation(.easeInOut(duration: 0.5)) {
                        needleAngle = mapBusyLevelToAngle(busyLevel: newBusyLevel)
                    }
                }
                                
                // Busy level text
                Text(model.busyLevelText)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundColor(.black) // Adjusted to black for better contrast
                    .padding(.top, -100)
                
                // Button to update busy level
                Button(action: {
                    model.fetchBusyLevel() // Fetches the updated busy level
                }) {
                    Text("Refresh")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
            }
            .padding()
        }
        .onAppear {
            // Initialize the needle position on launch
            model.fetchBusyLevel()
            needleAngle = mapBusyLevelToAngle(busyLevel: model.busyLevelText)
        }
    }
    
    private func mapBusyLevelToAngle(busyLevel: String) -> Double {
        switch busyLevel.lowercased() {
        case "empty":
            return -90
        case "low":
            return -45
        case "below average":
            return -30
        case "average":
            return 0
        case "busy":
            return 30
        case "above average":
            return 45
        case "high":
            return 90
        default:
            print("Unexpected busy level: \(busyLevel)")
            return 0
        }
    }
}

struct SpeedometerArc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        return path
    }
}

struct NeedleView: Shape {
    var angle: Double
    
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        let needleLength = rect.width / 2
        let endPoint = CGPoint(
            x: center.x + needleLength * cos(CGFloat(angle - 90) * .pi / 180),
            y: center.y + needleLength * sin(CGFloat(angle - 90) * .pi / 180)
        )
        path.addLine(to: endPoint)
        return path
    }
}
