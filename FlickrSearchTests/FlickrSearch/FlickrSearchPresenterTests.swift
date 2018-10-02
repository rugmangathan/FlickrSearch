//
//  FlickrSearchPresenterTests.swift
//  FlickrSearchTests
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

@testable import FlickrSearch

import XCTest

class FlickrSearchPresenterTests: XCTestCase {
  class FlickrSearchDisplayLogicSpy: FlickrSearchDisplayLogic {
    var displayFetchedImagesCalled: Bool = false
    var displayLogicViewModel: FlickrSearchModel.ViewModel!

    func displayFetchedImages(viewModel: FlickrSearchModel.ViewModel) {
      displayFetchedImagesCalled = true
      displayLogicViewModel = viewModel
    }
  }

  func test_presentFetchedGists_shouldAskViewControllerToDisplayImages() {
    // Given
    let presenter = FlickrSearchPresenter()
    let displayLogicSpy = FlickrSearchDisplayLogicSpy()
    presenter.viewController = displayLogicSpy

    // When
    let fetchedImages = Seeds.Flickr.flickrResponse
    let response = FlickrSearchModel.Response(
      photoContent: fetchedImages.content
    )
    presenter.present(response: response)

    // Then
    let expected = Seeds.Flickr.viewModel
    let actual = displayLogicSpy.displayLogicViewModel
    XCTAssertTrue(
      displayLogicSpy.displayFetchedImagesCalled,
      "present(response:) should ask view controller to present images"
    )
    XCTAssertEqual(
      expected,
      actual,
      "present(response:) should display valid images"
    )
  }
}
