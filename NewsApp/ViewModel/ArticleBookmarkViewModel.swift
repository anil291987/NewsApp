//
//  ArticleBookmarkViewModel.swift
//  NewsApp
//

import Foundation
import Combine

final class ArticleBookmarkViewModel: ObservableObject {
    @Published private(set) var bookmarks: [Article] = []
    private let bookmarksStore: BookmarkStorable

    init(bookmarksStore: BookmarkStorable = BookmarkStore(userDefaults: .standard)) {
        self.bookmarksStore = bookmarksStore
        
        self.bookmarks = bookmarksStore.loadBookmarks()
    }
    
    func isBookmarked(_ article: Article) -> Bool {
        bookmarks.first(where: { $0.title == article.title }) != nil
    }
    
    func addBookmark(_ article: Article) {
        guard !isBookmarked(article) else {
            return
        }
        bookmarks.append(article)
        
        bookmarksStore.saveBookmarks(bookmarks)
    }
    
    func removeBookmark(_ article: Article) {
        guard let index = bookmarks.firstIndex(where: { $0.title == article.title }) else {
            return
        }
        bookmarks.remove(at: index)
    }
    
    func filteredBookmarks(_ searchText: String) -> [Article] {
        if searchText.isEmpty {
            return bookmarks
        }
        return bookmarks.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.descriptionText.localizedStandardContains(searchText)
        }
    }
}


