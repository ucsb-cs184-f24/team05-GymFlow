import Foundation

class BusyLevelModel: ObservableObject {
    @Published var busyLevelValue: Double = 0.0 // Numerical value for the busy level (hour_raw)

    private let apiKey: String = "pub_4d0a5a1b737440089c59f063cc9236a7"
    private let venueId: String = "ven_5965782d62435251644858524159365f51575f357263394a496843"

    func fetchBusyLevel() {
        // Construct URL for the "query_now_raw" endpoint
        var urlComponents = URLComponents(string: "https://besttime.app/api/v1/forecasts/now/raw")!
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key_public", value: apiKey),
            URLQueryItem(name: "venue_id", value: venueId)
        ]

        guard let url = urlComponents.url else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let analysis = json["analysis"] as? [String: Any],
                   let hourRaw = analysis["hour_raw"] as? Double {
                    DispatchQueue.main.async {
                        self.busyLevelValue = hourRaw
                        print("Updated Busy Level Value: \(hourRaw)")
                    }
                } else {
                    print("Error: JSON structure is not as expected.")
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }
        task.resume()
    }
}
