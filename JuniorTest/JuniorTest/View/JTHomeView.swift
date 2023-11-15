//
//  JTHomeView.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import SwiftUI

struct JTHomeView: View {
    @StateObject private var vm = JTHomeViewModel()
    var body: some View {
        ZStack {
            Color("backgroundColor").ignoresSafeArea()
            
            LazyVStack {
                JTHeaderView()
                JTTabView(movieGanres: vm.movieGenres)
                
                
                Text("Popular Now")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.semibold)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(vm.movies, id: \.id) { movie in
                            
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath)")) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 100, height: 100)
                            
                        }
                    }
                    .padding(.horizontal, 15)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    JTHomeView()
}
