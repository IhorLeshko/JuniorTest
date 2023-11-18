//
//  JTMovieCardView.swift
//  JuniorTest
//
//  Created by Ihor on 17.11.2023.
//

import SwiftUI

struct JTMovieCardView: View {
    var movie: JTMovieResult
    @ObservedObject var viewModel: JTHomeViewModel
    @Binding var refreshMovieListByGenre: UUID
    
    @State private var posterURL = "\(JTConstants.posterURL)" + "\(JTConstants.posterHightQualtySetPath)"

    var body: some View {
        AsyncImage(url: URL(string: posterURL + "\(movie.posterPath ?? "")")) { image in
            image
                .resizable()
                .tag(movie)
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top)
                )
                .overlay {
                    VStack {
                        Spacer()

                        Text(movie.title)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)

                        JTGenreListView(genreIDs: movie.genreIDS, viewModel: viewModel)

                        JTMovieCardButtonsView(movie: movie, viewModel: viewModel)
                    }
                    .foregroundStyle(.white)
                    .padding(.bottom)
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(.white, lineWidth: 2)
                }
        } placeholder: {
            VStack(spacing: 30) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))

                Text(movie.originalTitle)
                    .font(.callout)
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    JTMovieCardView(movie: JTConstants.movieResultMock, viewModel: JTHomeViewModel(), refreshMovieListByGenre: .constant(UUID()))
}
