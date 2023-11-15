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
            
            VStack {
                JTHeaderView()
                JTTabView(movieGanres: vm.movieGenres)
                
                Spacer()
            }
        }
    }
}

#Preview {
    JTHomeView()
}
