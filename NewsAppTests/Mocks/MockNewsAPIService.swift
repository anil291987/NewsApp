//
//  MockNewsAPIService.swift
//  NewsApp
//

import Foundation
@testable import NewsApp

// Mock service for testing
class MockNewsAPIService: NewsAPIServiceInterface {
    var result: Result<[Article], Error>?
    
    func fetchNewsArticles(for category: NewsApp.Category) async throws -> [Article] {
        switch result {
        case .success(let articles):
            return articles
        case .failure(let error):
            throw error
        case .none:
            return []
        }
    }
}
