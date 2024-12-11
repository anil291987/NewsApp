//
//  NewsAPI.swift
//  NewsApp
//

import Foundation

protocol NewsAPIServiceInterface {
    func fetchNewsArticles(for category: Category) async throws -> [Article]
}

struct NewsAPIService: NewsAPIServiceInterface {
    
    private enum LocalConstants {
        static let apiKey = "8a5f2fed933340d2ab84f6383152ecf1"
        static let baseURL = "https://newsapi.org"
        static let apiVersion = "v2"
        static let everyThings = "everything"
        static let topHeadlines = "top-headlines"
    }
    
    private let session: URLSession
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
        
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchNewsArticles(for category: Category) async throws -> [Article] {
        guard let url = buildNewsURL(for: category) else {
            throw NewsAPIError.invalidURL
        }
        return try await fetchArticles(from: url)
    }
}

private extension NewsAPIService {
    
    func fetchArticles(from url: URL) async throws -> [Article] {
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw NewsAPIError.invalidResponse
        }
        
        switch response.statusCode {
        case 200...299:
            let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
            if apiResponse.status == "ok" {
                return apiResponse.articles ?? []
            } else {
                throw NewsAPIError.error(apiResponse.message ?? "An error occured")
            }
        default:
            throw NewsAPIError.error("A server error occured")
        }
    }
    
    func buildNewsURL(for category: Category) -> URL? {
        var url = "\(LocalConstants.baseURL)/\(LocalConstants.apiVersion)/\(LocalConstants.topHeadlines)"
        url += "?apiKey=\(LocalConstants.apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)"
        
        return URL(string: url)
    }
}
