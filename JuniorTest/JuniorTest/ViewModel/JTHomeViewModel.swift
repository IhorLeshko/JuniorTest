//
//  JTHomeViewModel.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import Foundation

class JTHomeViewModel: ObservableObject {
    // mock data
    @Published private(set) var movieGenres: [JTGenre] = [
        JTGenre(id: 1, name: "All"),
        JTGenre(id: 2, name: "Comedy"),
        JTGenre(id: 3, name: "Family"),
        JTGenre(id: 4, name: "Shooter")
    ]
    
}
