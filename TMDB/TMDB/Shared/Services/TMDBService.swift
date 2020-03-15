//
//  TMDBServiceProtocol.swift
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

protocol TMDBServiceProtocol {
    func getNowPlayingMovies(page: Int, completion: @escaping(_ response: [TMDBMovie]?, _ error: Error?) -> Void)
    
    func getSimilarMovies(movieId: Int, page: Int, completion: @escaping(_ response: [TMDBMovie]?, _ error: Error?) -> Void)
}

class TMDBService: TMDBServiceProtocol {
    let apiKey = "<INSERT_YOUR_API_KEY_HERE>"

    func getNowPlayingMovies(page: Int = 1, completion: @escaping ([TMDBMovie]?, Error?) -> Void) {
        let urlString = "\(TMDBConstants.baseURL)/now_playing?api_key=\(apiKey)&language=en-US&page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(nil, TMDBServicesError.invalidURL)
            return
        }
        getMovies(url: url) { (movies, error) in
            completion(movies, error)
        }
    }
    
    func getSimilarMovies(movieId: Int, page: Int = 1, completion: @escaping ([TMDBMovie]?, Error?) -> Void) {
        let urlString = "\(TMDBConstants.baseURL)/\(movieId)/similar?api_key=\(apiKey)&language=en-US&page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(nil, TMDBServicesError.invalidURL)
            return
        }
        getMovies(url: url) { (movies, error) in
            completion(movies, error)
        }
    }
    
    fileprivate func getMovies(url: URL, completion: @escaping ([TMDBMovie]?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let _ = response as? HTTPURLResponse, let data = data else {
                completion(nil, TMDBServicesError.invalidAPIResponse)
                return
            }
            
            do {
                guard let resultsDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
                    let movies = resultsDictionary["results"] as? [[String: AnyObject]] else {
                    completion(nil, TMDBServicesError.invalidAPIResponse)
                    return
                }
                let movieObjects: [TMDBMovie] = movies.compactMap { movie in
                    if let movie = TMDBMovie(dictionary: movie) {
                        return movie
                    }
                    return nil
                }
                completion(movieObjects, nil)
                
            } catch {
                completion(nil, error)
                return
            }
        }.resume()
    }
}
