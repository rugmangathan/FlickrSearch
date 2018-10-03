//
//  FlickrSearchViewController.swift
//  FlickrSearch
//
//  Created by sherlock on 02/10/18.
//  Copyright (c) 2018 rugmangathan. All rights reserved.
//

import UIKit

class FlickrSearchViewController: UIViewController{
  var interactor: FlickrSearchBusinessLogic?
  var router: (NSObjectProtocol & FlickrSearchRoutingLogic & FlickrSearchDataPassing)?

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  private lazy  var collectionViewItems: [URL] = {
    return []
  }()

  private lazy var imageLoader: ImageLoader = {
    return ImageLoader()
  }()

  private lazy var page: Int = {
    return 1
  }()

  private lazy var searchTerm: String = {
    return ""
  }()

  fileprivate let sectionInsets = UIEdgeInsets(
    top: 10.0,
    left: 5.0,
    bottom: 5.0,
    right: 5.0
  )

  // MARK: Object lifecycle
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  // MARK: Setup
  private func setup() {
    let viewController = self
    let interactor = FlickrSearchInteractor()
    let presenter = FlickrSearchPresenter()
    let router = FlickrSearchRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }

  // MARK: Routing
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }

  fileprivate func resetForNewSearch() {
    interactor?.cancel()
    interactor?.resetForNewSearch()
    collectionView.reloadData()
  }

  fileprivate func performSearch() {
    let request = FlickrSearchModel.Request(searchTerm: searchTerm, page: page)
    interactor?.fetch(request)
  }

  fileprivate func showProgress(_ show: Bool) {
    DispatchQueue.main.async {
      show ? self.activityIndicator.startAnimating()
        : self.activityIndicator.stopAnimating()
      self.searchBar.isUserInteractionEnabled = !show
      self.collectionView.isUserInteractionEnabled = !show
    }
  }
}

extension FlickrSearchViewController: FlickrSearchDisplayLogic {
  func setPage(_ pageCount: Int) {
    page = pageCount
  }

  func setImageUrl(_ urls: [URL]) {
    collectionViewItems = urls
    collectionView.reloadData()
  }

  func setSearchTerm(_ term: String) {
    searchTerm = term
  }

  func showError(_ message: String) {
    let alertView = UIAlertController(
      title: "Error",
      message: message,
      preferredStyle: .alert
    )
    alertView.addAction(
      UIAlertAction(title: "Ok", style: .default)
    )

    present(alertView, animated: true)
  }

  func displayFetchedImages(viewModel: FlickrSearchModel.ViewModel) {
    if viewModel.displayInfo.urls.isEmpty {
      showProgress(false)
      showError("Oops! Try some other keyword.")
    } else {
      page = viewModel.displayInfo.page + 1

      collectionViewItems.append(contentsOf: viewModel.displayInfo.urls)
      if page > 1 {
        let startIndex = collectionViewItems.count - viewModel.displayInfo.urls.count
        let endIndex = startIndex + viewModel.displayInfo.urls.count
        let indexPaths =  (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        DispatchQueue.main.async { [weak self] in
          guard let strongSelf = self else {
            fatalError("'self' is nil")
          }
          strongSelf.showProgress(false)
          strongSelf.collectionView.reloadData()
          let indexPathsToReload = strongSelf.visibleIndexPathsToReload(intersecting: indexPaths)
          strongSelf.collectionView.reloadItems(at: indexPathsToReload)
        }
      } else {
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
    }
  }
}

extension FlickrSearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()

    resetForNewSearch()
    guard let text = searchBar.text, !text.isEmpty else {
      showError("Type some keywords to search")
      return
    }
    searchTerm = text
    showProgress(true)
    performSearch()
  }
}

extension FlickrSearchViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionViewItems.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView
      .dequeueReusableCell(withReuseIdentifier: "FlickrSearchCell", for: indexPath) as? FlickrSearchCell else {
        fatalError("'FlickrSearchCell' shold not be nil.")
    }

    if isLoadingCell(for: indexPath) {
      cell.imageView.image = UIImage()
    } else {
      imageLoader.loadImage(url: collectionViewItems[indexPath.item], completion: { (image) in
        cell.imageView.image = image
      })
    }

    return cell
  }
}

extension FlickrSearchViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.item == collectionViewItems.count - 4 {
      performSearch()
    }
  }
}

extension FlickrSearchViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace =  sectionInsets.left * 3
    let availableWidth = collectionView.frame.width - paddingSpace
    let rowWidth = availableWidth / 2

    return CGSize(width: rowWidth, height: rowWidth)
  }
}

private extension FlickrSearchViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.item >= collectionViewItems.count
  }

  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
