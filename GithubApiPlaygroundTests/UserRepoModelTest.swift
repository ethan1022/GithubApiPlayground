//
//  UserRepoModelTest.swift
//  GithubApiPlaygroundTests
//
//  Created by Ethan Wen on 2024/8/31.
//

import XCTest
@testable import GithubApiPlayground

@MainActor
final class UserRepoModelTest: XCTestCase {
    
    var allUserRepos = [UserRepo]()
    
    override func setUpWithError() throws {
        allUserRepos = [UserRepo(fork: true), UserRepo(fork: true), UserRepo(fork: false), UserRepo(fork: true)]
    }

    override func tearDownWithError() throws {}

    func testRepoFilterMethod() throws {
        let allUserReposWithoutFork = UserRepoModel().getRepoWithoutFork(allUserRepos)
        XCTAssertTrue(allUserReposWithoutFork.count == 1)
    }
}
