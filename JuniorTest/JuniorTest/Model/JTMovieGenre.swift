//
//  JTMovieGenre.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import Foundation

struct JTMovieGenre: Codable {
    let genres: [JTGenre]
}

struct JTGenre: Codable {
    let id: Int
    let name: String
}
