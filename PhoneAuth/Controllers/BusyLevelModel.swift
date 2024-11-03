import Foundation

class BusyLevelModel: ObservableObject {
    @Published var busyLevelText: String = "Update"
    
    private let apiKey: String = "pub_9b71567b8c9a47e4a332171f7182be0a"
    private let venueId: String = "ven_5965782d62435251644858524159365f51575f357263394a496843"
    
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
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let analysis = json["analysis"] as? [String: Any],
                   let hourAnalysis = analysis["hour_analysis"] as? [String: Any],
                   let intensityText = hourAnalysis["intensity_txt"] as? String {
                    
                    DispatchQueue.main.async {
                        self?.busyLevelText = intensityText
                    }
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }
        
        task.resume()
    }
}
