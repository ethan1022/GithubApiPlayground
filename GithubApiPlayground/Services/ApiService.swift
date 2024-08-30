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
    
    func fetchData<T>(with urlRequest: URLRequest, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        let task = session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    print("Error: \(error)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = NetworkError.customError(description: "no response")
                    completion(.failure(error))
                    print("No response error: \(error)")
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    let error = NetworkError.serverError(statusCode: httpResponse.statusCode)
                    completion(.failure(error))
                    print("Server error: \(error)")
                    return
                }

                if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                   let data = data,
                   let model = self.handleReceivedData(type, data: data) {
                    completion(.success(model))
                }
            }
        }

        task.resume()
    }
    
    private func handleReceivedData<T>(_ type: T.Type, data: Data) -> T? where T: Decodable {
        do {
            let model = try JSONDecoder().decode(type, from: data)
            return model
        } catch {
            print("JSON Error: \(error.localizedDescription)")
            return nil
        }
    }
}

enum NetworkError: Error {
    case urlError
    case serverError(statusCode: Int)
    case customError(description: String)
}

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: Image?
    private var cancellables: Set<AnyCancellable> = []
    private let url: URL
    static let imageCache = NSCache<NSURL, UIImage>()

    init(url: URL) {
        self.url = url
        loadImage()
    }

    func loadImage() {
        if let cachedImage = ImageLoader.imageCache.object(forKey: url as NSURL) {
            image = Image(uiImage: cachedImage)
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadedImage in
                guard let self = self, let downloadedImage = downloadedImage else {
                    return
                }
                self.image = Image(uiImage: downloadedImage)
                ImageLoader.imageCache.setObject(downloadedImage, forKey: self.url as NSURL)
            }
            .store(in: &cancellables)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
