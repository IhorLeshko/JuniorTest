//
//  JTHomeViewModel.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import Foundation
import Combine

class JTHomeViewModel: ObservableObject {
    
    private var serviceManager: JTServiceManager = .init()
    
    @Published private(set) var movieGenres: [JTGenre] = []
    
    @Published private(set) var moviesByGenres: [JTMovieResult] = []
    
    @Published private(set) var popularNowMovies: [JTMovieResult] = []
    
    @Published private(set) var movies: [JTMovieResult] = []
    
    @Published var selectedGenre: Int? = 0 {
        didSet {
            fetchMoviesWithOffline(withPath: JTRemoteService.HTTPMoviePath.searchByCategoryPath, withGenres: selectedGenrePath)
        }
    }
    
    var selectedGenrePath: String {
        let path = "&with_genres="
        
        if let id = selectedGenre, id != 0 {
            return path + String(id)
        } else {
            return ""
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchGenres()
        fetchMoviesWithOffline(withPath: JTRemoteService.HTTPMoviePath.popularPath)
        fetchMoviesWithOffline(withPath: JTRemoteService.HTTPMoviePath.topRatedPath)
        fetchMoviesWithOffline(withPath: JTRemoteService.HTTPMoviePath.searchByCategoryPath, withGenres: selectedGenrePath)
    }
    
    func fetchMoviesWithOffline(withPath apiMoviePath: JTRemoteService.HTTPMoviePath, withGenres genres: String? = "") {
        serviceManager.fetchMovies(withPath: apiMoviePath, withGanres: genres)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(">>> failure here - \(error)")
                case .finished: break
                }
            } receiveValue: { [weak self] returnedMovies in
                switch apiMoviePath {
                case .popularPath:
                    self?.popularNowMovies = returnedMovies.results
                case .topRatedPath:
                    self?.movies = returnedMovies.results
                case .searchByCategoryPath:
                    self?.moviesByGenres = returnedMovies.results
                case .movieGenresPath:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchGenres() {
        serviceManager.fetchMovieGenres()
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
        .store(in: &cancellables)
    }
}
