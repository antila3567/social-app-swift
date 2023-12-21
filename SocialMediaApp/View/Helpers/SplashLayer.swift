//
//  SplashLayer.swift
//  SocialMediaApp
//
//  Created by Иван Легенький on 20.12.2023.
//

enum CicrcleState {
    case left
    case right
    case undefined
}

import SwiftUI

struct SplashLayer: View {
    var state: CicrcleState = .undefined
    var moveOffset: CGFloat = 0
    var animationDuration: TimeInterval = 0.3
    
    @State var xOffset: CGFloat = 0
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 18, height: 18)
            .offset(x: xOffset)
            .shadow(color: .white, radius: 10)
            .onAppear() {
                if (state == .left) {
                    Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) {_ in
                        initialWithRight()
                    }
                } else {
                    Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) {_ in
                        initialWithLeft()
                    }
                }
            }
    }
    func initialWithLeft() {
        withAnimation(Animation.easeInOut(duration: animationDuration / 2)) {
            self.xOffset = -moveOffset
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration / 2, repeats: false) {_ in
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                self.xOffset = moveOffset
            }
        }
    }
    
    func initialWithRight() {
        withAnimation(Animation.easeInOut(duration: animationDuration / 2)) {
            self.xOffset = moveOffset
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration / 2, repeats: false) {_ in
            withAnimation(Animation.easeInOut(duration: animationDuration / 2)) {
                self.xOffset = -moveOffset
            }
        }
    }
}



struct SplashView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                SplashLayer(state: .right, moveOffset: 15, animationDuration: 1)
                SplashLayer(state: .right, moveOffset: 15, animationDuration: 1.1)
                SplashLayer(state: .right, moveOffset: 15, animationDuration: 1.05)
                SplashLayer(state: .right, moveOffset: 15, animationDuration: 1.15)
                SplashLayer(state: .right, moveOffset: 15, animationDuration: 1.05)
                SplashLayer(state: .right, moveOffset: 15, animationDuration: 1)
            }
        }
    }
}

struct SplashLayer_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            SplashView()
        }
    }
}

