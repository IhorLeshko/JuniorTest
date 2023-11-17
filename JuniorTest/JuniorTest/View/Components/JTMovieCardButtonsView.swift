//
//  JTMovieCardButtonsView.swift
//  JuniorTest
//
//  Created by Ihor on 17.11.2023.
//

import SwiftUI

struct JTMovieCardButtonsView: View {
    var movie: JTMovieResult
    @ObservedObject var vm: JTHomeViewModel

    var body: some View {
        HStack {
            JTLinkButtonView(movieId: "\(movie.id)")

            Button {
                vm.addMovieToWatchList(movieID: movie.id)
            } label: {
                Label("My list", systemImage: vm.moviesInMyWatchList.contains { $0.id == movie.id } ? "checkmark" : "plus.circle")
                    .fontWeight(.semibold)
                    .frame(width: 110, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .strokeBorder(vm.moviesInMyWatchList.contains { $0.id == movie.id } ? .green : .white, lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    JTMovieCardButtonsView(movie: JTConstraints.movieResultMock, vm: JTHomeViewModel())
}
