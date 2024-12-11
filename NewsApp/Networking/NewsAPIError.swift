//
//  NewsAPIError.swift
//  NewsApp
//


import Foundation

enum NewsAPIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case error(String)
}
