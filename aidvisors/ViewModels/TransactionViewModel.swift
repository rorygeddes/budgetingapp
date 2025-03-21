import Foundation
import Combine

class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService.shared
    
    // For demo purposes, hardcoded user ID
    private let userId = 1
    
    func fetchTransactions(categoryId: Int? = nil) {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchTransactions(userId: userId, categoryId: categoryId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch transactions: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] response in
                self?.transactions = response.transactions
            }
            .store(in: &cancellables)
    }
    
    func createTransaction(amount: Double, description: String?, date: Date, categoryId: Int? = nil) {
        isLoading = true
        errorMessage = nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        apiService.createTransaction(amount: amount, description: description, date: dateString, userId: userId, categoryId: categoryId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to create transaction: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] newTransaction in
                self?.transactions.append(newTransaction)
            }
            .store(in: &cancellables)
    }
} 