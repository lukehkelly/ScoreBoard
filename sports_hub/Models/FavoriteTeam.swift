//
//  FavoriteTeam.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation

struct FavoriteTeam: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let sport: Sport
    let teamId: Int?
    let apiName: String?
}

let favoriteTeams: [FavoriteTeam] = [
    FavoriteTeam(name: "Liverpool",           sport: .football,       teamId: nil,   apiName: nil),
    FavoriteTeam(name: "Carolina Panthers",   sport: .nfl,            teamId: 92741, apiName: nil),
    FavoriteTeam(name: "UNC Tarheels",        sport: .ncaaBasketball, teamId: 11092, apiName: nil),
    FavoriteTeam(name: "Carolina Hurricanes", sport: .nhl,            teamId: nil,   apiName: "Hurricanes")
]
