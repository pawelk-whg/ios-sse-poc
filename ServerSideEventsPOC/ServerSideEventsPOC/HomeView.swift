//
//  HomeView.swift
//  SSE POC
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            ContentView(viewModel: LiveContentViewModel())
                .tabItem {
                    Label("SSE Showcase", systemImage: "lightbulb.fill")
                }

            SettingsView(viewModel: LiveSettingsViewModel())
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
