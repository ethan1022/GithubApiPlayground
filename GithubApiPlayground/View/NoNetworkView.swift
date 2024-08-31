//
//  NoNetworkView.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/31.
//

import SwiftUI

struct NoNetworkView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 10) {
                Image(systemName: "wifi.slash")
                    .resizable()
                    .frame(width: 25, height: 25)
                Text("There is no network in your area.\nPlease find a good place")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .background(Color.primary.colorInvert())
        .ignoresSafeArea(.all)
    }
}
