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
//    let weatherIcon: Image

    var body: some View {
        VStack {
//            weatherIcon
//                .resizable()
//                .frame(width: 100, height: 100)
            Text(cityName)
                .font(.largeTitle)
                .padding(.top)
            Text("\(temperature)°")
                .font(.title)
            Text(weatherDescription)
                .font(.subheadline)
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(
            cityName: "Seattle",
            temperature: "72",
            weatherDescription: "Sunny"
            //weatherIcon: Image(systemName: "sun.max.fill") // Use SwiftUI's Image
        )
    }
}
