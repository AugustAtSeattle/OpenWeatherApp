//
//  SearchViewControllerTests.swift
//  OpenWeatherAppTests
//
//  Created by Sailor on 8/23/24.
//

import XCTest
@testable import OpenWeatherApp

class SearchViewControllerTests: XCTestCase {

    var viewController: SearchViewController!
    var mockViewModel: MockSearchViewModel!

    override func setUp() {
        super.setUp()
        mockViewModel = MockSearchViewModel()
        viewController = SearchViewController(viewModel: mockViewModel)
        _ = viewController.view  // Load the view hierarchy
    }

    func testSearchButtonTapped() {
        viewController.cityTextField.text = "Seattle"
        viewController.searchButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(mockViewModel.fetchWeatherCityName, "Seattle")
    }

    func testLastSearchButtonDisabledWhenNoLastSearch() {
        mockViewModel.isLastSearchAvailableReturnValue = false
        viewController.viewDidLoad()  // Re-load view hierarchy
        
        XCTAssertFalse(viewController.previousSearchButton.isEnabled)
    }

    func testLastSearchButtonEnabledWhenLastSearchExists() {
        mockViewModel.isLastSearchAvailableReturnValue = true
        viewController.viewDidLoad()  // Re-load view hierarchy
        
        XCTAssertTrue(viewController.previousSearchButton.isEnabled)
    }
}
