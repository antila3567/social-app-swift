//
//  ProfileView.swift
//  SocialMediaApp
//
//  Created by Иван Легенький on 20.12.2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    @State private var myProfile: User?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let myProfile {
                    ReusableProfileContent(user: myProfile)
                        .refreshable {
                            self.myProfile = nil
                            await fetchUserData()
                        }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("My profile")
            .background(AppBackgroundView())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Logout", action: logoutUser)
                        Button("Delete account", role: .destructive, action: deleteUser)
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }
                }
            }
        }
        .overlay(content: {
          LoadingView(show: $isLoading)
        })
        .alert(errorMessage, isPresented: $showError) {
            
        }
        .task {
            if myProfile != nil { return }
            await fetchUserData()
        }
    }
    
    func fetchUserData() async {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else { return }
        
        await MainActor.run(body: {
            myProfile = user
        })
        
    }
    
    func logoutUser() {
        try? Auth.auth().signOut()
        logStatus = false
    }
    
    func deleteUser() {
        isLoading = true
        Task {
            do {
                guard let userUID = Auth.auth().currentUser?.uid else { return }
                
                let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
                try await await reference.delete()
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                try await Auth.auth().currentUser?.delete()
                
                logStatus = false
                isLoading = false
            } catch {
                await setError(error)
            }
        }
    }
    
    func setError(_ error: Error)async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}
