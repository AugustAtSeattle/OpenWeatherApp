//
//  WeatherView.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.

import SwiftUI

struct WeatherView: View {
    let cityName: String
    let temperature: String
    let weatherDescription: String
    let weatherIconURL: URL?

    @State private var weatherIcon: UIImage? = nil

    var body: some View {
        VStack {
            if let weatherIcon = weatherIcon {
                Image(uiImage: weatherIcon)
                    .resizable()
                    .frame(width: 100, height: 100)
            } else {
                Image(systemName: "photo")  // Placeholder image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .onAppear {
                        loadWeatherIcon()
                    }
            }
            
            Text(cityName)
                .font(.largeTitle)
                .padding(.top)
            Text("\(temperature)°")
                .font(.title)
            Text(weatherDescription)
                .font(.subheadline)
        }
    }

    private func loadWeatherIcon() {
        guard let url = weatherIconURL else { return }
        URLSession.shared.downloadImage(from: url) { image in
            DispatchQueue.main.async {
                self.weatherIcon = image
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(
            cityName: "Seattle",
            temperature: "72",
            weatherDescription: "Sunny",
            weatherIconURL: URL(string: "https://openweathermap.org/img/wn/01d@2x.png") // Example URL
        )
    }
}
