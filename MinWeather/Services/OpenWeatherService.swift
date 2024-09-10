//
//  OpenWeatherService.swift
//  MinWeather
//
//  Created by Thiago Souza on 08/09/24.
//

import Foundation
import Alamofire

struct FetchWeatherDataResponse: Codable {
    let name: String
    let weather: [WeatherItem]
    let main: WeatherMain
    let wind: Wind
    let visibility: Int
    let dt: Int
    
    struct WeatherItem: Codable {
        let main: String
        let description: String
        let icon: String
    }

    struct WeatherMain: Codable {
        let temp: Double
        let humidity: Int
    }

    struct Wind: Codable {
        let speed: Double
    }
}

class OpenWeatherService {
    private let baseUrl = "https://api.openweathermap.org/data/2.5"
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func fetchWeatherData(lat: Double, lon: Double, completion: @escaping (FetchWeatherDataResponse?, Error?) -> Void) {
        let api_key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
        let endpoint = "/weather"
        let queryParams = "?lat=\(lat)&lon=\(lon)&appid=\(api_key)&units=metric"
        let url = "\(self.baseUrl)\(endpoint)\(queryParams)"
        
        session.request(url)
            .validate()
            .responseDecodable(of: FetchWeatherDataResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
