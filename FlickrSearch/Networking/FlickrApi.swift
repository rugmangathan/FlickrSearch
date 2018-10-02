//
//  FlickrApi.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

import Foundation

class FlickrApi: ApiProtocol {
  private lazy var session: URLSession = {
    return URLSession(configuration: URLSessionConfiguration.default)
  }()
  private var task: URLSessionTask?

  func search(with text: String, page: Int, completionHandler: @escaping NetwrokCompletion) {
    guard let url = flickrSearchURLForSearchTerm(text, page) else {
      completionHandler(nil, ApiError.urlIsNil)
      return
    }

    task = session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completionHandler(nil, error)
      } else {
        guard let validData = data else {
          completionHandler(nil, ApiError.dataNotFound)
          return
        }
        do {
          let responseObject = try JSONDecoder()
            .decode(FlickrResponse.self, from: validData)
          completionHandler(responseObject, nil)
        } catch {
          completionHandler(nil, ApiError.decodingError)
        }
      }
    }
    task?.resume()
  }

  func cancel() {
    task?.cancel()
  }

  private func flickrSearchURLForSearchTerm(
    _ searchTerm: String,
    _ pageCount: Int
    ) -> URL? {

    guard let escapedTerm = searchTerm.addingPercentEncoding(
      withAllowedCharacters: .alphanumerics
      ) else {
        fatalError("'FlickrApi' searchTerm encoding failed.")
    }

    let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=a2a13f89fd07516492577e906ff41a6f&format=json&nojsoncallback=1&safe_search=1&page=\(pageCount.description)&text=\(escapedTerm)"

    guard let url = URL(string: urlString) else {
      return nil
    }

    return url
  }
}
