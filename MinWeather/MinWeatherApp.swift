//
//  MinWeatherApp.swift
//  MinWeather
//
//  Created by Thiago Souza on 07/09/24.
//

import SwiftUI
import SwiftData

@main
struct MinWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            let factory = ViewModelFactory()
            HomeView(viewModel: factory.makeHomeViewModel())
        }
    }
}
