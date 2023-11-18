//
//  JTTabView.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import SwiftUI

struct JTTabView: View {
    @ObservedObject var viewModel: JTHomeViewModel
    @Binding var refreshMovieListByGenre: UUID
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button {
                    viewModel.selectedGenre = 0
                    refreshMovieListByGenre = UUID()
                } label: {
                    Text("All")
                        .tabButtonStyle(vm: viewModel)
                }
                
                ForEach(viewModel.movieGenres, id: \.id) { tab in
                    Button {
                        viewModel.selectedGenre = tab.id
                        refreshMovieListByGenre = UUID()
                    } label: {
                        Text(tab.name)
                            .tabButtonStyle(vm: viewModel, tabID: tab.id)
                    }
                }
            }
            .padding(.horizontal, JTConstants.horizontalPaddingOnHomeView)
        }
    }
}

#Preview {
    ZStack {
        Color("backgroundColor").ignoresSafeArea()
        JTTabView(viewModel: JTHomeViewModel(), refreshMovieListByGenre: .constant(UUID()))
    }
}

private extension View {
    func tabButtonStyle(vm: JTHomeViewModel, tabID: Int? = 0) -> some View {
        self.foregroundStyle(tabID == vm.selectedGenre ? .black : .white)
            .font(.callout)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background {
                if tabID == vm.selectedGenre {
                    Capsule()
                        .foregroundStyle(.white)
                } else {
                    Capsule()
                        .strokeBorder(.white, lineWidth: 1)
                }
            }
    }
}
