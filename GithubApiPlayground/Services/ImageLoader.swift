//
//  ImageLoader.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/30.
//

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

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 60
        let session = URLSession(configuration: configuration)
        session.dataTaskPublisher(for: url)
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
