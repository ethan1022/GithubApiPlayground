//
//  ApiService.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/27.
//

import Foundation

class ApiService {
    static let shared = ApiService()
    
    let baseUrl = "https://api.github.com/"
    
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 60
        return URLSession(configuration: configuration)
    }
    
    func fetchData<T>(with urlRequest: URLRequest, type: T.Type) async throws -> T where T: Decodable {
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let model = try JSONDecoder().decode(type, from: data)
        return model
    }
}
