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
    
    private let localWeatherButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Display Local Weather", for: .normal)
        button.addTarget(self, action: #selector(localWeatherButtonTapped), for: .touchUpInside)
        button.isEnabled = false // Initially disabled
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
        
        // Enable the "Display Local Weather" button if location permission is granted
        self.viewModel.onLocationPermissionGranted = { [weak self] in
            DispatchQueue.main.async {
                self?.localWeatherButton.isEnabled = true
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
        
        // Request location permission when the view loads
        viewModel.requestLocationPermission()
    }
    
    private func setupLayout() {
        view.addSubview(cityTextField)
        view.addSubview(searchButton)
        view.addSubview(previousSearchButton)
        view.addSubview(localWeatherButton)
        view.addSubview(activityIndicator)
        
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        previousSearchButton.translatesAutoresizingMaskIntoConstraints = false
        localWeatherButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            cityTextField.widthAnchor.constraint(equalToConstant: 250),
            
            searchButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            previousSearchButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 20),
            previousSearchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            localWeatherButton.topAnchor.constraint(equalTo: previousSearchButton.bottomAnchor, constant: 20),
            localWeatherButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: localWeatherButton.bottomAnchor, constant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            // Portrait mode on most iPhones
            cityTextField.textAlignment = .center
        } else if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .compact {
            // Landscape mode on smaller devices like iPhones
            cityTextField.textAlignment = .left
        } else if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            // iPad or large screen in any orientation
            cityTextField.textAlignment = .left
        }
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
    
    @objc private func localWeatherButtonTapped() {
        viewModel.fetchLocalWeather()
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
