//
//  Untitled.swift
//  NewsApp
//


import Foundation
@testable import NewsApp

// Mock implementation of BookmarkStorable
class MockBookmarkStore: BookmarkStorable {
    private var bookmarks: [String: Data] = [:]
    
    func loadBookmarks<T: Codable>() -> [T] {
        if let bookmarksData = bookmarks[AppConstants.bookmarksKey],
           let bookmarkes = try? JSONDecoder().decode([T].self, from: bookmarksData) {
            return bookmarkes
        } else {
            return []
        }
    }
    
    func saveBookmarks<T: Codable>(_ bookmarks: [T]) {
        if let encodedBookmarks = try? JSONEncoder().encode(bookmarks) {
            self.bookmarks[AppConstants.bookmarksKey] = encodedBookmarks
        }
    }
}
