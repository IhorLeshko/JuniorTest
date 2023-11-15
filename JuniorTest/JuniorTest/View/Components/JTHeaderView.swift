//
//  JTHeaderView.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import SwiftUI

struct JTHeaderView: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Hello, Ihor")
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
        .foregroundStyle(.white)
        .font(.title)
        .padding([.horizontal, .top], 15)
    }
}


#Preview {
    ZStack {
        Color("backgroundColor").ignoresSafeArea()
        JTHeaderView()
    }
}
