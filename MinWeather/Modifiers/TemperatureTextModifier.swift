//
//  TemperatureTextModifier.swift
//  MinWeather
//
//  Created by Thiago Souza on 07/09/24.
//

import SwiftUI

struct TemperatureTextModifier: ViewModifier {
    @State private var animationsRunning = true
    
    func body(content: Content) -> some View {
        HStack(alignment: .center, spacing: 2) {
            Image(systemName: "thermometer.medium")
                .resizable()
                .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                .symbolEffect(.bounce, options: .speed(0.32).repeat(1), value: animationsRunning)
                .scaledToFit()
                .frame(width: 44, height: 44)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animationsRunning.toggle()
                    }
                }
            
            content
                .frame(height: 96)
                .font(.custom("Manrope", size: 96))
                .fontWeight(.black)
        }
    }
}

