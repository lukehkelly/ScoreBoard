//
//  MyTeamsView.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import SwiftUI

enum SortOrder {
    case mostRecent, alphabetical

    var label: String {
        switch self {
        case .mostRecent:   return "Most Recent"
        case .alphabetical: return "Alphabetical"
        }
    }
}

struct MyTeamsView: View {
    private let service = SportsService.shared
    @State private var results: [FavoriteTeam: Match?] = [:]
    @State private var sortOrder: SortOrder = .mostRecent
    @State private var sportFilter: Sport? = nil

    private var uniqueSports: [Sport] {
        var seen = Set<Sport>()
        return favoriteTeams.compactMap { team in
            seen.insert(team.sport).inserted ? team.sport : nil
        }
    }

    private var displayedTeams: [FavoriteTeam] {
        var filtered = favoriteTeams
        if let filter = sportFilter {
            filtered = filtered.filter { $0.sport == filter }
        }
        switch sortOrder {
        case .alphabetical:
            return filtered.sorted { $0.name < $1.name }
        case .mostRecent:
            return filtered.sorted { a, b in
                let dateA = (results[a] ?? nil)?.date ?? ""
                let dateB = (results[b] ?? nil)?.date ?? ""
                return dateA > dateB
            }
        }
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("MY TEAMS")
                            .font(.caption2.weight(.semibold))
                            .kerning(3)
                            .foregroundStyle(.secondary)
                        Text(sortOrder.label)
                            .font(.title.weight(.black))
                            .foregroundStyle(.primary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    .padding(.bottom, 16)

                    HStack(spacing: 8) {
                        Menu {
                            Button {
                                sortOrder = .mostRecent
                            } label: {
                                Label("Most Recent", systemImage: sortOrder == .mostRecent ? "checkmark" : "")
                            }
                            Button {
                                sortOrder = .alphabetical
                            } label: {
                                Label("Alphabetical", systemImage: sortOrder == .alphabetical ? "checkmark" : "")
                            }
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: "arrow.up.arrow.down")
                                    .font(.caption2.weight(.bold))
                                Text(sortOrder.label)
                                    .font(.caption.weight(.semibold))
                            }
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(Theme.card, in: RoundedRectangle(cornerRadius: 8))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(Theme.border, lineWidth: 0.5)
                            }
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                FilterChip(label: "All", isSelected: sportFilter == nil) {
                                    sportFilter = nil
                                }
                                ForEach(uniqueSports, id: \.self) { sport in
                                    FilterChip(label: sport.displayName, isSelected: sportFilter == sport) {
                                        sportFilter = sportFilter == sport ? nil : sport
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)

                    VStack(spacing: 10) {
                        ForEach(displayedTeams) { team in
                            MatchCard(team: team, match: results[team] ?? nil)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
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

private struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(isSelected ? Theme.background : Color.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(isSelected ? Theme.accent : Theme.card, in: RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(isSelected ? Theme.accent : Theme.border, lineWidth: 0.5)
                }
        }
    }
}

#Preview {
    MyTeamsView()
}
