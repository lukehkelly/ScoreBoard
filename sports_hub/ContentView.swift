//
//  ContentView.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import SwiftUI

struct ContentView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.09, green: 0.09, blue: 0.11, alpha: 1)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().tintColor = UIColor(red: 1.0, green: 0.72, blue: 0.15, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = UIColor(white: 0.38, alpha: 1)
    }

    var body: some View {
        TabView {
            MyTeamsView()
                .tabItem { Label("My Teams", systemImage: "star.fill") }
            ScoresView()
                .tabItem { Label("Scores", systemImage: "sportscourt.fill") }
            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
