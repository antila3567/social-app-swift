//
//  LoadingView.swift
//  SocialMediaApp
//
//  Created by Иван Легенький on 20.12.2023.
//

import SwiftUI

struct LoadingView: View {
    @Binding var show: Bool
    
    @State private var offset: CGFloat = -130
    @State private var rotation: Double = 0
    
    var body: some View {
    if show {
        ZStack {
            AppBackgroundView()            
            
            ZStack {
                ForEach(0..<20) { i in
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                        .offset(y: offset)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.5 * Double(i)), value:
                                    offset)
                        .rotationEffect(.degrees(360 / 20) * Double(i))
                }
                ForEach(0..<20) { i in
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.black)
                        .offset(y: offset + 60)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.5 * Double(i)), value:
                                    offset)
                        .rotationEffect(.degrees(360 / 20) * Double(i))
                }
                ForEach(0..<20) { i in
                    Circle()
                        .frame(width: 5, height: 5)
                        .foregroundColor(.black)
                        .offset(y: offset + 90)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.5 * Double(i)), value:
                                    offset)
                        .rotationEffect(.degrees(360 / 20) * Double(i))
                }
            }
            .rotationEffect(.degrees(rotation))
            .animation(.linear(duration: 5).repeatForever(autoreverses: false), value: rotation)
            
            Text("Loading...")
                .font(.title)
                .offset(y: 300)
                .foregroundColor(.gray)
        }
        .onAppear {
            offset += 30
            rotation = 360
        }
        .onDisappear {
            offset = -130
            rotation = 0
        }
      }
    }
}


