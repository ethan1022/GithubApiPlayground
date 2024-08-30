//
//  UserModel.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/28.
//

import Foundation

@MainActor
class UserListModel: ObservableObject {
    @Published var users: [User]?
    @Published var error: Error?
    
    func fetchUsersList(since id: Int) {
        guard let usersRequest = UserRequest().userListRequest(since: id) else {
            return
        }
        Task {
            do {
                let users = try await ApiService.shared.fetchData(with: usersRequest, type: [User].self)
                if self.users != nil {
                    self.users?.append(contentsOf: users)
                } else {
                    self.users = users
                }
            } catch {
                print("error: \(error)")
                self.error = error
            }
        }
    }
}
