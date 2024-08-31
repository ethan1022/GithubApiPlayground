//
//  GithubApiPlaygroundApp.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/27.
//

import SwiftUI

@main
struct GithubApiPlaygroundApp: App {

    var body: some Scene {
        WindowGroup {
            UserListView()
                .environmentObject(NetworkMonitor())
        }
    }
}
