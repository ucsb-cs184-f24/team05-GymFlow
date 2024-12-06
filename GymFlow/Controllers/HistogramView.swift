import SwiftUI

struct HistogramView: View {
    var data: [HourAnalysis]
    
    var body: some View {
        VStack(spacing: 8) { // Add vertical spacing between bars and labels
            HistogramContainerView(data: data)
                .frame(height: 250) // Set the height for the histogram
        }
    }
}

// Subview for a single bar in the histogram
struct HistogramBarView: View {
    var entry: HourAnalysis
    var barWidth: CGFloat = 20
    var barHeightMultiplier: CGFloat = 40

    var body: some View {
        VStack {
            if entry.intensityNr == 999 {
                // Display "Closed" for certain hours
                Text("Closed")
                    .font(.caption2)
                    .foregroundColor(.red)
                    .frame(width: barWidth)
            } else {
                // Normalize intensity
//                let adjustedIntensity = max(0, Double(entry.intensityNr) + 2) // Shift range [-2, 2] to [0, 4]

                // Display bar
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: barWidth, height: CGFloat(entry.intensityNr) * 2)
//                    .frame(width: barWidth, height: CGFloat(adjustedIntensity) * barHeightMultiplier)
            }
        }
    }
}

// Main Histogram container
struct HistogramContainerView: View {
    var data: [HourAnalysis]
    var barWidth: CGFloat = 16
    var barSpacing: CGFloat = 4 // Set to 0 to make bars touch

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Add a horizontal line with a "100%" label
            VStack(spacing: 0) {
                // Calculate the total width of the bars and spacing
                let totalWidth = CGFloat(data.count) * barWidth + CGFloat(data.count - 1) * barSpacing
                
                // "100%" Label and Line
                HStack {
                    Text("100%")
                        .font(.caption)
                        .foregroundColor(.black)
                        .offset(x:-20, y: -15) // Slightly above the line
                    Spacer()
                }
                .frame(width: totalWidth) // Match the width of the histogram

                Rectangle()
                    .fill(Color.black.opacity(0.5)) // Faint gray line
                    .frame(height: 1)
                    .frame(width: 340) // Set line width to match the total histogram width
                    .offset(x:-92, y: -15) // Adjust the line position
            }
            .padding(.leading, 20) // Align the line with the histogram
            
            
            VStack(spacing: 4) { // Add spacing between bars and labels
                // Bars section
                HStack(alignment: .bottom, spacing: barSpacing) {
                    ForEach(data, id: \.hour) { entry in
                        HistogramBarView(entry: entry, barWidth: barWidth)
                    }
                }
                
                // Time labels section
                HStack(spacing: 0) {
                    Text("6AM")
                        .font(.caption2)
                        .foregroundColor(.black)
                        .frame(width: 29)
                        .offset(x: -30)
                    
                    Spacer().frame(width: 45)
                    
                    Text("9AM")
                        .font(.caption2)
                        .foregroundColor(.black)
                        .frame(width: 29)
                        .offset(x: -44)
                    
                    Spacer().frame(width: 45)
                    
                    Text("12PM")
                        .font(.caption2)
                        .foregroundColor(.black)
                        .frame(width: 29)
                        .offset(x: -55)
                    
                    Spacer().frame(width: 45)
                    
                    Text("3PM")
                        .font(.caption2)
                        .foregroundColor(.black)
                        .frame(width: 29)
                        .offset(x: -71)
                    
                    Spacer().frame(width: 45)
                    
                    Text("6PM")
                        .font(.caption2)
                        .foregroundColor(.black)
                        .frame(width: 29)
                        .offset(x: -85)
                    
                    Spacer().frame(width: 45)
                    
                    Text("9PM")
                        .font(.caption2)
                        .foregroundColor(.black)
                        .frame(width: 29)
                        .offset(x: -98)
                }
                .offset(x: -16)
            }
        }
        .offset(x: 83, y: 50) // Move the entire histogram down and to the right
    }
    private func calculateHistogramWidth() -> CGFloat {
           let totalBarsWidth = CGFloat(data.count) * barWidth
           let totalSpacing = CGFloat(data.count - 1) * barSpacing
           return totalBarsWidth + totalSpacing
       }

    private func formatHour(_ hour: Int) -> String {
            if hour == 0 {
                return "12AM"
            } else if hour < 12 {
                return "\(hour)AM"
            } else if hour == 12 {
                return "12PM"
            } else if hour > 12 && hour < 24 {
                return "\(hour - 12)PM"
            } else {
                return "" // Return an empty string for invalid hours
            }
        }
}
