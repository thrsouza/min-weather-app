//
//  ShadowBlurImageModifier.swift
//  MinWeather
//
//  Created by Thiago Souza on 07/09/24.
//

import SwiftUI

struct ShadowBlurImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
                .opacity(1)
                .blur(radius: 64)
                .offset(CGSize(width: 16, height: 16))
            
            content
        }
    }
}
