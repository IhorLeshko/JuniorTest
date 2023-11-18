//
//  JTLinkButtonView.swift
//  JuniorTest
//
//  Created by Ihor on 17.11.2023.
//

import SwiftUI

struct JTLinkButtonView: View {
    
    var movieId: String
    
    var body: some View {
        Link(destination: URL(string: "\(JTConstants.webSiteURL)" + "movie/\(movieId)")!) {
            Label("Play", systemImage: "play.circle")
                .fontWeight(.semibold)
                .frame(width: 110, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill()
                        .foregroundStyle(Color("buttonColor"))
                )
        }
    }
}

#Preview {
    JTLinkButtonView(movieId: "678512")
}
