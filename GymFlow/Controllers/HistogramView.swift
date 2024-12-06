import SwiftUI

struct HistogramView: View {
    var data: [HourAnalysis]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(data, id: \.hour) { entry in
                    if isValidHour(entry.hour) {
                        VStack {
                            // Display raw intensity percentage from the API
                            Text("\(entry.intensityNr)%")
                                .font(.caption2)
                                .foregroundColor(.white)
                            
                            // Create a bar based on the percentage
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.red, Color.green]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .frame(width: 24, height: CGFloat(entry.intensityNr) * 2) // Scale height for better visual clarity
                            
                            // Display the hour as a label
                            Text(formatHour(entry.hour))
                                .font(.caption2)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .frame(width: 40)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // Check if the hour is valid
    private func isValidHour(_ hour: Int) -> Bool {
        return hour >= 0 && hour < 24 // Only display valid hours
    }
    
    // Format the hour to display as "12 AM", "1 PM", etc.
    private func formatHour(_ hour: Int) -> String {
        if hour == 0 {
            return "12 AM"
        } else if hour < 12 {
            return "\(hour) AM"
        } else if hour == 12 {
            return "12 PM"
        } else if hour > 12 && hour < 24 {
            return "\(hour - 12) PM"
        } else {
            return "" // Return an empty string for invalid hours
        }
    }
}

