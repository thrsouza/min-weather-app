//
//  ViewModelFactory.swift
//  MinWeather
//
//  Created by Thiago Souza on 10/09/24.
//

import Foundation

class ViewModelFactory {
    func makeHomeViewModel() -> HomeViewModel {
        let openWeatherService = OpenWeatherService()
        return HomeViewModel(openWeatherService: openWeatherService)
    }
}
