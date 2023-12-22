//
//  PostDetails.swift
//  SocialMediaApp
//
//  Created by Иван Легенький on 22.12.2023.
//

import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI

struct PostDetails: View {
    @Binding var postId: String?
    @Binding var isPresented: Bool
    
    @State private var currentPost: Post?
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    
    @AppStorage("user_UID") private var userUID: String = ""
    
    var body: some View {
        VStack {
            if let post = currentPost {
                VStack(alignment: .leading, spacing: 6) {
                    if let postImageURL = post.imageURL {
                        GeometryReader {
                            let size = $0.size
                            
                            WebImage(url: postImageURL)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        Text(post.text)
                            .vAlign(.top)
                            .font(.title2)
                            .bold()
                            .padding(.top, 20)
                    }
                }
                .padding(15)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Something went wrong \nplease try later")
                    .font(.title.bold())
                    .foregroundColor(.black)
                    .vAlign(.center)
                    .hAlign(.center)
                    .padding(30)
                
            }
        }
        .background(AppBackgroundView())
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .task {
            if currentPost != nil { return }
            await fetchPost()
        }
    }
    
    func fetchPost() async {
        isLoading = true
        do {
            guard let currentPostId = postId else { return }
            let document = try await Firestore.firestore().collection("Posts").document(currentPostId).getDocument()
            
            if document.exists {
                currentPost = try? document.data(as: Post.self)
            } else {
                // Обробка випадку, коли документ не існує
            }
        } catch {
            await setError(error)
        }
        isLoading = false
    }
    
    func setError(_ error: Error)async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}

struct PostDetails_Previews: PreviewProvider {
    static var previews: some View {
        PostDetails(postId: Binding.constant("aB7UT8N4UWYs69pV4iEc"), isPresented: Binding.constant(true))
    }
}

//func fetchPosts() async {
//    do {

//
//        let docs = try await query.getDocuments()
//        let fetchedPosts = docs.documents.compactMap { doc -> Post? in
//            try? doc.data(as: Post.self)
//        }
//
//        print("Posts count \(fetchedPosts.count)")
//
//        await MainActor.run(body: {
//            posts.append(contentsOf: fetchedPosts)
//            paginationDoc = docs.documents.last
//            isFetching = false
//        })
//    } catch {
//        print(error.localizedDescription)
//    }
//}
