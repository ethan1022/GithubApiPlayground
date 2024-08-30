//
//  ImageView.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/29.
//

import SwiftUI

struct ImageView: View {
    @StateObject private var loader: ImageLoader
    
    init(url: URL) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView("")
            }
        }
    }
}
