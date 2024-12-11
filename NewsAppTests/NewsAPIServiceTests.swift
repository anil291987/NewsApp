//
//  NewsAPIServiceTests.swift
//  NewsApp
//

import XCTest
@testable import NewsApp

final class NewsAPIServiceTests: XCTestCase {
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
    lazy var newsAPIService: NewsAPIService = {
        NewsAPIService(session: session)
    }()
        
    func test_fetchNews_whenCalled_returnsNews() async throws {
        let mockArticles = Article.mockData
        
        let newAPIResponse = NewsAPIResponse(status: "ok",
                                             totalResults: 50,
                                             articles: mockArticles,
                                             code: nil,
                                             message: nil)
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        let jsonData = try jsonEncoder.encode(newAPIResponse)
        
        let url = try XCTUnwrap(URL(string: "http://newsapi1.org"))
                
        let response = try XCTUnwrap(
            HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        
        MockURLProtocol.requestHandler =  { request in
            return (jsonData, response)
        }
        
        let articles = try await newsAPIService.fetchNewsArticles(for: .general)
        
        XCTAssertEqual(articles.count, 20)
        XCTAssertEqual(articles.first?.title, "Tesla stiahne 285-tisíc áut pre opravu tempomatov")
    }
    func test_fetchNews_whenCalled_returnsNews_Failed() async throws {
        let mockArticles = Article.mockData
        
        let newAPIResponse = NewsAPIResponse(status: "failed",
                                             totalResults: 50,
                                             articles: mockArticles,
                                             code: nil,
                                             message: nil)
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        let jsonData = try jsonEncoder.encode(newAPIResponse)
        
        let url = try XCTUnwrap(URL(string: "http://newsapi1.org"))
                
        let response = try XCTUnwrap(
            HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        
        MockURLProtocol.requestHandler =  { request in
            return (jsonData, response)
        }
        do {
            _ = try await newsAPIService.fetchNewsArticles(for: .general)
        } catch {
            XCTAssertEqual(NewsAPIError.error("An error occured").localizedDescription, error.localizedDescription)
        }
    }
}
