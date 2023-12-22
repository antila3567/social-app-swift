//
//  AppBackgroundView.swift
//  SocialMediaApp
//
//  Created by Иван Легенький on 22.12.2023.
//

import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("imageBG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1)
            }
        }
    }
}
