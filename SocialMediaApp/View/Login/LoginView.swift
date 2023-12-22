//
//  LoginView.swift
//  SocialMediaApp
//
//  Created by Иван Легенький on 20.12.2023.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct LoginView: View {
    @State var emailID: String = ""
    @State var password: String = ""
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var userProfileUrl: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Sign you in the App")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            Text("Welcome Back, \nYou have been missed")
                .font(.title3.weight(.semibold))
                .hAlign(.leading)
            VStack(spacing: 12) {
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .black)
                    .padding(.top, 25)
                SecureField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(1, .black)
                Button("Reset password?", action: resetPassword)
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAlign(.trailing)
                    .padding(.top, 5)
                Button(action: loginUser) {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)                }
            }
            
            HStack{
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button("Register now") {
                    createAccount.toggle()
                }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
        }
        .alert(errorMessage, isPresented: $showError , actions: {})
        .background(AppBackgroundView())
    }
    
    func loginUser() {
        isLoading = true
        closeKeyboard()
        Task{
            do {
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("user found")
                try await fetchUserData()
            } catch {
               await setError(error)
            }
        }
    }
    
    func fetchUserData()async throws {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        
        await MainActor.run(body: {
            userUID = userID
            userNameStored = user.username
            userProfileUrl = user.userProfileURL
            isLoading = false
            logStatus = true
        })
        
    }
    
    func resetPassword() {
        Task{
            do {
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("link sent")
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
