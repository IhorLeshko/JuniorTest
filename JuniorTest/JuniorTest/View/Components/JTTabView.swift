//
//  JTTabView.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import SwiftUI

struct JTTabView: View {
    @ObservedObject var vm: JTHomeViewModel
    var movieGanres: [JTGenre]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button {
                    vm.selectedGenre = nil
                } label: {
                    Text("All")
                        .tabButtonStyle()
                }
                
                ForEach(movieGanres, id: \.id) { tab in
                    Button {
                        vm.selectedGenre = String(tab.id)
                    } label: {
                        Text(tab.name)
                            .tabButtonStyle()
                    }
                }
            }
            .padding(.horizontal, JTConstraints.horizontalPaddingOnHomeView)
        }
    }
}

#Preview {
    ZStack {
        Color("backgroundColor").ignoresSafeArea()
        JTTabView(vm: JTHomeViewModel(), movieGanres: [
            JTGenre(id: 1, name: "Shooter"),
            JTGenre(id: 2, name: "Family"),
            JTGenre(id: 3, name: "Comedy")
        ])
    }
}

private extension View {
    func tabButtonStyle() -> some View {
        self.foregroundStyle(.white)
            .font(.callout)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background {
                Capsule()
                    .strokeBorder(.white, lineWidth: 1)
            }
    }
}
