//
//  MockURLSession.swift
//  NewsApp
//

import Foundation
import XCTest
@testable import NewsApp

final class MockURLProtocol: URLProtocol {

    static var requestHandler: ((URLRequest) throws -> (Data, URLResponse))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    override func startLoading() {
        guard let requestHandler = MockURLProtocol.requestHandler else {
            XCTFail("Request handler not set")
            return
        }
        do {
            let (data, response) = try requestHandler(request)
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        } catch {
            XCTFail("Error occurred: \(error)")
        }
    }
    
    override func stopLoading() {
        //
    }
}
