//
//  UserDetailModel.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/29.
//

import Foundation

class UserDetailModel: ObservableObject {
    @Published var userDetail = UserDetail()
    
    func fetchUserDetail(with userName: String) {
        guard let userDetailRequest = UserRequest().userInfoRequest(userName: userName) else {
            return
        }
        
        ApiService.shared.fetchData(with: userDetailRequest, type: UserDetail.self) { result in
            switch result {
            case .success(let userDetail):
                print("userDetail \(userDetail)")
                self.userDetail = userDetail
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
}
