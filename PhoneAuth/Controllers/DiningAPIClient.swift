//
//  DiningAPIClient.swift
//  PhoneAuth
//
//  Created by Nevin Manimaran on 11/29/24.
//

import Foundation

class DiningAPIClient {
    static let shared = DiningAPIClient()
    private let baseURL = "https://api.ucsb.edu/dining/menu/v1"
    private let apiKey: String
    
    private init() {
        self.apiKey = MealPlanViewController.apiKey
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

