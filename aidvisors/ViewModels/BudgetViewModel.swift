import Foundation
import Combine

class BudgetViewModel: ObservableObject {
    @Published var budgets: [Budget] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService.shared
    
    // For demo purposes, hardcoded user ID
    private let userId = 1
    
    func fetchBudgets() {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchBudgets(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch budgets: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] response in
                self?.budgets = response.budgets
            }
            .store(in: &cancellables)
    }
    
    func createBudget(name: String, amount: Double, startDate: Date, endDate: Date) {
        isLoading = true
        errorMessage = nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        apiService.createBudget(name: name, amount: amount, startDate: startDateString, endDate: endDateString, userId: userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to create budget: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] newBudget in
                self?.budgets.append(newBudget)
            }
            .store(in: &cancellables)
    }
} 