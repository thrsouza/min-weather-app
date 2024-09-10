//
//  HomeView.swift
//  MinWeather
//
//  Created by Thiago Souza on 07/09/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @StateObject var viewModel: HomeViewModel
    @State var isViewLoaded: Bool = false
    
    init(viewModel: HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            switch self.viewModel.state {
            case .loading: self.loadingViewBuilder()
            case .loaded: self.loadedViewBuilder()
            case .error: self.errorViewBuilder()
            }
        }
        .onAppear {
            self.viewModel.fetchData()
        }
        .onChange(of: self.viewModel.state, { _, newValue in
            if newValue == .loaded {
                withAnimation {
                    self.isViewLoaded = true
                }
            }
        })
        .modifier(BackgroundViewModifier())
    }
    
    @ViewBuilder
    func loadingViewBuilder() -> some View {
        var bounceValue = 0
        VStack(alignment: .center) {
            Image(systemName: "cloud.fill")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .symbolEffect(.pulse, options: .speed(1.6))
                .frame(width: 96, height: 96)
            
            Text("LOADING...")
                .font(.custom("Manrope", size: 12))
                .fontWeight(.black)
            
        }
        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .onAppear {
            bounceValue += 1
        }
    }
    
    @ViewBuilder
    func loadedViewBuilder() -> some View {
        loadedHeaderBuilder()
        Spacer()
        loadedContentBuilder()
        Spacer()
        loadedFooterBuilder()
    }
    
    @ViewBuilder
    func errorViewBuilder() -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text("I'M SORRY.")
                .font(.custom("Manrope", size: 24))
                .fontWeight(.black)
            
            Text("SOMETHING WENT WRONG!")
                .font(.custom("Manrope", size: 16))
                .fontWeight(.medium)
            
            Text("TRY AGAIN LATER.")
                .font(.custom("Manrope", size: 16))
                .fontWeight(.black)
        }
        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
    
    @ViewBuilder
    func loadedHeaderBuilder() -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(viewModel.dateDescription)
                    .font(.custom("Manrope", size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                
                Text(viewModel.cityName)
                    .font(.custom("Manrope", size: 20))
                    .fontWeight(.heavy)
            }
            Spacer()
            Image(systemName: "location.fill")
                .renderingMode(.template)
                .symbolEffect(.pulse.byLayer, options: .repeat(2))
        }
        .padding()
        .opacity(self.isViewLoaded ? 1 : 0)
        .offset(y: self.isViewLoaded ? 0 : -8)
        .animation(.easeIn(duration: 0.3), value: self.isViewLoaded)
        
    }
    
    @ViewBuilder
    func loadedContentBuilder() -> some View {
        VStack(alignment: .center, spacing: 16) {
            Image(self.viewModel.imageName)
                .resizable()
                .frame(width: 228, height: 228)
                .modifier(ShadowBlurImageModifier())
            
            Text("\(self.viewModel.temperature)°")
                .modifier(TemperatureTextModifier())
            
            Text(self.viewModel.weatherDescription)
                .font(.custom("Manrope", size: 24))
                .fontWeight(.heavy)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
        .opacity(self.isViewLoaded ? 1 : 0)
        .scaleEffect(self.isViewLoaded ? 1 : 0.96)
        .animation(.easeIn(duration: 0.3), value: self.isViewLoaded)
    }
    
    @ViewBuilder
    func loadedFooterBuilder() -> some View {
        HStack {
            loadedFooterCardBuilder(icon: "drop.fill", value: "\(self.viewModel.humidity)%")
            loadedFooterDividerBuilder()
            loadedFooterCardBuilder(icon: "wind", value: "\(self.viewModel.windSpeed) km/h")
            loadedFooterDividerBuilder()
            loadedFooterCardBuilder(icon: "eye.fill", value: "\(self.viewModel.visibility) km")
        }
        .padding()
        .background(.white.opacity(0.44))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
        .opacity(self.isViewLoaded ? 1 : 0)
        .offset(y: self.isViewLoaded ? 0 : 8)
        .animation(.easeIn(duration: 0.3), value: self.isViewLoaded)
    }
    
    @ViewBuilder
    func loadedFooterCardBuilder(icon: String, value: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
            Text(value)
                .font(.custom("Manrope", size: 14))
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        
    }
    
    @ViewBuilder
    func loadedFooterDividerBuilder() -> some View {
        Rectangle()
            .fill(.gray.opacity(0.08))
            .frame(width: 2, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 2))
            .padding(.vertical)
    }
}

#Preview {
    HomeView(viewModel: ViewModelFactory().makeHomeViewModel())
}

