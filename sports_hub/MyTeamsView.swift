//
//  MyTeamsView.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import SwiftUI
import SwiftData

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
    @Query private var favoriteTeams: [FavoriteTeam]
    @Environment(\.modelContext) private var modelContext
    @State private var results: [PersistentIdentifier: Match?] = [:]
    @State private var sortOrder: SortOrder = .mostRecent
    @State private var sportFilter: Sport? = nil
    @State private var isManaging = false

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
                let dateA = (results[a.id] ?? nil)?.date ?? ""
                let dateB = (results[b.id] ?? nil)?.date ?? ""
                return dateA > dateB
            }
        }
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            if favoriteTeams.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("MY TEAMS")
                                    .font(.caption2.weight(.semibold))
                                    .kerning(3)
                                    .foregroundStyle(.secondary)
                                Text(sortOrder.label)
                                    .font(.title.weight(.black))
                                    .foregroundStyle(.primary)
                            }
                            Spacer()
                            Button {
                                isManaging = true
                            } label: {
                                Text("Manage")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(Theme.accent)
                            }
                            .padding(.bottom, 4)
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
                                MatchCard(team: team, match: results[team.id] ?? nil)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                }
            }
        }
        .sheet(isPresented: $isManaging) {
            ManageTeamsSheet(favoriteTeams: favoriteTeams)
        }
        .task(id: favoriteTeams.map { $0.id }) {
            results = [:]
            await fetchAll()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "star.slash")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("No teams yet")
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)
            Text("Search for a team and tap + to add it here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
    }

    private func fetchAll() async {
        await withTaskGroup(of: (PersistentIdentifier, Match?).self) { group in
            for team in favoriteTeams {
                let teamID = team.id
                group.addTask {
                    do {
                        let match = try await service.fetchMatches(for: team).first
                        return (teamID, match)
                    } catch {
                        return (teamID, nil)
                    }
                }
            }
            for await (teamID, match) in group {
                results[teamID] = match
            }
        }
    }
}

private struct ManageTeamsSheet: View {
    let favoriteTeams: [FavoriteTeam]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                List {
                    ForEach(favoriteTeams) { team in
                        HStack(spacing: 14) {
                            TeamLogo(url: team.logoURL, size: 36)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(team.name)
                                    .font(.callout.weight(.bold))
                                    .foregroundStyle(.primary)
                                SportBadge(sport: team.sport)
                            }
                            Spacer()
                            Button {
                                modelContext.delete(team)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(.red)
                            }
                        }
                        .padding(.vertical, 6)
                        .listRowBackground(Theme.card)
                        .listRowSeparatorTint(Theme.border)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Manage Teams")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.accent)
                        .fontWeight(.semibold)
                }
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
        .modelContainer(for: FavoriteTeam.self, inMemory: true)
}
