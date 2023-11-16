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
                
                JTTabView(vm: vm, movieGanres: vm.movieGenres)
                
                JTMoviesHorizontalListView(moviesData: vm.moviesByGenres)
                
                JTListTitleView(title: "Popular Now")
                
                JTMoviesHorizontalListView(moviesData: vm.popularNowMovies)
                
                JTListTitleView(title: "Movies")
                
                JTMoviesHorizontalListView(moviesData: vm.movies)
                
            }
        }
    }
}

#Preview {
    JTHomeView()
}


