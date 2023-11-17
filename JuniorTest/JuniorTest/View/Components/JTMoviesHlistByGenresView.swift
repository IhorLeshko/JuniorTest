//
//  JTMoviesHlistByGenresView.swift
//  JuniorTest
//
//  Created by Ihor on 16.11.2023.
//

import SwiftUI

struct JTMoviesHlistByGenresView: View {
    @Environment(\.openURL) var openURL
    @ObservedObject var vm: JTHomeViewModel
    var geometryProxy: GeometryProxy
    @Binding var refreshMovieListByGenre: UUID
    
    var body: some View {
        TabView {
            ForEach(vm.moviesByGenres, id: \.id) { movie in
                JTMovieCardView(movie: movie, vm: vm, refreshMovieListByGenre: $refreshMovieListByGenre)
            }
            .padding(.horizontal, JTConstraints.horizontalPaddingOnHomeView)
        }
        .id(refreshMovieListByGenre)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: geometryProxy.size.width - 10, height: geometryProxy.size.height / 1.5)
        .tabViewStyle(PageTabViewStyle())
    }
}

#Preview {
    GeometryReader { proxy in
        JTMoviesHlistByGenresView(vm: JTHomeViewModel(), geometryProxy: proxy, refreshMovieListByGenre: .constant(UUID()))
    }
}

