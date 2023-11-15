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
                    .padding(.horizontal, JTConstraints.horizontalPaddingOnHomeView)
                
                JTMoviesHorizontalListView(moviesData: vm.popularNowMovies)
                
                JTMoviesHorizontalListView(moviesData: vm.movies)
                
                Spacer()
            }
        }
    }
}

#Preview {
    JTHomeView()
}


