//
//  SportsServiceError.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation

enum SportsServiceError: Error {
    case invalidURL
    case networkError
    case codingError
    case unknown
}
