//
//  ContentView.swift
//  SocialMediaApp
//
//  Created by Иван Легенький on 20.12.2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = true
    @State private var isLoading: Bool = false
    
    var body: some View {
        if isLoading {
            splashView
        } else {
            app
        }
    }
    
    
    private var splashView: some View {
        Color.black
            .overlay(SplashView())
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        self.isLoading = false
                    }
                }
            }
            .ignoresSafeArea()
    }
    
    private var app: some View {
        if logStatus {
            return AnyView(MainView())
        } else {
            return AnyView(LoginView())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
