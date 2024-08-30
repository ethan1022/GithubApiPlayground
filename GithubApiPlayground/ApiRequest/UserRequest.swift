//
//  UserRequest.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/28.
//

import Foundation

class UserRequest: ApiRequest {
    func userListRequest(since id: Int = 1) -> URLRequest? {
        var components = URLComponents(string: ApiService.shared.baseUrl + "users")
        let queryParams = [ "since": "\(id)"]
        components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components?.url else {
            print("urlString is not valid")
            return nil
        }
        return getRequest(url)
    }
    
    func userInfoRequest(userName: String) -> URLRequest? {
        guard let url = URL(string: ApiService.shared.baseUrl + "users/\(userName)") else {
            print("urlString is not valid")
            return nil
        }
        return getRequest(url)
    }
    
    func userRepoRequest(userName: String, page: Int = 1) -> URLRequest? {
        var components = URLComponents(string: ApiService.shared.baseUrl + "users/\(userName)/repos")
        let queryParams = [ "page": "\(page)"]
        components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = components?.url else {
            print("urlString is not valid")
            return nil
        }
        return getRequest(url)
    }
}
