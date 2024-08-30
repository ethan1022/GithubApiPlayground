//
//  UserRepoModel.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/29.
//

import Foundation

@MainActor
class UserRepoModel: ObservableObject {
    @Published var userReposWithoutFork: [UserRepo]?
    @Published var error: Error?
    var page = 1
    
    func fetchUserRepo(with userName: String, page: Int = 1) {
        guard let userRepoRequest = UserRequest().userRepoRequest(userName: userName, page: page) else {
            return
        }
        Task {
            do {
                let userRepos = try await ApiService.shared.fetchData(with: userRepoRequest, type: [UserRepo].self)
                if userReposWithoutFork != nil {
                    self.userReposWithoutFork?.append(contentsOf: self.getRepoWithoutFork(userRepos))
                } else {
                    self.userReposWithoutFork = self.getRepoWithoutFork(userRepos)
                }
            } catch {
                print("error \(error)")
                self.error = error
            }
        }
    }
    
    func loadMore(with userName: String) {
        page += 1
        fetchUserRepo(with: userName, page: page)
    }
    
    func getRepoWithoutFork(_ repos: [UserRepo]) -> [UserRepo] {
        repos.filter { $0.fork == false }
    }
}
