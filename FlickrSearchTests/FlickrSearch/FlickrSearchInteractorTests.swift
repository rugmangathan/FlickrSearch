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
    }

    override func cancel() {

    }
  }

  func test_shouldAskWorkerToFetchGists_whenSearchIsCalled() {
    // Given
    let interactor = FlickrSearchInteractor()
    let workerSpy = FlickrSearchWorkerSpy()
    interactor.worker = workerSpy
    let searchTerm = "Dog"
    let page = 1

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
}
