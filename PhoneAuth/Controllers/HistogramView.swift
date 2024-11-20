import SwiftUI

struct HistogramView: View {
    var data: [HourAnalysis]
    
    var body: some View {
        let maxIntensity = data.map { $0.intensityNr }.max() ?? 1
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: 16) {
                ForEach(data, id: \.hour) { entry in
                    VStack {
                        Text(String(format: "%.0f%%", (Double(entry.intensityNr) / Double(maxIntensity)) * 100))
                            .font(.caption2)
                            .foregroundColor(.white)
                        
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                            .frame(width: 24, height: CGFloat(entry.intensityNr) * 200 / CGFloat(maxIntensity))
                        
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

