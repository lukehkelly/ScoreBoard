//
//  ContentView.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import SwiftUI

struct ContentView: View {
    private let service = SportsService.shared
    @State private var results: [FavoriteTeam: Match?] = [:]
    var body: some View {
        List(favoriteTeams) { team in
            VStack(alignment: .leading) {
                Text(team.name)
                    .font(.headline)
                Text(team.sport.displayName)
                    .font(.subheadline)
                if let match = results[team] as? Match {
                    Text("\(match.homeTeam.name) vs \(match.awayTeam.name)")
                    Text(match.date)
                    if let state = match.state {
                        Text(state.description)
                        if let score = state.score?.displayString {
                            Text(score)
                        }
                    }
                } else {
                    Text("No recent matches found")
                }
            }
        }
        .task {
            await fetchAll()
        }
    }

    private func fetchAll() async {
        await withTaskGroup(of: (FavoriteTeam, Match?).self) { group in
            for team in favoriteTeams {
                group.addTask {
                    do {
                        let match = try await service.fetchMatches(for: team).first
                        return (team, match)
                    } catch {
                        print("Error fetching \(team.name): \(error)")
                        return (team, nil)
                    }
                }
            }
            for await (team, match) in group {
                results[team] = match
            }
        }
    }
}

#Preview {
    ContentView()
}
