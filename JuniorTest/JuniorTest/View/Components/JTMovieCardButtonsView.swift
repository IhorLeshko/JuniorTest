//
//  JTMovieCardButtonsView.swift
//  JuniorTest
//
//  Created by Ihor on 17.11.2023.
//

import SwiftUI

struct JTMovieCardButtonsView: View {
    var movie: JTMovieResult
    @ObservedObject var viewModel: JTHomeViewModel

    var body: some View {
        HStack {
            JTLinkButtonView(movieId: "\(movie.id)")

            Button {
                viewModel.addMovieToWatchList(movieID: movie.id)
            } label: {
                Label("My list", systemImage: viewModel.moviesInMyWatchList.contains { $0.id == movie.id } ? "checkmark" : "plus.circle")
                    .fontWeight(.semibold)
                    .frame(width: 110, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .strokeBorder(viewModel.moviesInMyWatchList.contains { $0.id == movie.id } ? .green : .white, lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    JTMovieCardButtonsView(movie: JTConstants.movieResultMock, viewModel: JTHomeViewModel())
}
