//
//  AvatarImageModifier.swift
//  MinWeather
//
//  Created by Thiago Souza on 08/09/24.
//

import SwiftUI

struct AvatarImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .background(.gray.opacity(0.32))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
