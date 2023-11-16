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
    
}
