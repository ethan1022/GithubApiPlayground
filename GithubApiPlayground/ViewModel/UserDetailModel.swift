//
//  UserDetailModel.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/29.
//

import Foundation

@MainActor
class UserDetailModel: ObservableObject {
    @Published var userDetail: UserDetail?
    @Published var error: Error?
    
    func fetchUserDetail(with userName: String) {
        guard let userDetailRequest = UserRequest().userInfoRequest(userName: userName) else {
            return
        }
        
        Task {
            do {
                let userDetail = try await ApiService.shared.fetchData(with: userDetailRequest, type: UserDetail.self)
                self.userDetail = userDetail
            } catch {
                print("error: \(error)")
                self.error = error
            }
        }
    }
}
