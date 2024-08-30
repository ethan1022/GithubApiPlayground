//
//  UserRepoModel.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/29.
//

import Foundation

class UserRepoModel: ObservableObject {
    @Published var userReposWithoutFork = [UserRepo]()
    var page = 1
    
    func fetchUserRepo(with userName: String, page: Int = 1) {
        guard let userRepoRequest = UserRequest().userRepoRequest(userName: userName, page: page) else {
            return
        }
        
        ApiService.shared.fetchData(with: userRepoRequest, type: [UserRepo].self) { result in
            switch result {
            case .success(let userRepos):
                print("userRepos \(userRepos)")
                self.userReposWithoutFork.append(contentsOf: self.getRepoWithoutFork(userRepos))
            case .failure(let error):
                print("error \(error)")
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
