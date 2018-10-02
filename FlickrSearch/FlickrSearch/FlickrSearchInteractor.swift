//
//  FlickrSearchInteractor.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright © 2018 rugmangathan. All rights reserved.
//

import Foundation

protocol FlickrSearchBusinessLogic: class {
  func fetch(_ resquest: FlickrSearchModel.Request)
  func cancel()
  func resetForNewSearch()
}

protocol FlickrSearchDataStore {}

class FlickrSearchInteractor: FlickrSearchBusinessLogic, FlickrSearchDataStore {
  var presenter: FlickrSearchPresentationLogic?
  lazy var worker: FlickrSearchWorker = FlickrSearchWorker()

  func fetch(_ resquest: FlickrSearchModel.Request) {
    worker.search(with: resquest.searchTerm, page: resquest.page) { (response, error) in
      if let error = error as? ApiError {
        self.presenter?.showError(error.rawValue)
      }

      if let response = response {
        self.presenter?.present(
          response: FlickrSearchModel.Response(photoContent: response.content)
        )
      }
    }
  }

  func cancel() {
    worker.cancel()
  }

  func resetForNewSearch() {
    let viewModel = FlickrSearchModel.ViewModel(
      displayInfo: FlickrSearchModel.ViewModel.DisplayInfo(page: 0, urls: [])
    )
    presenter?.resetForNewSearch(viewModel: viewModel)
  }
}
