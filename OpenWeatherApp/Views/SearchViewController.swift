//
//  SearchViewController.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import Foundation
import UIKit
import SwiftUI

class SearchViewController: UIViewController {
    
    
    func showWeather() {
        // Assuming you have the weather data ready
        let weatherView = WeatherView(cityName: "Seattle",
                                      temperature: "75",
                                      weatherDescription: "Sunny",
                                      weatherIconURL: URL(string: "https://openweathermap.org/img/wn/01d@2x.png"))

        let hostingController = UIHostingController(rootView: weatherView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
