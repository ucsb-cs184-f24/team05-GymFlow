import SwiftUI
import Combine

struct BusyLevelView: View {
    @ObservedObject var model: BusyLevelModel
    @ObservedObject var forecastModel: ForecastModel
    @State private var needleAngle: Double = -90 // State variable for the needle's angle (0 starts at -90 degrees)

    var body: some View {
        ScrollView { // Wrap the content in a ScrollView to allow pull-to-refresh
            ZStack {
                // Background set to white
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 5) { // Adjust spacing between title and subtitle
                    // Main Title
                    Text("UCSB Recreation Center")
                        .font(.system(size: 28, weight: .bold)) // Adjust size and weight for hierarchy
                        .foregroundColor(.black)
                        .offset(y: -20)
                    
                    // Subtitle
                    Text("Gym Forecast")
                        .font(.system(size: 20, weight: .semibold)) // Smaller, secondary font
                        .foregroundColor(.black.opacity(0.7)) // Softer color for distinction
                        .offset(y: -20)
                    
                    // Speedometer Section with Gray Background
                    ZStack {
                        // Gray transparent background
                        RoundedRectangle(cornerRadius: 12) // Smaller corner radius
                            .fill(Color.gray.opacity(0.2)) // Slightly lighter gray
                            .frame(width: 360, height: 260) // Reduced size
                            .offset(y: 0)
                        // Speedometer
                        VStack {
                            ZStack {
                                SpeedometerArc()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.blue]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 18 // Thinner arc
                                    )
                                    .frame(width: 230, height: 230) // Smaller speedometer
                                    .offset(y: 50)
                                
                                NeedleView(angle: needleAngle)
                                    .stroke(Color.black, lineWidth: 3) // Thinner needle
                                    .frame(width: 200, height: 200)
                                    .offset(y: 50)
                                
                                // Labels for empty and full
                                HStack {
                                    Text("Empty")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded)) // Smaller font
                                        .foregroundColor(.black)
                                        .offset(x: -44, y: 68)
                                    Spacer()
                                    Text("Full")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded)) // Smaller font
                                        .foregroundColor(.black)
                                        .offset(x: 38, y: 68)
                                }
                                .frame(width: 180, height: 180) // Reduced size
                            }
                            .frame(height: 140) // Smaller overall height
                            .onChange(of: model.busyLevelValue) { newBusyLevel in
                                // Smoothly update the needle angle when busy level changes
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    needleAngle = mapValueToAngle(value: newBusyLevel)
                                }
                            }
                            
                            // Display the percentage and the dynamic description
                            VStack(spacing: 5) { // Tighter spacing
                                Text("Gym Capacity: \(Int(model.busyLevelValue))%")
                                    .font(.system(size: 18, weight: .medium, design: .rounded)) // Smaller font
                                    .foregroundColor(.black)
                                
                                Text(getBusyLevelDescription(for: model.busyLevelValue))
                                    .font(.system(size: 18, weight: .medium, design: .rounded)) // Smaller font
                                    .foregroundColor(.black)
                            }
                            .offset(y: 10)
                        }
                    }
                    
                    // Histogram Section with Gray Background
                    ZStack {
                        // Gray transparent background
                        RoundedRectangle(cornerRadius: 12) // Smaller corner radius
                            .fill(Color.gray.opacity(0.2)) // Slightly lighter gray
                            .frame(width: 360, height: 260) // Reduced size
                            .offset(y: 30)
                        if forecastModel.hourAnalysis.isEmpty {
                            Text("Press Predict to fetch data")
                                .foregroundColor(.black)
                                .italic()
                                .font(.system(size: 14)) // Smaller font
                        } else {
                            HistogramView(data: forecastModel.hourAnalysis)
                                .frame(height: 240) // Reduced height for histogram
                                .padding(.horizontal)
                        }
                        Spacer()
                            .frame(height: 20)
                    }
                }
                .padding(.top, 30) // Move the entire content down by 20 point
            }
        }
        .refreshable { // Add pull-to-refresh functionality
            // Refresh logic
            forecastModel.fetchDayForecast()
            model.fetchBusyLevel()
            needleAngle = mapValueToAngle(value: model.busyLevelValue)
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
        case 0:
            return "The gym is currently closed. Rest day it is!"
        case 1..<26:
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
