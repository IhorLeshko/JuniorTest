//
//  JTHomeView.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import SwiftUI

struct JTHomeView: View {
    var body: some View {
        ZStack {
            Color("backgroundColor").ignoresSafeArea()
            
            VStack {
                JTHeaderView()
                JTTabView()
                
                Spacer()
            }
        }
    }
}

#Preview {
    JTHomeView()
}
