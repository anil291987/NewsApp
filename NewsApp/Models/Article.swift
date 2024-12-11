//
//  Untitled.swift
//  NewsApp
//


import Foundation


fileprivate var relativeDateFormatter = RelativeDateTimeFormatter()

struct Article {
    let id = UUID()
    
    let source: Source
    let title: String
    let url: String
    let publishedAt: Date
    
    let author: String?
    let description: String?
    let urlToImage: String?
    
    enum CodingKeys: CodingKey {
        case source
        case title
        case url
        case publishedAt
        case author
        case description
        case urlToImage
    }
    
    var authorText: String {
        author ?? ""
    }
    
    var descriptionText: String {
        description ?? ""
    }
    
    var captionText: String {
        "\(source.name) \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
    
    var articleURL: URL? {
        guard let url = URL(string: url) else {
            return nil
        }
        return url
    }
    
    var articleImageURL: URL? {
        guard let imageURLString = urlToImage else {
            return nil
        }
        return URL(string: imageURLString)
    }
    
    init(source: Source, title: String, url: String, publishedAt: Date, author: String?, description: String?, urlToImage: String?) {
        self.source = source
        self.title = title
        self.url = url
        self.publishedAt = publishedAt
        self.author = author
        self.description = description
        self.urlToImage = urlToImage
    }
}
extension Article: Codable {}
extension Article: Equatable {}
extension Article: Identifiable {}

extension Article {
    static var mockData: [Article] {
        guard let previewDataURL = Bundle.main.url(
            forResource: AppConstants.mockfileName,
            withExtension: AppConstants.mockfileExtension
        ), let data = try? Data(
            contentsOf: previewDataURL
        ) else {
            return []
        }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        let apiResponse = try? jsonDecoder.decode(NewsAPIResponse.self, from: data)
        return apiResponse?.articles ?? []
    }
    
}

struct Source {
    let name: String
}

extension Source: Codable {}
extension Source: Equatable {}
