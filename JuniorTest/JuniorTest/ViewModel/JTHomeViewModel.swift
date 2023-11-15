//
//  JTHomeViewModel.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import Foundation
import Combine

class JTHomeViewModel: ObservableObject {
    // mock data
    @Published private(set) var movieGenres: [JTGenre] = [
        JTGenre(id: 1, name: "All"),
        JTGenre(id: 2, name: "Comedy"),
        JTGenre(id: 3, name: "Family"),
        JTGenre(id: 4, name: "Shooter")
    ]
    
    
    @Published var popularNowMovies: [JTMovieResult] = []
    
    @Published var movies: [JTMovieResult] = []
    
    var cancellables = Set<AnyCancellable>()
    
    enum HTTPMovieFilter: String {
        case popular = "popular"
        case topRated = "top_rated"
    }
    
    init() {
        fetchMovies(filterWith: HTTPMovieFilter.popular)
        fetchMovies(filterWith: HTTPMovieFilter.topRated)
    }
    
    func fetchMovies(filterWith apiMovieFilter: HTTPMovieFilter) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(apiMovieFilter.rawValue)?language=en-US&page=1") else { return }
        
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
                
                switch apiMovieFilter {
                case .popular:
                    self?.popularNowMovies = returnedMovies.results
                case .topRated:
                    self?.movies = returnedMovies.results
                }
            }
        
        // 7. store (cancel sub if needed)
            .store(in: &cancellables)
        
    }
    
}
