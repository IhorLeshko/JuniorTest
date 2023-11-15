//
//  JTTabView.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import SwiftUI

struct JTTabView: View {
    var movieGanres: [JTGenre]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(movieGanres, id: \.id) { tab in
                    Button {
                        
                    } label: {
                        Text(tab.name)
                            .foregroundStyle(.white)
                            .font(.callout)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background {
                                Capsule()
                                    .strokeBorder(.white, lineWidth: 1)
                            }
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
        JTTabView(movieGanres: [
            JTGenre(id: 1, name: "Shooter"),
            JTGenre(id: 2, name: "Family"),
            JTGenre(id: 3, name: "Comedy")
        ])
    }
}
