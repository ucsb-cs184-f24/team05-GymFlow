import Foundation

class DiningAPIClient {
    static let shared = DiningAPIClient()
    private let baseURL = "https://api.ucsb.edu/dining/menu/v1"
    private let apiKey: String
    
    private init() {
        let loadedApiKey = DiningAPIClient.loadAPIKey()
                self.apiKey = loadedApiKey ?? ""
                
                if self.apiKey.isEmpty {
                    print("Warning: API key is empty. Make sure UCSB.plist exists and contains a valid API key.")
                }
    }
    private static func loadAPIKey() -> String? {
        guard let path = Bundle.main.path(forResource: "UCSB", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: xml, options: [], format: nil),
              let dict = plist as? [String: Any],
              let apiKey = dict["key"] as? String else {
            return nil
        }
        return apiKey
    }
    
    
    private func createRequest(path: String) -> URLRequest {
        var request = URLRequest(url: URL(string: baseURL + path)!)
        request.addValue(apiKey, forHTTPHeaderField: "ucsb-api-key")
        return request
    }
    
    func getMenu(date: String, diningCommonCode: String, mealCode: String, completion: @escaping (Result<[Entree], Error>) -> Void) {
        let request = createRequest(path: "/\(date)/\(diningCommonCode)/\(mealCode)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let entrees = try JSONDecoder().decode([Entree].self, from: data)
                completion(.success(entrees))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct Entree: Codable {
    let name: String
    let station: String
}

