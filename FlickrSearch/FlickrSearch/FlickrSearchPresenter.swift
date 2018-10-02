//
//  FlickrSearchPresenter.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright (c) 2018 rugmangathan. All rights reserved.
//

import Foundation

protocol FlickrSearchPresentationLogic {
  func present(response: FlickrSearchModel.Response)
  func resetForNewSearch(viewModel: FlickrSearchModel.ViewModel)
  func showError(_ message: String)
}

protocol FlickrSearchDisplayLogic: class {
  func displayFetchedImages(viewModel: FlickrSearchModel.ViewModel)
  func setPage(_ pageCount: Int)
  func setImageUrl(_ urls: [URL])
  func setSearchTerm(_ term: String)
  func showError(_ message: String)
}

class FlickrSearchPresenter: FlickrSearchPresentationLogic {
  weak var viewController: FlickrSearchDisplayLogic?
  
  // MARK: Do something
  func present(response: FlickrSearchModel.Response) {
    let urls = response.photoContent.photos.map { $0.getImageUrl() }
    let displayInfo = FlickrSearchModel.ViewModel.DisplayInfo(
      page: response.photoContent.page,
      urls: urls
    )

    viewController?.displayFetchedImages(
      viewModel: FlickrSearchModel.ViewModel(displayInfo: displayInfo)
    )
  }

  func resetForNewSearch(viewModel: FlickrSearchModel.ViewModel) {
    viewController?.setPage(viewModel.displayInfo.page)
    viewController?.setImageUrl([])
    viewController?.setSearchTerm("")
  }

  func showError(_ message: String) {
    viewController?.showError(message)
  }
}
