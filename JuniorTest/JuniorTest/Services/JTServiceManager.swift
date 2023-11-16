//
//  JTServiceManager.swift
//  JuniorTest
//
//  Created by Ihor on 16.11.2023.
//

import Foundation
import Combine

class JTServiceManager {
    
    private let remoteService: JTRemoteService = .init()
    private let offlineService: JTOfflineService = .init()
    
    func fetchMovies(withPath apiMoviePath: JTRemoteService.HTTPMoviePath, withGanres ganres: String? = "") -> AnyPublisher<JTMovie, Error> {
        
        return remoteService.fetchMovies(withPath: apiMoviePath, withGanres: ganres)
            .catch { [weak self] error in
                return self?.offlineService.getOffline(withKey: apiMoviePath) ?? Empty().eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput:  { [weak self] movies in
                self?.offlineService.saveOffline(movie: movies, withKey: apiMoviePath)
            })
            .eraseToAnyPublisher()
    }
    
    func fetchMovieGenres() -> AnyPublisher<JTMovieGenres, Error> {
        print(remoteService.fetchGenres())
        return remoteService.fetchGenres()
            .catch { [weak self] error in
                return self?.offlineService.getOfflineGenres(withKey: JTRemoteService.HTTPMoviePath.movieGenresPath) ?? Empty().eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput: { [weak self] genres in
                self?.offlineService.saveOfflineGenres(movie: genres, withKey: JTRemoteService.HTTPMoviePath.movieGenresPath)
            })
            .eraseToAnyPublisher()
    }
}
