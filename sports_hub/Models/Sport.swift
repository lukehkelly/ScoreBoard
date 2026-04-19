//
//  Sport.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation

enum Sport: String, Codable, Hashable {
    case football
    case nfl
    case ncaaFootball
    case nhl
    case nba
    case ncaaBasketball
    case mlb
    case ncaaBaseball

    var matchesURL: String {
        switch self {
        case .football:       return "https://soccer.highlightly.net/matches"
        case .nfl:            return "https://american-football.highlightly.net/matches"
        case .ncaaFootball:   return "https://american-football.highlightly.net/matches"
        case .nhl:            return "https://nhl.highlightly.net/matches"
        case .nba:            return "https://nba.highlightly.net/matches"
        case .ncaaBasketball: return "https://nba.highlightly.net/matches"
        case .mlb:            return "https://baseball.highlightly.net/matches"
        case .ncaaBaseball:   return "https://baseball.highlightly.net/matches"
        }
    }

    var displayName: String {
        switch self {
        case .football:       return "Soccer"
        case .nfl:            return "NFL"
        case .ncaaFootball:   return "NCAA Football"
        case .nhl:            return "NHL"
        case .nba:            return "NBA"
        case .ncaaBasketball: return "NCAA Basketball"
        case .mlb:            return "MLB"
        case .ncaaBaseball:   return "NCAA Baseball"
        }
    }
}
