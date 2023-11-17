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
    @State var showSearchSheet = false
    @State private var refreshMovieListByGenre = UUID()
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Color("backgroundColor").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        JTHeaderView(showSearchSheet: $showSearchSheet)
                        
                        JTTabView(vm: vm, refreshMovieListByGenre: $refreshMovieListByGenre)
                        
                        JTMoviesHlistByGenres(vm: vm, geometryProxy: geo, refreshMovieListByGenre: $refreshMovieListByGenre)
                        
                        JTListTitleView(title: "Popular Now")
                        
                        JTMoviesHorizontalListView(moviesData: vm.popularNowMovies, refreshId: $vm.refreshId)
                        
                        JTListTitleView(title: "Movies")
                        
                        JTMoviesHorizontalListView(moviesData: vm.movies, refreshId: $vm.refreshId)
                    }
                }
            }
        }
        .onChange(of: networkMonitor.isConnected) { connection in
            if !connection {
                showNetworkAlert = true
            } else {
                showNetworkAlertSucsessfull = true
                vm.refreshId = UUID()
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
        .sheet(isPresented: $showSearchSheet) {
            JTSearchListView(vm: vm)
        }
    }
}

#Preview {
    JTHomeView()
}



