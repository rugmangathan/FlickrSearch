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
    var setPageCalled: Bool = false
    var setImageUrlCalled: Bool = false
    var setSearchTermCalled: Bool = false
    var showErrorCalled: Bool =  false
    var displayLogicViewModel: FlickrSearchModel.ViewModel!

    func displayFetchedImages(viewModel: FlickrSearchModel.ViewModel) {
      displayFetchedImagesCalled = true
      displayLogicViewModel = viewModel
    }

    func setPage(_ pageCount: Int) {
      setPageCalled = true
    }

    func setImageUrl(_ urls: [URL]) {
      setImageUrlCalled = true
    }

    func setSearchTerm(_ term: String) {
      setSearchTermCalled = true
    }

    func showError(_ message: String) {
      showErrorCalled = true
    }
  }

  var presenter: FlickrSearchPresenter!
  var displayLogicSpy: FlickrSearchDisplayLogicSpy!

  override func setUp() {
    super.setUp()

    presenter = FlickrSearchPresenter()
    displayLogicSpy = FlickrSearchDisplayLogicSpy()
    presenter.viewController = displayLogicSpy
  }

  func test_presentFetchedGists_shouldAskViewControllerToDisplayImages() {
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

  func test_shouldAskViewControllerToResetPageCountAndSearchTerm_whenResetForNewSearchIsCalled() {
    // When
    let viewModel = Seeds.Flickr.resetViewModel
    presenter.resetForNewSearch(
      viewModel: viewModel
    )

    // Then
    XCTAssertTrue(
      displayLogicSpy.setPageCalled
    )
    XCTAssertTrue(
      displayLogicSpy.setImageUrlCalled
    )
    XCTAssertTrue(
      displayLogicSpy.setSearchTermCalled
    )
  }

  func test_shouldAskViewControllerToShowErrorMessage_whenErrorIsPresented() {
    // When
    presenter.showError(ApiError.dataNotFound.rawValue)

    // Then
    XCTAssertTrue(
      displayLogicSpy.showErrorCalled
    )
  }
}
