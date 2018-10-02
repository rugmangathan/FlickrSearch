//
//  FlickrSearchInteractorTests.swift
//  FlickrSearchTests
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

@testable import FlickrSearch
import XCTest

class FlickrSearchInteractorTests: XCTestCase {

  class FlickrSearchWorkerSpy: FlickrSearchWorker {
    let response: FlickrResponse = Seeds.Flickr.flickrResponse
    var fetchSuccess: Bool = false
    var cancelMethodExecuted: Bool = false

    override func search(with text: String, page: Int, coimpletionHandler: @escaping NetwrokCompletion) {
      fetchSuccess = true
      coimpletionHandler(response, nil)
    }

    override func cancel() {
      cancelMethodExecuted = true
    }
  }

  class FlickrSearchWorkerFailSpy: FlickrSearchWorker {
    var fetchSuccess: Bool = false

    override func search(with text: String, page: Int, coimpletionHandler: @escaping NetwrokCompletion) {
      fetchSuccess = true
      coimpletionHandler(nil, ApiError.dataNotFound)
    }

    override func cancel() { }
  }

  class FlickrSearchPresentationLogicSpy: FlickrSearchPresentationLogic {
    var presenterCalled: Bool = false
    var resetForNewSearchCalled: Bool = false
    var showErrorCalled: Bool = false

    func present(response: FlickrSearchModel.Response) {
      presenterCalled = true
    }

    func resetForNewSearch(viewModel: FlickrSearchModel.ViewModel) {
      resetForNewSearchCalled  = true
    }

    func showError(_ message: String) {
      showErrorCalled = true
    }
  }

  var interactor: FlickrSearchInteractor!
  var workerSpy: FlickrSearchWorkerSpy!
  private let searchTerm = "Dog"
  private let page = 1

  override func setUp() {
    super.setUp()
    interactor = FlickrSearchInteractor()
    workerSpy = FlickrSearchWorkerSpy()
    interactor.worker = workerSpy
  }

  func test_shouldAskWorkerToFetchGists_whenSearchIsCalled() {
    // When
    let request = FlickrSearchModel.Request(
      searchTerm: searchTerm,
      page: page
    )
    interactor.fetch(request)

    // Then
    XCTAssertTrue(
      workerSpy.fetchSuccess,
      "search(text: page: completionHandler:) should ask worker to fetch images"
    )
  }

  func test_shouldDisplayFetchedImages_whenWorkerReturnsSuccess() {
    // Given
    let presenter = FlickrSearchPresentationLogicSpy()
    interactor.presenter = presenter

    // When
    let request = FlickrSearchModel.Request(
      searchTerm: searchTerm,
      page: page
    )
    interactor.fetch(request)

    // Then
    XCTAssertTrue(
      presenter.presenterCalled,
      "search(text: page: completionHandler:) should ask worker to fetch images"
    )
  }

  func test_shouldAskWorkerToCancelTask_whenNewSearchIsCalled() {
    // When
    interactor.cancel()

    // Then
    XCTAssertTrue(
      workerSpy.cancelMethodExecuted,
      "cancel() should ask worker to cancel task"
    )
  }

  func test_shouldResetPageCountAndSearchTerm_whenWorkerPerformsResetForNewSearch() {
    // Given
    let presenter = FlickrSearchPresentationLogicSpy()
    interactor.presenter = presenter

    // When

    interactor.resetForNewSearch()

    // Then
    XCTAssertTrue(
      presenter.resetForNewSearchCalled,
      "resetForNewSearchCalled(viewModel:) should be called"
    )
  }

  func test_shouldPresentError_whenWorkerFails() {
    // Given
    let workerSpy = FlickrSearchWorkerFailSpy()
    interactor.worker = workerSpy
    let presenter = FlickrSearchPresentationLogicSpy()
    interactor.presenter = presenter

    // When
    let request = FlickrSearchModel.Request(
      searchTerm: "",
      page: 0
    )
    interactor.fetch(request)

    // Then
    XCTAssertTrue(
      presenter.showErrorCalled,
      "resetForNewSearchCalled(viewModel:) should be called"
    )
  }
}
