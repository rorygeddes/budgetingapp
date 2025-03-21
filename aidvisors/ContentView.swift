//
//  ContentView.swift
//  aidvisors
//
//  Created by Rory Geddes on 2025-03-21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BudgetListView()
                .tabItem {
                    Label("Budgets", systemImage: "dollarsign.circle")
                }
            
            TransactionsView()
                .tabItem {
                    Label("Transactions", systemImage: "arrow.left.arrow.right")
                }
            
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.pie")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct DashboardView: View {
    var body: some View {
        NavigationView {
            Text("Dashboard coming soon!")
                .navigationTitle("Dashboard")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    Text("Profile")
                    Text("Notifications")
                    Text("Privacy")
                }
                
                Section(header: Text("App")) {
                    Text("Appearance")
                    Text("Data & Storage")
                    Text("About")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
