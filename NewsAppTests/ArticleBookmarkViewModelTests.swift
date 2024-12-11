//
//  Untitled.swift
//  NewsApp
//

import Foundation
import XCTest
@testable import NewsApp


final class ArticleBookmarkViewModelTests: XCTestCase {
    var viewModel: ArticleBookmarkViewModel!
    var mockBookmarkStore: MockBookmarkStore!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockBookmarkStore = MockBookmarkStore()
        viewModel = ArticleBookmarkViewModel(bookmarksStore: mockBookmarkStore)
    }
    
    func test_initial_bookmarks() {
        XCTAssertEqual(viewModel.bookmarks, mockBookmarkStore.loadBookmarks())
    }
    
    func test_is_bookmarked() {
        let article = Article(source: Source(name: "Times of India"),
                              title: "Test Article 1",
                              url: "https://www.google.com",
                              publishedAt: Date.now,
                              author: "Published by Me",
                              description: "This is test article description",
                              urlToImage: "https://picsum.photos/200"
        )
        viewModel.addBookmark(article)
        XCTAssertTrue(viewModel.isBookmarked(article))
    }
    
    func test_add_bookmark() {
        let article = Article(source: Source(name: "Times of India"),
                              title: "Test Article 1",
                              url: "https://www.google.com",
                              publishedAt: Date.now,
                              author: "Published by Me",
                              description: "This is test article description",
                              urlToImage: "https://picsum.photos/200"
        )
        viewModel.addBookmark(article)
        XCTAssertTrue(viewModel.isBookmarked(article))
        XCTAssertEqual(viewModel.bookmarks.count, 1)
    }
    
    func test_addBookmark_already_bookmarked() {
        let article = Article(source: Source(name: "Times of India"),
                              title: "Test Article 1",
                              url: "https://www.google.com",
                              publishedAt: Date.now,
                              author: "Published by Me",
                              description: "This is test article description",
                              urlToImage: "https://picsum.photos/200"
        )
        viewModel.addBookmark(article)
        viewModel.addBookmark(article)
        
        XCTAssertEqual(viewModel.bookmarks.count, 1)
    }
    
    func test_removeBookmark() {
        let article = Article(source: Source(name: "Times of India"),
                              title: "Test Article 1",
                              url: "https://www.google.com",
                              publishedAt: Date.now,
                              author: "Published by Me",
                              description: "This is test article description",
                              urlToImage: "https://picsum.photos/200"
        )
        viewModel.addBookmark(article)
        viewModel.removeBookmark(article)
        XCTAssertFalse(viewModel.isBookmarked(article))
        XCTAssertEqual(viewModel.bookmarks.count, 0)
    }
    
    func test_filteredBookmarks_emptySearchText() {
        let article1 = Article(source: Source(name: "Times of India"),
                               title: "Test Article 1",
                               url: "https://www.google.com",
                               publishedAt: Date.now,
                               author: "Published by Me",
                               description: "This is test article description",
                               urlToImage: "https://picsum.photos/200"
        )
        let article2 = Article(source: Source(name: "Times of India"),
                               title: "Test Article 2",
                               url: "https://www.google.com",
                               publishedAt: Date.now.addingTimeInterval(60),
                               author: "Published by Me",
                               description: "This is test article description",
                               urlToImage: "https://picsum.photos/300"
        )
        viewModel.addBookmark(article1)
        viewModel.addBookmark(article2)
        
        let filtered = viewModel.filteredBookmarks("")
        XCTAssertEqual(filtered.count, 2)
    }
    
    func test_filteredBookmarks_searchText() {
        let article1 = Article(source: Source(name: "Times of India"),
                               title: "Test Article 1",
                               url: "https://www.google.com",
                               publishedAt: Date.now,
                               author: "Published by Me",
                               description: "This is test article description",
                               urlToImage: "https://picsum.photos/200"
        )
        let article2 = Article(source: Source(name: "Times of India"),
                               title: "Test Article 2",
                               url: "https://www.google.com",
                               publishedAt: Date.now.addingTimeInterval(60),
                               author: "Published by Me",
                               description: "This is test article description",
                               urlToImage: "https://picsum.photos/300"
        )
        viewModel.addBookmark(article1)
        viewModel.addBookmark(article2)
        
        let filtered = viewModel.filteredBookmarks("Article 1")
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.title, "Test Article 1")
    }
}
