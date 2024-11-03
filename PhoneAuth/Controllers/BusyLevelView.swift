import SwiftUI

struct BusyLevelView: View {
    @Binding var busyLevelText: String
    
    private let apiKey: String = "YOUR API KEY"
    private let venueId: String = "ven_5965782d62435251644858524159365f51575f357263394a496843"
    
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
                Text("Gym Busy Level")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                // Busy level text with gradient border
                ZStack {
                    Text(busyLevelText)
                        .font(.system(size: 48, weight: .semibold, design: .rounded))
                        .foregroundColor(busyLevelColor(busyLevelText))
                        .shadow(color: busyLevelColor(busyLevelText).opacity(0.4), radius: 10, x: 0, y: 5)
                    
                    Circle()
                        .strokeBorder(
                            LinearGradient(
                                gradient: Gradient(colors: [busyLevelColor(busyLevelText).opacity(0.6), .white]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 5
                        )
                        .frame(width: 180, height: 180)
                        .shadow(color: busyLevelColor(busyLevelText).opacity(0.5), radius: 15, x: 0, y: 5)
                }
                
                // Button to update busy level
                Button(action: {
                    fetchBusyLevel()
                }) {
                    Text("Update Busy Level")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
            }
            .padding()
        }
    }
    
    private func busyLevelColor(_ busyLevel: String) -> Color {
        switch busyLevel.lowercased() {
        case "quiet":
            return .green
        case "average":
            return .blue
        case "busy":
            return .orange
        case "very busy":
            return .red
        default:
            return .gray
        }
    }
    
    func fetchBusyLevel() {
        // Get current day of the week and hour
        let currentDate = Date()
        let calendar = Calendar.current
        let dayInt = calendar.component(.weekday, from: currentDate) // Sunday is 1, Saturday is 7
        let hour = calendar.component(.hour, from: currentDate)
        
        // Construct URL with dynamic parameters
        var urlComponents = URLComponents(string: "https://besttime.app/api/v1/forecasts/hour")!
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key_public", value: apiKey),
            URLQueryItem(name: "venue_id", value: venueId),
            URLQueryItem(name: "day_int", value: "\(dayInt)"),
            URLQueryItem(name: "hour", value: "\(hour)")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let analysis = json["analysis"] as? [String: Any],
                   let hourAnalysis = analysis["hour_analysis"] as? [String: Any],
                   let intensityText = hourAnalysis["intensity_txt"] as? String {
                    
                    DispatchQueue.main.async {
                        busyLevelText = intensityText
                    }
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }
        
        task.resume()
    }
}
