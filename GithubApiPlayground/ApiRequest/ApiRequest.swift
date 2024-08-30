//
//  ApiRequest.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/28.
//

import Foundation

enum HttpMethod: String {
    case get, push, delete, post
}

protocol ApiRequest {
    func getRequest(_ url: URL) -> URLRequest?
}

extension ApiRequest {
    func getRequest(_ url: URL) -> URLRequest? {
        guard let path = Bundle.main.url(forResource: "GithubPersonalToken", withExtension: "txt"),
              let data = try? Data(contentsOf: path) else {
            print("there is no such file")
            return nil
        }

        guard let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        request.setValue("GithubApiPlayground", forHTTPHeaderField: "User-Agent")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        return request
    }
}
