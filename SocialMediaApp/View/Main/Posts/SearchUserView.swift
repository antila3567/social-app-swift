//
//  SearchUserView.swift
//  SocialMediaApp
//
//  Created by Иван Легенький on 21.12.2023.
//

import SwiftUI
import FirebaseFirestore

struct SearchUserView: View {
    
    @State private var fethcedUsers: [User] = []
    @State private var searchText: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(fethcedUsers) { user in
                NavigationLink {
                    ReusableProfileContent(user: user)
                } label: {
                    Text(user.username)
                        .font(.callout)
                        .hAlign(.leading)
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Search User")
        .searchable(text: $searchText)
        .onSubmit(of: .search, {
            Task{ await searchUsers() }
        })
        .onChange(of: searchText, perform: { newValue in
            if newValue.isEmpty {
                fethcedUsers = []
            }
        })
    }
    
    func searchUsers() async {
        do {
            let documents = try await Firestore.firestore().collection("Users")
                .whereField("username", isGreaterThanOrEqualTo: searchText)
                .whereField("username", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
            }
            
            await MainActor.run(body: {
                fethcedUsers = users
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView()
    }
}
