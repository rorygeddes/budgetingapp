import SwiftUI

struct BudgetListView: View {
    @StateObject private var viewModel = BudgetViewModel()
    @State private var showingAddBudget = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.budgets) { budget in
                        NavigationLink(destination: BudgetDetailView(budget: budget)) {
                            BudgetRowView(budget: budget)
                        }
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                }
                
                if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Error")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Try Again") {
                            viewModel.fetchBudgets()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding()
                }
            }
            .navigationTitle("My Budgets")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingAddBudget = true
                    }) {
                        Label("Add Budget", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBudget) {
                AddBudgetView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchBudgets()
            }
        }
    }
}

struct BudgetRowView: View {
    let budget: Budget
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(budget.name)
                .font(.headline)
            
            HStack {
                Text("$\(String(format: "%.2f", budget.amount))")
                    .font(.subheadline)
                    .foregroundColor(.green)
                
                Spacer()
                
                Text("\(budget.startDate) - \(budget.endDate)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

struct BudgetDetailView: View {
    let budget: Budget
    
    var body: some View {
        Text("Budget details coming soon!")
            .navigationTitle(budget.name)
    }
}

struct AddBudgetView: View {
    @Environment(\.presentationMode) var presentationMode
    let viewModel: BudgetViewModel
    
    @State private var name = ""
    @State private var amount = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(30*24*60*60) // 30 days later
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Budget Details")) {
                    TextField("Budget Name", text: $name)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Date Range")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Budget")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let amountValue = Double(amount), !name.isEmpty {
                            viewModel.createBudget(name: name, amount: amountValue, startDate: startDate, endDate: endDate)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(name.isEmpty || amount.isEmpty)
                }
            }
            .disabled(viewModel.isLoading)
            .overlay(
                Group {
                    if viewModel.isLoading {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea()
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    }
                }
            )
        }
    }
}

struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListView()
    }
} 