//
//  JTSearchListView.swift
//  JuniorTest
//
//  Created by Ihor on 17.11.2023.
//

import SwiftUI

struct JTSearchListView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: JTHomeViewModel
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List(vm.searchMovies, id: \.id) { movie in
                Text(movie.title)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .onChange(of: searchText) { _ in
                vm.searchMovies(withKeyLetters: searchText)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    JTSearchListView(vm: JTHomeViewModel())
}
