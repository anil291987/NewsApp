//
//  BookmarkStore.swift
//  NewsApp
//

import Foundation

protocol BookmarkStorable {
    func loadBookmarks<T: Codable>() -> [T]
    
    func saveBookmarks<T: Codable>(_ bookmarks: [T])
}

final class BookmarkStore: BookmarkStorable {

    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func loadBookmarks<T: Codable>() -> [T] {
        if let bookmarksData = userDefaults.object(forKey: AppConstants.bookmarksKey) as? Data,
           let bookmarkes = try? JSONDecoder().decode([T].self, from: bookmarksData) {
            return bookmarkes
        } else {
            return []
        }
    }
    
    func saveBookmarks<T: Codable>(_ bookmarks: [T]) {
        if let encodedBookmarks = try? JSONEncoder().encode(bookmarks) {
            userDefaults.set(encodedBookmarks, forKey: AppConstants.bookmarksKey)
        }
    }
}
