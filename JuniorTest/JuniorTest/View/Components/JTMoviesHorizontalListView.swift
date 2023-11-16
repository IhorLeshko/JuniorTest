//
//  JTMoviesHorizontalListView.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import SwiftUI

struct JTMoviesHorizontalListView: View {
    
    var moviesData: [JTMovieResult]
    
    @Binding var refreshId: UUID
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(moviesData, id: \.id) { movie in
                    
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath)")) { image in
                        image.resizable()
                    } placeholder: {
                        VStack(spacing: 10) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            Text(movie.originalTitle)
                                .font(.callout)
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(width: 100, height: 140)
                    .clipShape(
                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                    )
                }
            }
            .padding(.horizontal, JTConstraints.horizontalPaddingOnHomeView)
        }
        .id(refreshId)
    }
}

#Preview {
    JTHomeView()
}
