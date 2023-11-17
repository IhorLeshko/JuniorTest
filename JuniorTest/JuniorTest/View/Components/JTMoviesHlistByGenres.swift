//
//  JTMoviesHlistByGenres.swift
//  JuniorTest
//
//  Created by Ihor on 16.11.2023.
//

import SwiftUI

struct JTMoviesHlistByGenres: View {
    @Environment(\.openURL) var openURL
    
    var vm: JTHomeViewModel
    var geometryProxy: GeometryProxy
    @Binding var refreshMovieListByGenre: UUID
    
    var body: some View {
        TabView {
            ForEach(vm.moviesByGenres, id: \.id) { movie in
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w400\(movie.posterPath)")) { image in
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
                                
                                HStack(spacing: 4) {
                                    ForEach(Array(movie.genreIDS.enumerated()), id: \.element) { index, genreID in
                                        if let genreName = vm.movieGenres.first(where: { $0.id == genreID })?.name {
                                            Text(genreName)
                                                .font(.caption)
                                                .multilineTextAlignment(.center)
                                            
                                            // Add a divider after each genre except for the last one
                                            if index != movie.genreIDS.count - 1 {
                                                Circle()
                                                    .frame(width: 5)
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom)
                                
                                HStack {
                                    JTLinkButtonView(movieId: "\(movie.id)")
                                    Button {
                                        vm.addMovieToWatchList(movieID: movie.id)
                                    } label: {
                                        Label("My list", systemImage: vm.moviesInMyWithList.contains { $0.id == movie.id } ? "checkmark" : "plus.circle")
                                            .fontWeight(.semibold)
                                            .frame(width: 110, height: 40)
                                            .background(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .strokeBorder(vm.moviesInMyWithList.contains { $0.id == movie.id } ? .green : .white, lineWidth: 1)
                                            )
                                    }
                                }
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
        JTMoviesHlistByGenres(vm: JTHomeViewModel(), geometryProxy: proxy, refreshMovieListByGenre: .constant(UUID()))
    }
}
