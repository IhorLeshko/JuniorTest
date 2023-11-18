//
//  JTConstants.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import Foundation

struct JTConstants {
    static let apiURL = "https://api.themoviedb.org/"
    static let webSiteURL = "https://www.themoviedb.org/"
    static let posterURL = "https://image.tmdb.org/t/p/"
    static let posterHightQualtySetPath = "w500"
    static let posterLowQualtySetPath = "w200"
    static let apiKey = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5YTY4OTg0NDEzYWRkMWIxMTQ0MzAzYjQ2ZDU0M2Y2OCIsInN1YiI6IjY1NTQ4ZWVmOTY1M2Y2MTNmNjJhMzgzNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.eJeK6hezCrhDCs1o8JLW15RlNcAEBG7LE_YtOE1WfYY"
    
    static let horizontalPaddingOnHomeView: CGFloat = 15
    
    
    static let movieResultMock: JTMovieResult = JTMovieResult(adult: false, backdropPath: "/4XM8DUTQb3lhLemJC51Jx4a2EuA.jpg", genreIDS: [28, 80], id: 385687, originalLanguage: "en", originalTitle: "Fast X", overview: "Over many missions and against impossible odds, Dom Toretto and his family have outsmarted, out-nerved and outdriven every foe in their path. Now, they confront the most lethal opponent they've ever faced: A terrifying threat emerging from the shadows of the past who's fueled by blood revenge, and who is determined to shatter this family and destroy everything—and everyone—that Dom loves, forever.", popularity: 770.15, posterPath: "/fiVW06jE7z9YnO4trhaMEdclSiC.jpg", releaseDate: "2023-05-17", title: "Fast X", video: false, voteAverage: 7.223, voteCount: 4265)
}
