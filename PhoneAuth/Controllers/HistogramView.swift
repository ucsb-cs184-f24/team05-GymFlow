import SwiftUI

struct HistogramView: View {
    var data: [HourAnalysis]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: 16) {
                ForEach(data, id: \.hour) { entry in
                    VStack {
                        // Handle "Closed" case (999) and adjust intensity
                        if entry.intensityNr == 999 {
                            Text("Closed")
                                .font(.caption2)
                                .foregroundColor(.red)
                        } else {
                            // Normalize intensity
                            let adjustedIntensity = max(0, Double(entry.intensityNr) + 2) // Shift range [-2, 2] to [0, 4]
                            let percentage = (adjustedIntensity / 4.0) * 100 // Normalize to percentage [0, 100]
                            
                            // Display percentage
                            Text(String(format: "%.0f%%", percentage))
                                .font(.caption2)
                                .foregroundColor(.white)
                            
                            // Create a rectangle based on normalized intensity
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .frame(width: 24, height: CGFloat(adjustedIntensity) * 50) // Scale height appropriately
                        }
                        
                        // Display hour
                        Text(formatHour(entry.hour))
                            .font(.caption2)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .frame(width: 40)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func formatHour(_ hour: Int) -> String {
        if hour == 0 { return "12 AM" }
        else if hour < 12 { return "\(hour) AM" }
        else if hour == 12 { return "12 PM" }
        else { return "\(hour - 12) PM" }
    }
}


