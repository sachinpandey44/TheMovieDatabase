//
//  TMDBMovie.swift
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

protocol TMDBMovieProtocol: Equatable {
    var id: Int { get set }
    var title: String { get set }
    var releaseDate: String { get set }
    var overview: String { get set }
    var posterPath: String { get set }
    var backdropPath: String { get set }
}

extension TMDBMovieProtocol {
    func moviePosterImageURL(_ size: TMDBConstants.ImageSize) -> URL? {
        if let url = URL(string: "\(TMDBConstants.baseURLImage)/\(size.rawValue)\(posterPath)") {
            return url
        }
        return nil
    }
    
    func movieBackdropImageURL(_ size: TMDBConstants.ImageSize) -> URL? {
        if let url = URL(string: "\(TMDBConstants.baseURLImage)/\(size.rawValue)\(backdropPath)") {
            return url
        }
        return nil
    }
}

class TMDBMovie: TMDBMovieProtocol {
    var id: Int
    var title: String
    var releaseDate: String
    var overview: String
    var posterPath: String
    var backdropPath: String
    
    init(id: Int, title: String, releaseDate: String, overview: String, posterPath: String, backdropPath: String) {
        self.id = id
            self.title = title
            self.releaseDate = releaseDate
            self.overview = overview
            self.posterPath = posterPath
            self.backdropPath = backdropPath
    }
    
    init?(dictionary: [String : AnyObject]) {
        guard let id = dictionary["id"] as? Int,
            let title = dictionary["title"] as? String,
            let releaseDate = dictionary["release_date"] as? String,
            let overview = dictionary["overview"] as? String,
            let posterPath = dictionary["poster_path"] as? String,
            let backdropPath = dictionary["backdrop_path"] as? String else {
            return nil
        }
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

    static func == (lhs: TMDBMovie, rhs: TMDBMovie) -> Bool {
        return lhs.id == rhs.id
    }
    
}
