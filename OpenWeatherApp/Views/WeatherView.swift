//
//  WeatherView.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

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
                // Placeholder image while loading
                Image(systemName: "photo")
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

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.weatherIcon = image
                }
            }
        }
        task.resume()
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
