//
//  JTHomeView.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import SwiftUI

struct JTHomeView: View {
    
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @StateObject private var vm = JTHomeViewModel()
    
    @State private var showNetworkAlert = false
    @State private var showNetworkAlertSucsessfull = false
    
    @State private var refreshId = UUID()
    @State private var refreshMovieListByGenre = UUID()
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Color("backgroundColor").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        JTHeaderView()
                        
                        JTTabView(vm: vm, refreshMovieListByGenre: $refreshMovieListByGenre)
                        
                        JTMoviesHlistByGenres(vm: vm, geometryProxy: geo, refreshMovieListByGenre: $refreshMovieListByGenre)
                        
                        JTListTitleView(title: "Popular Now")
                        
                        JTMoviesHorizontalListView(moviesData: vm.popularNowMovies, refreshId: $refreshId)
                        
                        JTListTitleView(title: "Movies")
                        
                        JTMoviesHorizontalListView(moviesData: vm.movies, refreshId: $refreshId)
                    }
                }
            }
        }
        .onChange(of: networkMonitor.isConnected) { connection in
            if !connection {
                showNetworkAlert = true
            } else {
                showNetworkAlertSucsessfull = true
                refreshId = UUID()
                refreshMovieListByGenre = UUID()
            }
        }
        .alert(
            "Network connection seems to be offline.",
            isPresented: $showNetworkAlert
        ) {}
            .alert(
                "Network connection seems to be ONLINE.",
                isPresented: $showNetworkAlertSucsessfull
            ) {}
    }
}

#Preview {
    JTHomeView()
}



