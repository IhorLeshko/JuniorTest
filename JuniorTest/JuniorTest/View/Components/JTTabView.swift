//
//  JTTabView.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import SwiftUI

struct JTTabView: View {
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(["Categories", "Films", "Movies"], id: \.self) { tab in
                        Button {
                            
                        } label: {
                            Text(tab)
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
            }
            .padding(.horizontal, 15)
    }
}

#Preview {
    ZStack {
        Color("backgroundColor")
        JTTabView()
    }
}
