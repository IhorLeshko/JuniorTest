//
//  JTRemoteService.swift
//  JuniorTest
//
//  Created by Ihor on 16.11.2023.
//

import Foundation
import Combine

class JTRemoteService {
    
    enum HTTPMoviePath {
        case popularPath
        case topRatedPath
        case searchByCategoryPath
        case movieGenresPath
        case searchMoviesPath(query: String)
        case watchlistPath
        case watchlistMoviesPath
        
        var rawValue: String {
            switch self {
            case .popularPath:
                return "3/movie/popular?language=en-US&page=1"
                
            case .topRatedPath:
                return "3/movie/top_rated?language=en-US&page=1"
                
            case .searchByCategoryPath:
                return "3/discover/movie?include_adult=true&include_video=false&language=en-US&page=1&sort_by=popularity.desc"
                
            case .movieGenresPath:
                return "3/genre/movie/list?language=en"
                
            case let .searchMoviesPath(query):
                return "3/search/movie?query=\(query)&language=en-US&page=1"
                
            case .watchlistPath:
                return "3/account/20707019/watchlist"
                
            case .watchlistMoviesPath:
                return "3/account/20707019/watchlist/movies"
                
            }
        }
    }
    
    func createRequest(urlString: String, httpMethod: String, parameters: [String: Any]? = nil) -> URLRequest {
        
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod
        
        request.addValue("application/json", forHTTPHeaderField: "accept")
        if httpMethod == "POST" {
            request.addValue("application/json", forHTTPHeaderField: "content-type")
        }
        request.addValue(JTConstraints.apiKey, forHTTPHeaderField: "Authorization")
        
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                fatalError("Failed to encode parameters: \(error)")
            }
        }
        
        
        return request
    }
    
    func fetchData<T: Decodable>(withPath path: HTTPMoviePath, httpMethod: String, parameters: [String: Any]? = nil, genres: String? = "") -> AnyPublisher<T, Error> {
        
        let url = "\(JTConstraints.http)" + "\(path.rawValue)" + "\(genres ?? "")"
        let request = createRequest(urlString: url, httpMethod: httpMethod, parameters: parameters)
        
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
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchMovies(withPath path: HTTPMoviePath, genres: String? = "") -> AnyPublisher<JTMovie, Error> {
        fetchData(withPath: path, httpMethod: "GET", genres: genres)
    }
    
    func fetchGenres() -> AnyPublisher<JTMovieGenres, Error> {
        fetchData(withPath: .movieGenresPath, httpMethod: "GET")
    }
    
    func addMovieToWatchList(movieID: Int) -> AnyPublisher<Void, Error> {
        let parameters = [
            
            "media_type": "movie",
            "media_id": movieID,
            "watchlist": true
            
        ] as [String : Any]
        
        let request = createRequest(urlString: "\(JTConstraints.http)" + "\(HTTPMoviePath.watchlistPath.rawValue)", httpMethod: "POST", parameters: parameters)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
            }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    func fetchMoviesFromMyWatchList() -> AnyPublisher<JTMovie, Error> {
        fetchData(withPath: .watchlistMoviesPath, httpMethod: "GET")
    }
    
    func searchMovies(withKeyLetters letters: String) -> AnyPublisher<JTMovie, Error> {
        fetchData(withPath: .searchMoviesPath(query: letters), httpMethod: "GET")
    }
}
