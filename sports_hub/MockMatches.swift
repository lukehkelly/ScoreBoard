//
//  MockMatches.swift
//  sports_hub
//
//  Hardcoded Match values used only by the in-app widget preview sheet
//  so every widget state can be rendered regardless of real data.
//

import Foundation

enum MockMatches {
    static let live: Match = decode("""
    {
      "id": 1,
      "date": "\(iso(Date()))",
      "homeTeam": { "id": 11, "name": "Kansas City Chiefs", "logo": null },
      "awayTeam": { "id": 12, "name": "Buffalo Bills", "logo": null },
      "state": {
        "description": "In Progress - 2nd Quarter",
        "score": { "current": "14 - 10" }
      }
    }
    """)

    static let upcoming: Match = decode("""
    {
      "id": 2,
      "date": "\(iso(Date().addingTimeInterval(60 * 60 * 24 * 2)))",
      "homeTeam": { "id": 11, "name": "Kansas City Chiefs", "logo": null },
      "awayTeam": { "id": 13, "name": "Denver Broncos", "logo": null },
      "state": { "description": "Scheduled" }
    }
    """)

    static let recent: Match = decode("""
    {
      "id": 3,
      "date": "\(iso(Date().addingTimeInterval(-60 * 60 * 24 * 3)))",
      "homeTeam": { "id": 11, "name": "Kansas City Chiefs", "logo": null },
      "awayTeam": { "id": 14, "name": "Las Vegas Raiders", "logo": null },
      "state": {
        "description": "Final",
        "score": { "current": "27 - 20" }
      }
    }
    """)

    private static func iso(_ date: Date) -> String {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f.string(from: date)
    }

    private static func decode(_ json: String) -> Match {
        let data = json.data(using: .utf8)!
        return try! JSONDecoder().decode(Match.self, from: data)
    }
}
