//
//  TMDBServiceTest.swift
//  TMDBTests
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

import XCTest
@testable import TMDB

class TMDBServiceTest: XCTestCase {

    var tmdbService: TMDBService!
    var expectations = [XCTestExpectation]()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        tmdbService = TMDBService()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetNowPlayingMovies() {
        print(#function)
        // This is an example of a functional test case.
        self.expectations.append(expectation(description:"testGetNowPlayingMovies()"))
        tmdbService.getNowPlayingMovies { (movies, error) in
            if error != nil {
                XCTFail("Fail")
            }
            guard let movies = movies else {
                XCTFail("Fail")
                return
            }
            print(movies)
            for movie in movies {
                print(movie.id)
            }
            XCTestExpectation.fulfill(with: #function, from: self.expectations)
        }
        wait(for: self.expectations, timeout: XCTestExpectation.expectationTimeout)

    }

    func testGetSimilarMoviesSuccess() {
        print(#function)
        // This is an example of a functional test case.
        self.expectations.append(expectation(description:"testGetSimilarMoviesSuccess()"))
        tmdbService.getSimilarMovies(movieId: 495764, completion: { (movies, error) in
            print(movies)
            if error != nil {
                XCTFail("Fail")
            }
            guard let movies = movies else {
                XCTFail("Fail")
                return
            }
            print(movies)
            XCTestExpectation.fulfill(with: #function, from: self.expectations)

        })
        wait(for: self.expectations, timeout: XCTestExpectation.expectationTimeout)
    }
    
    func testGetSimilarMoviesFailure() {
        print(#function)
        // This is an example of a functional test case.
        self.expectations.append(expectation(description:"testGetSimilarMoviesFailure()"))
        tmdbService.getSimilarMovies(movieId: 0000000000, completion: { (movies, error) in
            if let _ = movies {
                XCTFail("Fail")
            }
            if error == nil {
                XCTFail("Fail")
                return
            }
            XCTestExpectation.fulfill(with: #function, from: self.expectations)

        })
        wait(for: self.expectations, timeout: XCTestExpectation.expectationTimeout)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
