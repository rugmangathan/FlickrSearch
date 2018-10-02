//
//  FlickrSearchPresenter.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright (c) 2018 rugmangathan. All rights reserved.
//

protocol FlickrSearchPresentationLogic {
  func present(response: FlickrSearchModel.Response)
}

protocol FlickrSearchDisplayLogic: class {
  func displayFetchedImages(viewModel: FlickrSearchModel.ViewModel)
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
}
