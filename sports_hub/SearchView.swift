//
//  SearchView.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    private let service = SportsService.shared
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteTeams: [FavoriteTeam]
    @State private var query = ""
    @State private var submittedQuery = ""
    @State private var results: [TeamResult] = []
    @State private var isSearching = false
    @FocusState private var fieldFocused: Bool

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SEARCH")
                        .font(.caption2.weight(.semibold))
                        .kerning(3)
                        .foregroundStyle(.secondary)
                    Text("Find a Team")
                        .font(.title.weight(.black))
                        .foregroundStyle(.primary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 20)

                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(query.isEmpty ? Color.secondary : Theme.accent)
                        .font(.subheadline.weight(.semibold))

                    TextField("", text: $query, prompt: Text("Search teams…").foregroundColor(Theme.secondary))
                        .foregroundStyle(Theme.primary)
                        .focused($fieldFocused)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onSubmit {
                            submittedQuery = query.trimmingCharacters(in: .whitespaces)
                        }

                    if !query.isEmpty {
                        Button {
                            query = ""
                            submittedQuery = ""
                            results = []
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(fieldFocused ? Theme.accent.opacity(0.4) : Theme.border, lineWidth: 0.5)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .animation(.easeInOut(duration: 0.15), value: fieldFocused)

                if isSearching {
                    HStack {
                        Spacer()
                        ProgressView()
                            .tint(Theme.secondary)
                        Spacer()
                    }
                    .padding(.top, 40)
                } else if results.isEmpty && !submittedQuery.isEmpty {
                    HStack {
                        Spacer()
                        Text("No teams found")
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.secondary.opacity(0.6))
                        Spacer()
                    }
                    .padding(.top, 40)
                } else {
                    ScrollView {
                        VStack(spacing: 1) {
                            ForEach(results) { result in
                                TeamRow(
                                    result: result,
                                    isAdded: favoriteTeams.contains {
                                        $0.name == (result.team.displayName ?? result.team.name) && $0.sportRaw == result.sport.rawValue
                                    },
                                    onAdd: { addTeam(from: result) }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                }

                Spacer(minLength: 0)
            }
        }
        .task(id: submittedQuery) {
            guard !submittedQuery.isEmpty else {
                results = []
                isSearching = false
                return
            }
            isSearching = true
            results = await service.searchTeams(query: submittedQuery)
            isSearching = false
        }
    }

    private func addTeam(from result: TeamResult) {
        let name = result.team.displayName ?? result.team.name
        let team = FavoriteTeam(
            name: name,
            sport: result.sport,
            teamId: result.team.id,
            apiName: nil,
            logoURL: result.team.logo
        )
        modelContext.insert(team)
    }
}

private struct TeamRow: View {
    let result: TeamResult
    let isAdded: Bool
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            TeamLogo(url: result.team.logo, size: 36)

            VStack(alignment: .leading, spacing: 4) {
                Text(result.team.displayName ?? result.team.name)
                    .font(.callout.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                SportBadge(sport: result.sport)
            }
            Spacer()
            Button(action: onAdd) {
                Image(systemName: isAdded ? "checkmark.circle.fill" : "plus.circle")
                    .font(.title3)
                    .foregroundStyle(isAdded ? Theme.accent : Color.secondary.opacity(0.6))
            }
            .disabled(isAdded)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Theme.card)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Theme.border)
                .frame(height: 0.5)
        }
    }
}

#Preview {
    SearchView()
        .modelContainer(for: FavoriteTeam.self, inMemory: true)
}
