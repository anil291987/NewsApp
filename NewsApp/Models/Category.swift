//
//  Category.swift
//  NewsApp
//

import Foundation

enum Category: String, CaseIterable {
    case general
    case business
    case technology
    case science
    case sports
    case entertainment
    case health
    
    var title: String {
        if self == .general {
            return AppConstants.generalCategoryTitle
        }
        return rawValue.capitalized
    }
}

extension Category: Identifiable {
    var id: Self {
        self
    }
}
