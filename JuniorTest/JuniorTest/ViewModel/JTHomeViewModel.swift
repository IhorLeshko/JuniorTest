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
    
    @Published var refreshId: UUID = UUID()
    
    @Published private(set) var movieGenres: [JTGenre] = []
    
    @Published private(set) var moviesByGenres: [JTMovieResult] = []
    
    @Published private(set) var popularNowMovies: [JTMovieResult] = []
    
    @Published private(set) var movies: [JTMovieResult] = []
    
    @Published private(set) var moviesInMyWatchList: [JTMovieResult] = []
    
    @Published private(set) var searchMovies: [JTMovieResult] = []
    
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
        fetchMoviesFromMyWatchList()
    }
    
    func fetchMoviesWithOffline(withPath apiMoviePath: JTRemoteService.HTTPMoviePath, withGenres genres: String? = "") {
        serviceManager.fetchMovies(withPath: apiMoviePath, withGenres: genres)
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
                case .searchMoviesPath:
                    break
                case .watchlistPath:
                    break
                case .watchlistMoviesPath:
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
    
    func addMovieToWatchList(movieID: Int) {
        serviceManager.addMovieToWatchList(movieID: movieID)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully added to watchlist.")
                    self.fetchMoviesFromMyWatchList()
                case .failure(let error):
                    print("Error adding to watchlist: \(error)")
                }
            } receiveValue: { _ in
            }.store(in: &cancellables)
    }
    
    func fetchMoviesFromMyWatchList() {
        serviceManager.fetchMoviesFromMyWatchList()
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched watchlist.")
                case .failure(let error):
                    print("Error fetching from wishlist: \(error)")
                }
            } receiveValue: { [weak self] movies in
                self?.moviesInMyWatchList = movies.results
            }
            .store(in: &cancellables)
    }
    
    func searchMovies(withKeyLetters letters: String) {
        serviceManager.searchMovies(withKeyLetters: letters)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched search.")
                case .failure(let error):
                    print("Error while searching: \(error)")
                }
            } receiveValue: { [weak self] movies in
                self?.searchMovies = movies.results
            }
            .store(in: &cancellables)
    }
}
