//
//  NewsAppTests.swift
//  NewsAppTests
//

import XCTest
import Combine
@testable import NewsApp

final class ArticleNewsViewModelTests: XCTestCase {
    var viewModel: ArticleNewsViewModel!
    var mockNewsAPIService: MockNewsAPIService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockNewsAPIService = MockNewsAPIService()
        viewModel = ArticleNewsViewModel(
            newAPI: mockNewsAPIService,
            selectedCategory: .general
        )
    }

    func testInitialStateIsLoading() {
        XCTAssertEqual(viewModel.state, .loading)
    }
    
    func testEmptyMockNewsAPISerfice() async {
        viewModel = ArticleNewsViewModel(
            newAPI: nil,
            selectedCategory: .general
        )
        await viewModel.fetchNews()
        XCTAssertEqual(viewModel.state, .loading)
    }
    
    func testFetchNewsSuccess() async {
        let articles = [
            Article(source: Source(name: "Times of India"),
                                title: "Test Article 1",
                                url: "https://www.google.com",
                                publishedAt: Date.now,
                                author: "Published by Me",
                                description: "This is test article description",
                                urlToImage: "https://picsum.photos/200"
                   ),
            Article(source: Source(name: "Times of India"),
                                title: "Test Article 2",
                                url: "https://www.google.com",
                                publishedAt: Date.now.addingTimeInterval(60),
                                author: "Published by Me",
                                description: "This is test article description",
                                urlToImage: "https://picsum.photos/300"
                   )
        ]
        mockNewsAPIService.result = .success(articles)
        
        await viewModel.fetchNews()
        
        if case let .loaded(loadedArticles) = viewModel.state {
            XCTAssertEqual(loadedArticles, articles)
            XCTAssertEqual(.loaded(loadedArticles), viewModel.state)
        } else {
            XCTFail("Expected state to be loaded")
        }
    }
    
    func testFetchNewsFailure() async {
        let error = CustomError.someError("Test Error")
        mockNewsAPIService.result = .failure(error)
        
        await viewModel.fetchNews()
        
        if case let .failure(receivedError) = viewModel.state {
            XCTAssertEqual(.failure(receivedError), viewModel.state)
            XCTAssertEqual(receivedError.localizedDescription, error.localizedDescription)
        } else {
            XCTFail("Expected state to be failure")
        }
    }
    
    func testRemovedOfEmptyArticle() async {
        var articles = [
            Article(source: Source(name: "Times of India"),
                                title: "Test Article 1",
                                url: "https://www.google.com",
                                publishedAt: Date.now,
                                author: "Published by Me",
                                description: "This is test article description",
                                urlToImage: "https://picsum.photos/200"),
            Article(source: Source(name: "Times of India"),
                                title: "[Removed]",
                                url: "https://www.google.com",
                                publishedAt: Date.now.addingTimeInterval(60),
                                author: "Published by Me",
                                description: "This is test article description",
                                urlToImage: "https://picsum.photos/300")
        ]
        mockNewsAPIService.result = .success(articles)
        
        await viewModel.fetchNews()
        
        if case let .loaded(loadedArticles) = viewModel.state {
            articles.remove(at: 1)
            XCTAssertEqual(loadedArticles, articles)
        } else {
            XCTFail("Expected state to be loaded")
        }
    }
    
    func testLoadArticlesSuccess() async {
        let articles = [
            Article(source: Source(name: "Times of India"),
                                title: "Test Article 1",
                                url: "https://www.google.com",
                                publishedAt: Date.now,
                                author: "Published by Me",
                                description: "This is test article description",
                                urlToImage: "https://picsum.photos/200"
                   ),
            Article(source: Source(name: "Times of India"),
                                title: "Test Article 2",
                                url: "https://www.google.com",
                                publishedAt: Date.now.addingTimeInterval(60),
                                author: "Published by Me",
                                description: "This is test article description",
                                urlToImage: "https://picsum.photos/300"
                   )
        ]
        viewModel = ArticleNewsViewModel(
            articles: articles,
            selectedCategory: .general
        )
        
        if case let .loaded(loadedArticles) = viewModel.state {
            XCTAssertEqual(loadedArticles, articles)
        } else {
            XCTFail("Expected state to be loaded")
        }
    }
}
