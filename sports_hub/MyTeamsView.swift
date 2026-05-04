//
//  MyTeamsView.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import SwiftUI
import SwiftData

struct MyTeamsView: View {
    @Query private var favoriteTeams: [FavoriteTeam]
    @Environment(\.modelContext) private var modelContext
    @State private var vm = MyTeamsViewModel()

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
                                Text(vm.sortOrder.label)
                                    .font(.title.weight(.black))
                                    .foregroundStyle(.primary)
                            }
                            Spacer()
                            Button {
                                vm.isManaging = true
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
                                    vm.sortOrder = .mostRecent
                                } label: {
                                    Label("Most Recent", systemImage: vm.sortOrder == .mostRecent ? "checkmark" : "")
                                }
                                Button {
                                    vm.sortOrder = .alphabetical
                                } label: {
                                    Label("Alphabetical", systemImage: vm.sortOrder == .alphabetical ? "checkmark" : "")
                                }
                            } label: {
                                HStack(spacing: 5) {
                                    Image(systemName: "arrow.up.arrow.down")
                                        .font(.caption2.weight(.bold))
                                    Text(vm.sortOrder.label)
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
                                    FilterChip(label: "All", isSelected: vm.sportFilter == nil) {
                                        vm.sportFilter = nil
                                    }
                                    ForEach(vm.uniqueSports(from: favoriteTeams), id: \.self) { sport in
                                        FilterChip(label: sport.displayName, isSelected: vm.sportFilter == sport) {
                                            vm.sportFilter = vm.sportFilter == sport ? nil : sport
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)

                        Picker("View", selection: $vm.matchView) {
                            ForEach(MatchView.allCases) { mode in
                                Text(mode.label).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)

                        VStack(spacing: 10) {
                            ForEach(vm.displayedTeams(from: favoriteTeams)) { team in
                                MatchCard(team: team, match: vm.matchFor(team))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                }
            }
        }
        .sheet(isPresented: $vm.isManaging) {
            ManageTeamsSheet(favoriteTeams: favoriteTeams)
        }
        .task(id: favoriteTeams.map { $0.id }) {
            await vm.fetchAll(for: favoriteTeams)
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

#Preview {
    MyTeamsView()
        .modelContainer(for: FavoriteTeam.self, inMemory: true)
}
