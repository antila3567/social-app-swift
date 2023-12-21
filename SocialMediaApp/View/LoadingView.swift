//
//  LoadingView.swift
//  SocialMediaApp
//
//  Created by Иван Легенький on 20.12.2023.
//

import SwiftUI

//struct LoadingView: View {
//    @Binding var show: Bool
//    
//    let timing: Double
//    
//    let maxCounter: Int = 3
//    let frame: CGSize
//    let primaryColor: Color
//
//    init(show: Binding<Bool>, color: Color = .black, size: CGFloat = 90, speed: Double = 0.5) {
//        _show = show
//        timing = speed * 2
//        frame = CGSize(width: size, height: size)
//        primaryColor = color
//        print("show is now \(self.show)")
//    }
//
//    var body: some View {
//
//        ZStack {
//            if show {
//                Group {
//                    Circle()
//                        .fill(primaryColor)
//                        .frame(height: frame.height / 3)
//                        .offset(
//                            x: 0,
//                            y: show ? -frame.height / 3 : 0
//                        )
//                    Circle()
//                        .fill(primaryColor)
//                        .frame(height: frame.height / 3)
//                        .offset(
//                            x: show ? -frame.height / 3 : 0,
//                            y: show ? frame.height / 3 : 0
//                        )
//                    Circle()
//                        .fill(primaryColor)
//                        .frame(height: frame.height / 3)
//                        .offset(
//                            x: show ? frame.height / 3 : 0,
//                            y: show ? frame.height / 3 : 0 )
//                }
//                .onAppear {
//                    withAnimation(Animation.easeInOut(duration: timing).repeatForever(autoreverses: true)) {
//                        self.show.toggle()
//                    }
//                }
//                .frame(width: frame.width, height: frame.height, alignment: .center)
//                .rotationEffect(Angle(degrees: show ? 360 : 0))
//              
//                }
//        }
//    }
//}

//
struct LoadingView: View {
    @Binding var show: Bool
    var body: some View {
        ZStack{
            if show{
                Group{
                    Rectangle()
                        .fill(.black.opacity(0.25))
                        .ignoresSafeArea()

                    ProgressView()
                        .padding(25)
                        .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous ))
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: show)
    }
}

