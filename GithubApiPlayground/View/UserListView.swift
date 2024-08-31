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
    @StateObject private var userListModel = UserListModel()
    @State private var showErrorAlert = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Github Users")
                ZStack {
                    if let users = userListModel.users {
                        List(users) { user in
                            NavigationLink {
                                UserDetailView(userName: user.login)
                            } label: {
                                userCell(user)
                                    .onAppear {
                                        if users.last == user {
                                            userListModel.fetchUsersList(since: user.id)
                                        }
                                    }
                            }
                        }
                    } else {
                        LoadingView()
                        if !networkMonitor.isConnected {
                            NoNetworkView()
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showErrorAlert, content: {
            Alert.error(userListModel.error)
        })
        .onChange(of: userListModel.error?.localizedDescription, { _, _ in
            showErrorAlert = userListModel.error != nil
        })
        .onAppear {
            userListModel.fetchUsersList(since: 0)
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
        .environmentObject(NetworkMonitor())
}
