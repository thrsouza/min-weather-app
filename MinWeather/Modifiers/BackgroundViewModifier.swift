//
//  BackgroundViewModifier.swift
//  MinWeather
//
//  Created by Thiago Souza on 08/09/24.
//

import SwiftUI

struct BackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            Color.white.ignoresSafeArea()
            
            Circle()
                .fill(.purple.opacity(1))
                .frame(width: 320, height: 320)
                .blur(radius: 128)
                .offset(x: -128, y: 144)
            
            Rectangle()
                .fill(.blue.opacity(1))
                .frame(width: 320, height: 320)
                .blur(radius: 128)
                .offset(x: 144, y: -128)
            
            content
                .padding()
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}
