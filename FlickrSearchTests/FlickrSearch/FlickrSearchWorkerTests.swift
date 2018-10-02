//
//  FlickrSearchWorkerTests.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright (c) 2018 rugmangathan. All rights reserved.
//

@testable import FlickrSearch
import XCTest

class FlickrSearchWorkerTests: XCTestCase {

  class FlickrApiSpy: ApiProtocol {
    let response: FlickrResponse = Seeds.Flickr.flickrResponse
    var fetchSuccess: Bool = false
    var cancelMethodExecuted: Bool = false
    func search(with text: String, page: Int, completionHandler: @escaping NetwrokCompletion) {
      fetchSuccess = true
      completionHandler(response, nil)
    }
    
    func cancel() {
      cancelMethodExecuted = true
    }
  }

  func test_searchShouldAskFlickerApiToFetchImages() {
    // Given
    let flickrApi = FlickrApiSpy()
    let searchTerm: String = "Dog"
    let page = 1

    // When
    flickrApi.search(with: searchTerm, page: page) { (_, _) in }
    
    // Then
    XCTAssertTrue(
      flickrApi.fetchSuccess,
      "search(with:page:completionHandler:) should ask FlickrApi to fetch images"
    )
  }

  func test_searchShouldReturnImages_whenFlickrApiReturnFetchedImages() {
    // Given
    let flickrApi = FlickrApiSpy()
    let searchTerm: String = "Dog"
    let page = 1

    // When
    var actualResponse: FlickrResponse?
    flickrApi.search(with: searchTerm, page: page) { (response, _) in
      actualResponse = response
    }

    // Then
    let expectedResponse = Seeds.Flickr.flickrResponse
    XCTAssertEqual(
      expectedResponse,
      actualResponse,
      "search(with:page:completionHandler:) should return fetched images if flickerApi succeeds"
    )
  }
}
