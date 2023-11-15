//
//  JTListTitleView.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import SwiftUI

struct JTListTitleView: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fontWeight(.semibold)
            .padding(.vertical, 10)
            .padding(.horizontal, JTConstraints.horizontalPaddingOnHomeView)
    }
}

#Preview {
    JTListTitleView(title: "Popular Now")
}
