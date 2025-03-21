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
    @State private var apiURL: String = UserDefaults.standard.string(forKey: "api_base_url") ?? APIService.shared.baseURL
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("API Configuration")) {
                    TextField("API Base URL", text: $apiURL)
                    
                    Button("Save API URL") {
                        if apiURL.isEmpty {
                            alertMessage = "API URL cannot be empty"
                            showAlert = true
                            return
                        }
                        
                        APIService.shared.updateBaseURL(newURL: apiURL)
                        alertMessage = "API URL updated successfully"
                        showAlert = true
                    }
                }
                
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
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("API Configuration"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
