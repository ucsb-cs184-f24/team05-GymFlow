//import Foundation
//
//class ForecastModel: ObservableObject {
//    @Published var hourAnalysis: [HourAnalysis] = []
//    @Published var venueName: String = "UCSB Recreation Center"
//    @Published var venueOpen: String = "N/A"
//    @Published var venueClose: String = "N/A"
//    @Published var dayInfo: String = ""
//    
//    private let apiKey: String = "pub_69c0200007ea4e7b999c9e1da8bc6261"
//    private let venueId: String = "ven_5965782d62435251644858524159365f51575f357263394a496843"
//    
//    func fetchDayForecast() {
//        guard let url = URL(string: "https://besttime.app/api/v1/forecasts/day?api_key_public=\(apiKey)&venue_id=\(venueId)") else {
//            print("Invalid URL")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            guard let data = data, error == nil else {
//                print("Error fetching data: \(String(describing: error))")
//                return
//            }
//            
//            do {
//                let response = try JSONDecoder().decode(DayForecastResponse.self, from: data)
//                
//                DispatchQueue.main.async {
//                    self?.hourAnalysis = response.analysis.hourAnalysis.filter { $0.intensityNr != 999 }
//                    
//                    // Handle venueInfo
//                    self?.venueName = response.venueInfo?.venueName ?? "UCSB Recreational Center"
//                    
//                    // Handle dayInfo
//                    self?.venueOpen = response.analysis.dayInfo.venueOpen?.displayValue ?? "6AM"
//                    self?.venueClose = response.analysis.dayInfo.venueClose?.displayValue ?? "23:00"
//                    self?.dayInfo = response.analysis.dayInfo.dayText.capitalized
//                }
//            } catch {
//                print("Failed to parse JSON: \(error)")
//            }
//        }.resume()
//    }
//}
//
//struct DayForecastResponse: Decodable {
//    let analysis: Analysis
//    let venueInfo: VenueInfo?
//}
//
//
//struct Analysis: Decodable {
//    let hourAnalysis: [HourAnalysis]
//    let dayInfo: DayInfo
//    
//    private enum CodingKeys: String, CodingKey {
//        case hourAnalysis = "hour_analysis"
//        case dayInfo = "day_info"
//    }
//}
//
//struct HourAnalysis: Decodable, Equatable {
//    let hour: Int
//    let intensityNr: Int
//    let intensityTxt: String
//    
//    private enum CodingKeys: String, CodingKey {
//        case hour
//        case intensityNr = "intensity_nr"
//        case intensityTxt = "intensity_txt"
//    }
//}
//
//struct DayInfo: Decodable {
//    let dayText: String
//    let venueOpen: VenueHour?
//    let venueClose: VenueHour?
//    
//    private enum CodingKeys: String, CodingKey {
//        case dayText = "day_text"
//        case venueOpen = "venue_open"
//        case venueClose = "venue_close"
//    }
//}
//
//struct VenueInfo: Decodable {
//    let venueName: String
//    let venueAddress: String
//    
//    private enum CodingKeys: String, CodingKey {
//        case venueName = "venue_name"
//        case venueAddress = "venue_address"
//    }
//}
//
//enum VenueHour: Decodable {
//    case closed
//    case hour(Int)
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        
//        if let hour = try? container.decode(Int.self) {
//            self = .hour(hour)
//            return
//        }
//        
//        if let string = try? container.decode(String.self), string.lowercased() == "closed" {
//            self = .closed
//            return
//        }
//        
//        throw DecodingError.typeMismatch(VenueHour.self, DecodingError.Context(
//            codingPath: decoder.codingPath,
//            debugDescription: "Expected hour as Int or 'closed' as String"
//        ))
//    }
//    
//    var displayValue: String {
//        switch self {
//        case .closed:
//            return "Closed"
//        case .hour(let hour):
//            return "\(hour):00"
//        }
//    }
//}
//

import Foundation

class ForecastModel: ObservableObject {
    @Published var hourAnalysis: [HourAnalysis] = []
    @Published var venueName: String = "UCSB Recreation Center"
    @Published var venueOpen: String = "N/A"
    @Published var venueClose: String = "N/A"
    @Published var dayInfo: String = ""

    private let apiKey: String = "pub_4d0a5a1b737440089c59f063cc9236a7"
    private let venueId: String = "ven_5965782d62435251644858524159365f51575f357263394a496843"

    func fetchDayForecast() {
        guard let url = URL(string: "https://besttime.app/api/v1/forecasts/day/raw?api_key_public=\(apiKey)&venue_id=\(venueId)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(String(describing: error))")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(DayForecastResponse.self, from: data)
                
                DispatchQueue.main.async {
                    print("API day_raw data: \(response.analysis.dayRaw)") // Debug raw data
                    
                    // Map day_raw directly to hourAnalysis, starting from the open hour
                    let openHour = self?.getOpenHour() ?? 0
                    self?.hourAnalysis = response.analysis.dayRaw.enumerated().map { (index, intensity) in
                        HourAnalysis(hour: openHour + index, intensityNr: Int(intensity), intensityTxt: "\(Int(intensity))%")
                    }
                    
                    // Set venue opening and closing times
                    self?.setVenueHours()
                    self?.dayInfo = self?.getCurrentDayOfWeek() ?? "Today"
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }.resume()
    }

    private func setVenueHours() {
        let dayOfWeek = getCurrentDayOfWeek()
        
        switch dayOfWeek {
        case "Monday", "Tuesday", "Wednesday", "Thursday":
            venueOpen = "6:00 AM"
            venueClose = "11:00 PM"
        case "Friday":
            venueOpen = "6:00 AM"
            venueClose = "9:00 PM"
        case "Saturday":
            venueOpen = "9:00 AM"
            venueClose = "9:00 PM"
        case "Sunday":
            venueOpen = "9:00 AM"
            venueClose = "10:00 PM"
        default:
            venueOpen = "N/A"
            venueClose = "N/A"
        }
    }

    func getOpenHour() -> Int {
        let dayOfWeek = getCurrentDayOfWeek()
        switch dayOfWeek {
        case "Monday", "Tuesday", "Wednesday", "Thursday":
            return 6
        case "Friday":
            return 6
        case "Saturday", "Sunday":
            return 9
        default:
            return 0
        }
    }

    func getCloseHour() -> Int {
        let dayOfWeek = getCurrentDayOfWeek()
        switch dayOfWeek {
        case "Monday", "Tuesday", "Wednesday", "Thursday":
            return 23
        case "Friday":
            return 21
        case "Saturday":
            return 21
        case "Sunday":
            return 22
        default:
            return 0
        }
    }

    private func getCurrentDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Full day name
        return dateFormatter.string(from: Date())
    }
}

// Updated Decodable Structures
struct DayForecastResponse: Decodable {
    let analysis: DayRawAnalysis
    let status: String
}

struct DayRawAnalysis: Decodable {
    let dayRaw: [Double]
    
    private enum CodingKeys: String, CodingKey {
        case dayRaw = "day_raw"
    }
}

// Existing HourAnalysis Struct
struct HourAnalysis: Decodable, Equatable {
    let hour: Int
    let intensityNr: Int
    let intensityTxt: String
}
