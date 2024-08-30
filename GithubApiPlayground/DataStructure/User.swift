//
//  User.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/28.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    var avatar_url: String
    var id: Int
    var login: String
}

struct UserDetail: Codable, Identifiable {
    var bio: String?
    var login: String = ""
    var id: Int = 0
    var avatar_url: String = ""
    var name: String?
    var followers: Int = 0
    var following: Int = 0
}

struct UserRepo: Codable, Identifiable, Equatable {
    var id: Int = 0
    var stargazers_count: Int = 0
    var name: String?
    var full_name: String?
    var `private`: Bool = false
    var html_url: String = ""
    var description: String?
    var fork: Bool = false
    var language: String?
}
