import SwiftUI
import Combine

struct BusyLevelView: View {
    @ObservedObject var model: BusyLevelModel
    @ObservedObject var forecastModel: ForecastModel
    @State private var needleAngle: Double = -90 // State variable for the needle's angle (0 starts at -90 degrees)

    var body: some View {
        ZStack {
            // Background set to white
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Title
                Text("Gym Forecast")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(.black)
                    .offset(y: 0)
                
                // Speedometer
                ZStack {
                    // Speedometer arc
                    SpeedometerArc()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 20
                        )
                        .frame(width: 250, height: 250)
                        .offset(y:55)
                    
                    // Speedometer needle
                    NeedleView(angle: needleAngle)
                        .stroke(Color.black, lineWidth: 4) // Changed needle color to black for visibility
                        .frame(width: 210, height: 210)
                        .offset(y:55)
                    
                    // Labels for empty and full
                    HStack {
                        Text("Empty")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)
                            .offset(x: -50, y: 20)
                        Spacer()
                        Text("Full")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)
                            .offset(x: 40, y: 20)
                    }
                    .offset(y:55)
                    .frame(width: 200, height: 200)
                    
                }
                .frame(height: 150)
                .onChange(of: model.busyLevelValue) { newBusyLevel in
                    // Smoothly update the needle angle when busy level changes
                    withAnimation(.easeInOut(duration: 0.5)) {
                        needleAngle = mapValueToAngle(value: newBusyLevel)
                    }
                }
                
                
                // Display the percentage and the dynamic description
                VStack {
                    Text("Gym Capacity: \(Int(model.busyLevelValue))%")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.black)
                    
                    Text(getBusyLevelDescription(for: model.busyLevelValue))
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.black)
                }
                .offset(y: -15)
                
                
                if forecastModel.hourAnalysis.isEmpty {
                    Text("Press Predict to fetch data")
                        .foregroundColor(.black)  // Changed to black for better contrast
                        .italic()
                } else {
//                    ScrollView(.horizontal) {
                    HistogramView(data: forecastModel.hourAnalysis)
                        .frame(height: 300)
                        .padding(.horizontal)
//                    }
                }
            }
        }
        .onAppear {
            // Initialize the needle position on launch
            forecastModel.fetchDayForecast()
            model.fetchBusyLevel()
            needleAngle = mapValueToAngle(value: model.busyLevelValue)
        }
    }
    
    // Move these methods outside of `body`
    private func mapValueToAngle(value: Double) -> Double {
        // Maps a value between 0 and 100 to an angle between -90 and 90
        return -90 + (value / 100 * 180)
    }
    
    private func getBusyLevelDescription(for value: Double) -> String {
        // Dynamic description based on busy level
        switch value {
        case 0..<26:
            return "Almost Empty – Best Time to Hit the Gym!"
        case 26..<51:
            return "Not Crowded – Plenty of Space!"
        case 51..<76:
            return "Moderate Crowd – Plan Accordingly!"
        case 76...100:
            return "Crowded – Be Ready for a Wait!"
        default:
            return "Data Unavailable"
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
