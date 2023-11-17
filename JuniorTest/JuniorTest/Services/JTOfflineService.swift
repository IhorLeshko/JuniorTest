//
//  JTOfflineService.swift
//  JuniorTest
//
//  Created by Ihor on 16.11.2023.
//

import Foundation
import Combine

class JTOfflineService {
    
    private let defaults = UserDefaults.standard
    private let userDefaultsKeys: JTRemoteService.HTTPMoviePath = .movieGenresPath
    
    init() {
        
    }
    
    func saveOffline(movie: JTMovie, withKey userDefaultsKey: JTRemoteService.HTTPMoviePath) {
        if let encoded: Data = try? JSONEncoder().encode(movie) {
            defaults.set(encoded, forKey: userDefaultsKey.rawValue)
        }
    }
    
    func getOffline(withKey userDefaultsKey: JTRemoteService.HTTPMoviePath) -> AnyPublisher<JTMovie, Error> {
        do {
            guard let data: Data = defaults.object(forKey: userDefaultsKey.rawValue) as? Data else {
                return Just(JTMovie(page: 0, results: [], totalPages: 0, totalResults: 0))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            
            let decoded: JTMovie = try JSONDecoder().decode(JTMovie.self, from: data)
            
            return Just(decoded)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func saveOfflineGenres(movie: JTMovieGenres, withKey userDefaultsKey: JTRemoteService.HTTPMoviePath) {
        if let encoded: Data = try? JSONEncoder().encode(movie) {
            defaults.set(encoded, forKey: userDefaultsKey.rawValue)
        }
    }
    
    func getOfflineGenres(withKey userDefaultsKey: JTRemoteService.HTTPMoviePath) -> AnyPublisher<JTMovieGenres, Error> {
        do {
            guard let data: Data = defaults.object(forKey: userDefaultsKey.rawValue) as? Data else {
                return Just(JTMovieGenres(genres: []))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            
            let decoded: JTMovieGenres = try JSONDecoder().decode(JTMovieGenres.self, from: data)
            
            return Just(decoded)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
