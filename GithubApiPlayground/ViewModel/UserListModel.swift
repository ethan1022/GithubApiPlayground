//
//  UserModel.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/28.
//

import Foundation

class UserListModel: ObservableObject {
    @Published var users = [User]()
    
    func fetchUsersList(since id: Int) {
        guard let usersRequest = UserRequest().userListRequest(since: id) else {
            return
        }
        
        ApiService.shared.fetchData(with: usersRequest, type: [User].self) { result in
            switch result {
            case .success(let users):
                self.users.append(contentsOf: users)
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
}
