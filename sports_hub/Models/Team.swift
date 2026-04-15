//
//  Team.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation

struct Team: Decodable {
    let id: Int
    let name: String
    let displayName: String?
    let logo: String?
}
