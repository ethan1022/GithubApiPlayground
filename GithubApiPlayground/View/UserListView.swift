//
//  ContentView.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/27.
//

import SwiftUI
import CoreData

struct UserListView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @StateObject private var userModel = UserListModel()
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Github Users")
                if let users = userModel.users {
                    List(users) { user in
                        NavigationLink {
                            UserDetailView(userName: user.login)
                        } label: {
                            userCell(user)
                                .onAppear {
                                    if users.last == user {
                                        userModel.fetchUsersList(since: user.id)
                                    }
                                }
                        }
                    }
                } else if let error = userModel.error {
                    Text("You got an error \(error.localizedDescription)")
                } else {
                    LoadingView()
                }
            }
        }
        .onAppear {
            userModel.fetchUsersList(since: 0)
        }
    }
    
    private func userCell(_ user: User) -> some View {
        HStack {
            if let url = URL(string: user.avatar_url) {
                ImageView(url: url)
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
            }
            Text(user.login)
                .labelStyle(.titleOnly)
                .multilineTextAlignment(.leading)
        }
    }
}


#Preview {
    UserListView()
}
