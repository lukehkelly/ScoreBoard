//
//  FavoriteTeam.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import Foundation
import SwiftData

@Model
class FavoriteTeam {
    var name: String
    var sportRaw: String
    var teamId: Int?
    var apiName: String?
    var logoURL: String?

    var sport: Sport {
        get { Sport(rawValue: sportRaw) ?? .football }
        set { sportRaw = newValue.rawValue }
    }

    init(name: String, sport: Sport, teamId: Int? = nil, apiName: String? = nil, logoURL: String? = nil) {
        self.name = name
        self.sportRaw = sport.rawValue
        self.teamId = teamId
        self.apiName = apiName
        self.logoURL = logoURL
    }
}
