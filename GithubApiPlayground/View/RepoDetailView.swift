//
//  RepoDetailView.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/29.
//

import SwiftUI
import WebKit

struct RepoDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var webView: WKWebView?

    var urlString: String
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center, spacing: 5) {
                    Button(action: {
                        dismiss.callAsFunction()
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.primary)
                    })
                    .padding([.leading, .top], 15)
                    Button(action: {
                        _webView.wrappedValue?.goBack()
                    }, label: {
                        Image(systemName: "lessthan")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.primary)
                    })
                    .padding([.leading, .top], 15)
                    Spacer()
                }
                CustomWebView(urlString: urlString, webView: $webView)
            }
        }
    }
}

#Preview {
    RepoDetailView(urlString: "https://www.apple.com/")
}
