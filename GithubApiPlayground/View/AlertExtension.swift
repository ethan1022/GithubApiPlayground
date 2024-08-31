//
//  AlertExtension.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/31.
//

import SwiftUI

extension Alert {
    static func error(_ error: Error?) -> Alert {
        Alert(title: Text("Error"),
              message: Text(error?.localizedDescription ?? "Unknown error"),
              dismissButton: .default(Text("OK")))
    }
}
