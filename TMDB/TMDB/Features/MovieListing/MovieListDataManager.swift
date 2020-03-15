//
//  MovieListDataManager.swift
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
import Foundation

protocol MovieListDataManagerProtocol {
    func showErrorOnUI(error: Error?)
    func reloadUI()
}

class MovieListDataManager {
    private var page = 1
    private var service = TMDBService()
    private var delegate: MovieListDataManagerProtocol!
    var nowPlayingMovies: [TMDBMovie] = [] {
        didSet {
            delegate.reloadUI()
        }
    }
    
    required init(delegate: MovieListDataManagerProtocol) {
        self.delegate = delegate
    }
        
    func fetchData() {
        service.getNowPlayingMovies(page: page) {[weak self] (movies, error) in
            guard let movies = movies else {
                self?.delegate.showErrorOnUI(error: error)
                return
            }
            self?.page += 1
            self?.nowPlayingMovies.append(contentsOf: movies)
        }
    }
}

