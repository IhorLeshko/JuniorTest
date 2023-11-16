//
//  JTHomeViewModel.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import Foundation
import Combine

class JTHomeViewModel: ObservableObject {
    
    @Published private(set) var movieGenres: [JTGenre] = [JTGenre(id: 0, name: "All")]
    
    @Published private(set) var moviesByGenres: [JTMovieResult] = []
    
    @Published private(set) var popularNowMovies: [JTMovieResult] = []
    
    @Published private(set) var movies: [JTMovieResult] = []
    
    @Published var selectedGenre: String? {
        didSet {
            fetchMovies(withPath: HTTPMoviePath.searchByCategoryPath, withGanres: selectedGenrePath)
        }
    }
    
    var selectedGenrePath: String {
        let path = "&with_genres="
        
        if let id = selectedGenre {
            return path + id
        } else {
            return ""
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    
    enum HTTPMoviePath: String {
        case popularPath = "3/movie/popular?language=en-US&page=1"
        case topRatedPath = "3/movie/top_rated?language=en-US&page=1"
        case searchByCategoryPath = "3/discover/movie?include_adult=true&include_video=false&language=en-US&page=1&sort_by=popularity.desc"
    }
    //"&with_genres=18"
    init() {
        fetchMovies(withPath: HTTPMoviePath.popularPath)
        fetchMovies(withPath: HTTPMoviePath.topRatedPath)
        fetchMovies(withPath: HTTPMoviePath.searchByCategoryPath, withGanres: selectedGenrePath)
        fetchGenres()
    }
    
    func fetchMovies(withPath apiMoviePath: HTTPMoviePath, withGanres ganres: String? = "") {
        
        guard let url = URL(string: "\(JTConstraints.http)" + "\(apiMoviePath.rawValue)" + "\(ganres ?? "")") else { return }
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(JTConstraints.apiKey, forHTTPHeaderField: "Authorization")
        
        // 1. create the publisher
        URLSession.shared.dataTaskPublisher(for: request)
        
        // 2. subscribe publisher on background thread
            .subscribe(on: DispatchQueue.global(qos: .background))
        
        // 3. recieve on main thread
            .receive(on: DispatchQueue.main)
        
        // 4. tryMap (check if the data is fine)
            .tryMap { (data, response) -> Data in
                
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
        // 5. Decode data in JTMovie model
            .decode(type: JTMovie.self, decoder: JSONDecoder())
        
        // 6. Put item in app
            .sink { (completion) in
                // handle completion (optional)
                
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("There was an error: \(error)")
                }
                
            } receiveValue: { [weak self] (returnedMovies) in
                
                switch apiMoviePath {
                case .popularPath:
                    self?.popularNowMovies = returnedMovies.results
                case .topRatedPath:
                    self?.movies = returnedMovies.results
                case .searchByCategoryPath:
                    self?.moviesByGenres = returnedMovies.results
                }
            }
        
        // 7. store (cancel sub if needed)
            .store(in: &cancellables)
        
    }
    
    func fetchGenres() {
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?language=en") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(JTConstraints.apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
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
        
            .sink { (completion) in
                
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("There was an error: \(error)")
                }
                
            } receiveValue: { [weak self] (returnedGenres) in
                self?.movieGenres = returnedGenres.genres
            }
        
        // 7. store (cancel sub if needed)
            .store(in: &cancellables)
        
    }
}
