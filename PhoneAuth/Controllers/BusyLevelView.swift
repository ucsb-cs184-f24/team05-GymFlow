import SwiftUI
import Combine

struct BusyLevelView: View {
    @ObservedObject var model: BusyLevelModel
    @State private var needleAngle: Double = 0 // State variable for the needle's angle

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Title
                Text("Gym Busy Level")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
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
                        .frame(width: 200, height: 200)

                    // Speedometer needle
                    NeedleView(angle: needleAngle)
                        .stroke(Color.white, lineWidth: 4)
                        .frame(width: 160, height: 180)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)

                    // Labels for empty and full
                    HStack {
                        Text("Empty")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .offset(x: -15, y: 20)
                        Spacer()
                        Text("Full")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .offset(x: 15, y: 20)
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
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 10)

                // Button to update busy level
                Button(action: {
                    model.fetchBusyLevel() // Fetches the updated busy level
                }) {
                    Text("Update Busy Level")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 15)
                }
            }
            .padding()
        }
        .onAppear {
            // Initialize the needle position on launch
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
        case "very busy":
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
