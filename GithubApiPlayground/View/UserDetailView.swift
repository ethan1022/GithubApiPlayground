//
//  UserDetailView.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/29.
//

import SwiftUI

struct UserDetailView: View {
    var userName: String
    
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @StateObject var userDetailModel = UserDetailModel()
    @StateObject var userRepoModel = UserRepoModel()
    @State private var selectedRepo: UserRepo?
    @State private var showUserRepoAlert = false
    @State private var showUserDetailAlert = false
    
    var body: some View {
        VStack {
            if let userDetail = userDetailModel.userDetail {
                userInfoView(userDetail)
                    .padding(.vertical, 20)
            } else {
                LoadingView()
                    .frame(maxHeight: 150)
            }
            
            HStack {
                Text("All Public Repositories")
                    .padding(.leading, 20)
                    .font(.title3)
                Spacer()
            }
            
            ZStack {
                if let userReposWithoutFork = userRepoModel.userReposWithoutFork {
                    List(userReposWithoutFork) { userRepo in
                        Button(action: {
                            self.selectedRepo = userRepo
                        }, label: {
                            repoCell(userRepo)
                                .onAppear {
                                    if userRepo == userReposWithoutFork.last {
                                        userRepoModel.loadMore(with: userName)
                                    }
                                }
                        })
                        .sheet(item: $selectedRepo, content: { selectRepo in
                            RepoDetailView(urlString: selectRepo.html_url)
                        })
                    }
                    
                    if userReposWithoutFork.isEmpty {
                        VStack {
                            Spacer()
                            Text("He doesn't have any repositories yet.")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                    }
                } else {
                    LoadingView()
                    if !networkMonitor.isConnected {
                        NoNetworkView()
                    }
                }
            }
            Spacer()
        }
        .alert(isPresented: $showUserRepoAlert, content: {
            Alert.error(userRepoModel.error)
        })
        .onChange(of: userRepoModel.error?.localizedDescription, { _, _ in
            showUserRepoAlert = userRepoModel.error != nil
        })
        .alert(isPresented: $showUserDetailAlert, content: {
            Alert.error(userDetailModel.error)
        })
        .onChange(of: userDetailModel.error?.localizedDescription, { _, _ in
            showUserDetailAlert = userDetailModel.error != nil
        })
        .onAppear {
            userDetailModel.fetchUserDetail(with: userName)
            userRepoModel.fetchUserRepo(with: userName)
        }
    }
    
    func userInfoView(_ userDetail: UserDetail) -> some View {
        HStack {
            if let url = URL(string: userDetail.avatar_url) {
                ImageView(url: url)
                    .frame(width: 80, height: 80)
                    .cornerRadius(40)
                    .padding(.horizontal, 15)
            }
            VStack(alignment: .leading) {
                Text(userDetail.name ?? "Anonymous")
                    .font(.title2)
                    .foregroundStyle(userDetail.name != nil ? Color.primary : Color.gray)
                Text("ID: \(userDetail.login)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                HStack(spacing: 4) {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width:12, height: 12)
                    Text("\(userDetail.followers) Followers")
                        .font(.footnote)
                    Text("\(userDetail.following) Following")
                        .font(.footnote)
                }
                if let bio = userDetail.bio {
                    Text(bio)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }
            }
            Spacer()
        }
    }
    
    func repoCell(_ userRepo: UserRepo) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack() {
                        Image(systemName: "bookmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 15)
                            .foregroundColor(.gray)
                        Text(userRepo.name ?? "NoRepoName")
                            .font(.title3)
                            .foregroundStyle(.blue)
                    }
                    if let description = userRepo.description {
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .padding(.bottom, 10)
                    } else {
                        Rectangle()
                            .frame(height: 10)
                            .foregroundColor(.clear)
                    }
                    HStack(spacing: 3) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.orange)
                        Text("\(userRepo.language ?? "Unknown")")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
                Spacer()
                HStack(alignment: .center, spacing: 4) {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width:18, height: 18)
                        .foregroundColor(.yellow)
                        .padding(.leading, 3)
                    Text("Star \(userRepo.stargazers_count)")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.trailing, 3)
                }
            }
        }
    }
    
    
}

#Preview {
    UserDetailView(userName: "brynary")
        .environmentObject(NetworkMonitor())
}
