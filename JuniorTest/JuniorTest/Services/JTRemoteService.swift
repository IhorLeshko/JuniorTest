//
//  JTRemoteService.swift
//  JuniorTest
//
//  Created by Ihor on 16.11.2023.
//

import Foundation
import Combine

class JTRemoteService {
    
    enum HTTPMoviePath: String {
        case popularPath = "3/movie/popular?language=en-US&page=1"
        case topRatedPath = "3/movie/top_rated?language=en-US&page=1"
        case searchByCategoryPath = "3/discover/movie?include_adult=true&include_video=false&language=en-US&page=1&sort_by=popularity.desc"
        case movieGenresPath = "3/genre/movie/list?language=en"
        case searchMoviesPath = "3/search/movie?query=fast&language=en-US&page=1"
    }
    
    
    func fetchMovies(withPath apiMoviePath: HTTPMoviePath, withGanres ganres: String? = "") -> AnyPublisher<JTMovie, Error> {
        
        let url = URL(string: "\(JTConstraints.http)" + "\(apiMoviePath.rawValue)" + "\(ganres ?? "")")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(JTConstraints.apiKey, forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
        
                return data
            }
            .decode(type: JTMovie.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchGenres() -> AnyPublisher<JTMovieGenres, Error> {
        let url = URL(string: "\(JTConstraints.http)" + "\(HTTPMoviePath.movieGenresPath.rawValue)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(JTConstraints.apiKey, forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: JTMovieGenres.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func addMovieToWatchList(movieID: Int) -> AnyPublisher<Void, Error> {
        let url = URL(string: "https://api.themoviedb.org/3/account/20707019/watchlist")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue(JTConstraints.apiKey, forHTTPHeaderField: "Authorization")
        
        let parameters = [
          "media_type": "movie",
          "media_id": movieID,
          "watchlist": true
        ] as [String : Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMoviesFromMyWatchlist() -> AnyPublisher<JTMovie, Error> {
        
        let url = URL(string: "https://api.themoviedb.org/3/account/20707019/watchlist/movies")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(JTConstraints.apiKey, forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
        
                return data
            }
            .decode(type: JTMovie.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func searchMovies(withKeyLetters letters: String) -> AnyPublisher<JTMovie, Error> {
        
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(letters)&language=en-US&page=1")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(JTConstraints.apiKey, forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: JTMovie.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
