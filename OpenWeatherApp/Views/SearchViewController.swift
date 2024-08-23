//
//  SearchViewController.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//
import UIKit
import SwiftUI

class SearchViewController: UIViewController {

    private let viewModel: SearchViewModel
    
    // UI Elements
    private let cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter city name"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let previousSearchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Last Search", for: .normal)
        button.addTarget(self, action: #selector(previousSearchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.onWeatherDataFetched = { [weak self] weatherResponse, cityName in
            DispatchQueue.main.async {
                self?.showWeatherView(for: weatherResponse, cityName: cityName)
            }
        }
        
        self.viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
            }
        }
        
        self.viewModel.onLastSearchUpdated = { [weak self] isAvailable in
            DispatchQueue.main.async {
                self?.previousSearchButton.isEnabled = isAvailable
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Weather Search"
        
        setupLayout()
        
        if viewModel.isLastSearchAvailable() {
            previousSearchButton.isEnabled = true
        } else {
            previousSearchButton.isEnabled = false
        }
        
        viewModel.requestLocationPermission()
    }
    
    private func setupLayout() {
        view.addSubview(cityTextField)
        view.addSubview(searchButton)
        view.addSubview(previousSearchButton)
        view.addSubview(activityIndicator)
        
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        previousSearchButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            cityTextField.widthAnchor.constraint(equalToConstant: 250),
            
            searchButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            previousSearchButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 20),
            previousSearchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: previousSearchButton.bottomAnchor, constant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func searchButtonTapped() {
        guard let cityName = cityTextField.text, !cityName.isEmpty else {
            showAlert(message: "Please enter a city name")
            return
        }
        
        viewModel.fetchWeather(for: cityName)
    }
    
    @objc private func previousSearchButtonTapped() {
        viewModel.fetchWeatherForLastSearchedCity()
    }
    
    private func showWeatherView(for weatherResponse: WeatherResponse, cityName: String) {
        let iconURL = URL(string: "https://openweathermap.org/img/wn/\(weatherResponse.weather.first?.icon ?? "01d")@2x.png")
        
        let weatherView = WeatherView(
            cityName: cityName,
            temperature: String(format: "%.1f", weatherResponse.main.temp - 273.15),
            weatherDescription: weatherResponse.weather.first?.description.capitalized ?? "No Description",
            weatherIconURL: iconURL
        )
        
        let hostingController = UIHostingController(rootView: weatherView)
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
