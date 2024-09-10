//
//  HomeViewModel.swift
//  MinWeather
//
//  Created by Thiago Souza on 09/09/24.
//

import Foundation
import UIKit

class HomeViewModel: ObservableObject, UserLocationProtocol {
    private var locationManager: LocationManager?
    
    @Published private(set) var state: State = .loading
    @Published private(set) var imageName: String = ""
    @Published private(set) var dateDescription: String = ""
    @Published private(set) var cityName: String = ""
    @Published private(set) var temperature: Int = 0
    @Published private(set) var weatherKey: String = ""
    @Published private(set) var weatherDescription: String = ""
    @Published private(set) var humidity: Int = 0
    @Published private(set) var windSpeed: Int = 0
    @Published private(set) var visibility: Int = 0
    
    enum State {
        case loading
        case loaded
        case error
    }
    
    
    private let openWeatherService: OpenWeatherService
    
    init(openWeatherService: OpenWeatherService) {
        self.openWeatherService = openWeatherService
    }
 
    
    func fetchData() {
        self.state = .loading
        self.locationManager = LocationManager(userLocationProtocol: self)
        self.locationManager?.requestPermission()
    }
    
    
    func onUserLocationPermissionGranted() {
        self.state = .loading
        self.locationManager?.requestLocation()
    }
    
    func onUserLocationPermissionDenied() {
        self.state = .error
    }
    
    func onUserLocationReceived(latitude: Double, longitude: Double) {
        self.state = .loading
        
        self.openWeatherService.fetchWeatherData(lat: latitude, lon: longitude) { response, error in
            if error != nil {
                self.state = .error
                return
            }
            
            if let data = response {
                let date = Date(timeIntervalSince1970: TimeInterval(data.dt))
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM d, YYYY"
                
                self.dateDescription = formatter.string(from: date)
                self.cityName = data.name
                self.temperature = Int(data.main.temp)
                self.weatherKey = data.weather.first!.main
                self.weatherDescription = data.weather.first!.description.capitalized
                self.humidity = data.main.humidity
                self.windSpeed = Int(data.wind.speed)
                self.visibility = data.visibility / 1000
                
                let imagePrefix = data.weather.first!.icon.last!
                let imageName = "\(imagePrefix)_\(self.weatherKey)"
                
                if (UIImage(named: imageName) != nil) {
                    self.imageName = imageName
                } else {
                    // Workaround for unexpected types
                    self.imageName = "\(imagePrefix)_Clouds"
                }
                
                self.state = .loaded
            } else {
                self.state = .error
            }
        }
    }
    
    func onUserLocationError() {
        self.state = .error
    }
}
