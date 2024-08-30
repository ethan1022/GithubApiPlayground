//
//  UserDetailView.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/29.
//

import SwiftUI

struct UserDetailView: View {
    var userName: String
    
    @StateObject var userDetailModel = UserDetailModel()
    @StateObject var userRepoModel = UserRepoModel()
    @State private var selectedRepo: UserRepo?
    
    var body: some View {
        VStack {
            userInfoView
                .padding(.vertical, 20)
            
            HStack {
                Text("All Public Repositories")
                    .padding(.leading, 20)
                    .font(.title3)
                Spacer()
            }
            List(userRepoModel.userReposWithoutFork) { userRepo in
                Button(action: {
                    self.selectedRepo = userRepo
                }, label: {
                    repoCell(userRepo)
                        .onAppear {
                            if userRepo == userRepoModel.userReposWithoutFork.last {
                                userRepoModel.loadMore(with: userName)
                            }
                        }
                })
                .sheet(item: $selectedRepo, content: { selectRepo in
                    RepoDetailView(urlString: selectRepo.html_url)
                })
            }
        }
        .onAppear {
            userDetailModel.fetchUserDetail(with: userName)
            userRepoModel.fetchUserRepo(with: userName)
        }
    }
    
    var userInfoView: some View {
        HStack {
            if let url = URL(string: userDetailModel.userDetail.avatar_url) {
                ImageView(url: url)
                    .frame(width: 80, height: 80)
                    .cornerRadius(40)
                    .padding(.horizontal, 15)
            }
            VStack(alignment: .leading) {
                Text(userDetailModel.userDetail.name ?? "Anonymous")
                    .font(.title2)
                    .foregroundStyle(userDetailModel.userDetail.name != nil ? Color.primary : Color.gray)
                Text("ID: \(userDetailModel.userDetail.login)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                HStack(spacing: 4) {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width:12, height: 12)
                    Text("\(userDetailModel.userDetail.followers) Followers")
                        .font(.footnote)
                    Text("\(userDetailModel.userDetail.following) Following")
                        .font(.footnote)
                }
                if let bio = userDetailModel.userDetail.bio {
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
}
