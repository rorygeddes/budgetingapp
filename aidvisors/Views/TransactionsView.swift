import SwiftUI

struct TransactionsView: View {
    @StateObject private var viewModel = TransactionViewModel()
    @State private var showingAddTransaction = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.transactions) { transaction in
                        TransactionRowView(transaction: transaction)
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
                            viewModel.fetchTransactions()
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
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingAddTransaction = true
                    }) {
                        Label("Add Transaction", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchTransactions()
            }
        }
    }
}

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.description ?? "No description")
                    .font(.headline)
                
                Text(transaction.date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("$\(String(format: "%.2f", transaction.amount))")
                .font(.headline)
                .foregroundColor(transaction.amount < 0 ? .red : .green)
        }
        .padding(.vertical, 4)
    }
}

struct AddTransactionView: View {
    @Environment(\.presentationMode) var presentationMode
    let viewModel: TransactionViewModel
    
    @State private var amount = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var isExpense = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Transaction Details")) {
                    TextField("Description", text: $description)
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.numbersAndPunctuation)
                    
                    Toggle("Is Expense", isOn: $isExpense)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let amountValue = Double(amount) {
                            let finalAmount = isExpense ? -amountValue : amountValue
                            viewModel.createTransaction(amount: finalAmount, description: description, date: date)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(amount.isEmpty)
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

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView()
    }
} 