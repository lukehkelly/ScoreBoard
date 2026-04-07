//
//  Match.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation

struct Match: Identifiable, Decodable {
    let id: Int
    let date: String
    let homeTeam: Team
    let awayTeam: Team
    let state: MatchState?
}

struct MatchesResponse: Decodable {
    let data: [Match]
}
