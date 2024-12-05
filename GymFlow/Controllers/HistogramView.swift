import SwiftUI

struct HistogramView: View {
    var data: [HourAnalysis]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) { // Adjust the spacing between bars
            ForEach(data, id: \.hour) { entry in
                VStack {
                    // Handle "Closed" case (999) and adjust intensity
                    if entry.intensityNr == 999 {
                        Text("Closed")
                            .font(.caption2)
                            .foregroundColor(.red) // Keep "Closed" in red for visibility
                    } else {
                        // Normalize intensity
                        let adjustedIntensity = max(0, Double(entry.intensityNr) + 2) // Shift range [-2, 2] to [0, 4]
                        let percentage = (adjustedIntensity / 4.0) * 100 // Normalize to percentage [0, 100]
                        
                        // Display percentage
                        Text(String(format: "%.0f%%", percentage))
                            .font(.caption2)
                            .foregroundColor(.black) // Change text color to black for visibility against white background
                        
                        // Create a solid blue rectangle based on normalized intensity
                        Rectangle()
                            .fill(Color.blue) // Use solid blue color
                            .frame(width: 30, height: CGFloat(adjustedIntensity) * 50) // Adjust width to 30, height based on intensity
                    }
                    
                    // Display hour
                    Text(formatHour(entry.hour))
                        .font(.caption2)
                        .foregroundColor(.black) // Change hour text color to black
                        .lineLimit(1)
                        .frame(width: 40)
                }
            }
        }
        .padding()
    }
    
    private func formatHour(_ hour: Int) -> String {
        if hour == 0 { return "12 AM" }
        else if hour < 12 { return "\(hour) AM" }
        else if hour == 12 { return "12 PM" }
        else { return "\(hour - 12) PM" }
    }
}
