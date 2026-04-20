//
//  WidgetPreviewSheet.swift
//  sports_hub
//

import SwiftUI

enum PreviewSize: String, CaseIterable, Identifiable {
    case small, medium
    var id: String { rawValue }
    var label: String { self == .small ? "Small" : "Medium" }
}

enum PreviewStateChoice: String, CaseIterable, Identifiable {
    case auto, live, upcoming, recent, noData
    var id: String { rawValue }
    var label: String {
        switch self {
        case .auto: "Auto"
        case .live: "Live"
        case .upcoming: "Upcoming"
        case .recent: "Recent"
        case .noData: "No data"
        }
    }
}

struct WidgetPreviewSheet: View {
    let favoriteTeams: [FavoriteTeam]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTeam: FavoriteTeam?
    @State private var size: PreviewSize = .small
    @State private var stateChoice: PreviewStateChoice = .auto
    @State private var autoState: WidgetMatchState = .noData

    private let service = SportsService.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        teamPicker
                        sizePicker
                        statePicker
                        previewCanvas
                        instructions
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Widget Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.accent)
                        .fontWeight(.semibold)
                }
            }
            .onAppear {
                if selectedTeam == nil { selectedTeam = favoriteTeams.first }
            }
            .task(id: selectedTeamKey) { await refreshAutoState() }
        }
    }

    private var selectedTeamKey: String {
        guard let t = selectedTeam else { return "" }
        return "\(t.sportRaw):\(t.teamId ?? 0)"
    }

    private var teamPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(favoriteTeams) { team in
                    Button {
                        selectedTeam = team
                    } label: {
                        HStack(spacing: 8) {
                            TeamLogo(url: team.logoURL, size: 22)
                            Text(team.name)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            selectedTeam?.id == team.id ? Theme.accent.opacity(0.2) : Theme.card,
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(selectedTeam?.id == team.id ? Theme.accent : Theme.border,
                                              lineWidth: 0.5)
                        }
                    }
                }
            }
        }
    }

    private var sizePicker: some View {
        Picker("Size", selection: $size) {
            ForEach(PreviewSize.allCases) { Text($0.label).tag($0) }
        }
        .pickerStyle(.segmented)
    }

    private var statePicker: some View {
        Picker("State", selection: $stateChoice) {
            ForEach(PreviewStateChoice.allCases) { Text($0.label).tag($0) }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    private var previewCanvas: some View {
        let entry = buildEntry()
        VStack {
            Group {
                switch size {
                case .small:  SmallWidgetView(entry: entry).frame(width: 158, height: 158)
                case .medium: MediumWidgetView(entry: entry).frame(width: 338, height: 158)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .shadow(color: .black.opacity(0.35), radius: 14, y: 6)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }

    private var instructions: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("How to add this widget")
                .font(.caption.weight(.bold))
                .foregroundStyle(.primary)
            Text("Long-press your home screen → tap + → search \"Sports Hub\" → add the widget → tap \"Edit Widget\" to pick your team.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Entry construction

    private func buildEntry() -> WidgetEntry {
        let team = selectedTeam.map {
            TeamEntity(
                name: $0.name,
                sport: $0.sport,
                teamId: $0.teamId ?? 0,
                logoURL: $0.logoURL
            )
        } ?? TeamEntity(name: "Your Team", sport: .football, teamId: 0, logoURL: nil)

        let state: WidgetMatchState = {
            switch stateChoice {
            case .auto:     return autoState
            case .live:     return .live(match: MockMatches.live)
            case .upcoming: return .upcoming(match: MockMatches.upcoming)
            case .recent:   return .recent(match: MockMatches.recent)
            case .noData:   return .noData
            }
        }()

        return WidgetEntry(date: Date(), team: team, state: state)
    }

    private func refreshAutoState() async {
        guard let team = selectedTeam else { autoState = .noData; return }
        do {
            let matches = try await service.fetchMatches(for: team)
            autoState = WidgetTimelineProvider().classify(matches: matches)
        } catch {
            autoState = .noData
        }
    }
}
