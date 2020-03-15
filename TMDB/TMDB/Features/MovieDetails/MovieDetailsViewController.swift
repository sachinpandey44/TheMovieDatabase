//
//  MovieDetailsViewController.swift
//  TMDB
//
//  Created by Sachindra on 08/02/20.
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

import UIKit

private let reuseIdentifier = "MovieDetailsViewCell"

class MovieDetailsViewController: BaseCollectionViewController {
    var dataManager: MovieDetailsDataManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateCollectionViewBackground(image: nil)
        dataManager.fetchData()

    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataManager.similarMovies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieDetailsViewCell

        // Configure the cell
        let movie = dataManager.similarMovies[indexPath.row]
        cell.accessibilityIdentifier = "\(movie.id)"
        cell.layoutIfNeeded()
        if let backdropImageURL = movie.movieBackdropImageURL(.medium) {
            let movieImageSize = cell.movieBackdropImageView.bounds.size
            let scale = collectionView.traitCollection.displayScale
            cell.movieBackdropImageView.image = self.downloadImage(atURL: backdropImageURL, forSize: movieImageSize, scale: scale)
        }

    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(MovieDetailsHeaderView.self)", for: indexPath) as? MovieDetailsHeaderView else {
                fatalError("Invalid view type")
            }
            headerView.title.text = dataManager.currentMovie.title
            headerView.releaseDate.text = dataManager.currentMovie.releaseDate
            headerView.movieDescription.text = dataManager.currentMovie.overview
            headerView.movieDescription.sizeToFit()
            if let backdropImageURL = dataManager.currentMovie.moviePosterImageURL(.medium) {
                let movieImageSize = headerView.posterImage.bounds.size
                let scale = collectionView.traitCollection.displayScale
                headerView.posterImage.image = self.downloadImage(atURL: backdropImageURL, forSize: movieImageSize, scale: scale)
            }
            return headerView
        }
        assert(false, "Invalid header element type")
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataManager.updateCurrentMovie(movie: dataManager.similarMovies[indexPath.row])
    }

}

extension MovieDetailsViewController: MovieDetailsDataManagerProtocol {
    func showErrorOnUI(error: Error?) {
        //
    }
    
    func reloadMovieInformation() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func updateCollectionViewBackground(image: UIImage?) {
        let backgroundView = UIView(frame: self.collectionView.bounds)
        let backgroundImageView = UIImageView(frame: self.collectionView.bounds)
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.image = image ?? UIImage(named: "DolittlePoster")
        backgroundView.addSubview(backgroundImageView)
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundView.bounds
        backgroundView.addSubview(blurEffectView)
        
        DispatchQueue.main.async {
            self.collectionView.backgroundView = backgroundView
        }
    }
}
