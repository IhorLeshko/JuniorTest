//
//  JTGenreListView.swift
//  JuniorTest
//
//  Created by Ihor on 17.11.2023.
//

import SwiftUI

struct JTGenreListView: View {
    var genreIDs: [Int]
    @ObservedObject var vm: JTHomeViewModel

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(genreIDs.enumerated()), id: \.element) { index, genreID in
                if let genreName = vm.movieGenres.first(where: { $0.id == genreID })?.name {
                    Text(genreName)
                        .font(.caption)
                        .multilineTextAlignment(.center)

                    // Add a divider after each genre except for the last one
                    if index != genreIDs.count - 1 {
                        Circle()
                            .frame(width: 5)
                    }
                }
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    JTGenreListView(genreIDs: [18], vm: JTHomeViewModel())
}
