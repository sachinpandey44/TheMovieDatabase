//
//  MovieListViewController.swift
//  TMDB
//
//  Created by Sachindra on 07/02/20.
//MIT License

//Copyright (c) 2020 Sachindra Pandey

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import Foundation
import UIKit
import CoreGraphics

class MovieListViewController: BaseCollectionViewController {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    private let movieListCellIdentifier = "MovieListViewCell"
    private var dataManager: MovieListDataManager!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = MovieListDataManager(delegate: self)
        dataManager.fetchData()
        // Do any additional setup after loading the view.
    }
    
     //MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsController = segue.destination as? MovieDetailsViewController,
            let selectedIndex = self.collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        detailsController.dataManager = MovieDetailsDataManager(movie: dataManager.nowPlayingMovies[selectedIndex.row], delegate: detailsController)
    }
    
    func showAlertWithMessage(message: String = "Something went wrong.") {
        let alert = UIAlertController(title: "TMDB", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDatasource
extension MovieListViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.nowPlayingMovies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieListCellIdentifier, for: indexPath) as! MovieListViewCell
        cell.accessibilityIdentifier = "\(dataManager.nowPlayingMovies[indexPath.row].id)"
        cell.layoutIfNeeded()
        if let backdropImageURL = dataManager.nowPlayingMovies[indexPath.row].movieBackdropImageURL(.medium) {
            let movieImageSize = cell.imageView.bounds.size
            let scale = collectionView.traitCollection.displayScale
            cell.imageView.image = self.downloadImage(atURL: backdropImageURL, forSize: movieImageSize, scale: scale)
        }
        return cell
    }
    
}

extension MovieListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let backdropImageURL = dataManager.nowPlayingMovies[indexPath.row].movieBackdropImageURL(.medium) {
                let scale = collectionView.traitCollection.displayScale
                _  = self.downloadImage(atURL: backdropImageURL, forSize: collectionViewItemSize, scale: scale)
            }
        }
    }
}

//MARK: - UICollectionViewDelegate
extension MovieListViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(MovieListHeaderView.self)", for: indexPath) as? MovieListHeaderView else {
                fatalError("Invalid view type")
            }
            headerView.label.text = "Now Playing"
            return headerView
        }
        assert(false, "Invalid header element type")
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == dataManager.nowPlayingMovies.count - 1 ) { //it's your last cell
           //Load more data & reload your collection view
            dataManager.fetchData()
         }
    }
}

extension MovieListViewController: MovieListDataManagerProtocol {
    func showErrorOnUI(error: Error?) {
        activityIndicator.stopAnimating()
        showAlertWithMessage(message: error?.localizedDescription ?? "Unable to fetch list of movies")
    }
    
    func reloadUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}
