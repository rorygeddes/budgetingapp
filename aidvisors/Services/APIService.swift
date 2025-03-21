import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
    case invalidResponse
    case serverError(statusCode: Int)
    case unknown
}

class APIService {
    static let shared = APIService()
    
    // Default to local development server
    // This can be updated to your domain URL when you have one
    #if DEBUG
    var baseURL = "http://localhost:5000/api"
    #else
    var baseURL = "https://your-domain.com/api" // Update this with your domain when you have one
    #endif
    
    private init() {
        // Load from UserDefaults if a custom URL has been set
        if let savedURL = UserDefaults.standard.string(forKey: "api_base_url") {
            baseURL = savedURL
        }
    }
    
    // Allow changing the base URL if needed
    func updateBaseURL(newURL: String) {
        baseURL = newURL
        UserDefaults.standard.set(newURL, forKey: "api_base_url")
    }
    
    // MARK: - API Request
    private func request<T: Decodable>(endpoint: String, method: String = "GET", body: Data? = nil) -> AnyPublisher<T, APIError> {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let body = body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { APIError.requestFailed($0) }
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                if httpResponse.statusCode >= 400 {
                    throw APIError.serverError(statusCode: httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                if let error = error as? APIError {
                    return error
                }
                
                if let decodingError = error as? DecodingError {
                    return APIError.decodingFailed(decodingError)
                }
                
                return APIError.unknown
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Budget Endpoints
    func fetchBudgets(userId: Int? = nil) -> AnyPublisher<BudgetsResponse, APIError> {
        let endpoint = userId != nil ? "budgets?user_id=\(userId!)" : "budgets"
        return request(endpoint: endpoint)
    }
    
    func createBudget(name: String, amount: Double, startDate: String, endDate: String, userId: Int) -> AnyPublisher<Budget, APIError> {
        let budget = [
            "name": name,
            "amount": amount,
            "start_date": startDate,
            "end_date": endDate,
            "user_id": userId
        ] as [String: Any]
        
        guard let body = try? JSONSerialization.data(withJSONObject: budget) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return request(endpoint: "budgets", method: "POST", body: body)
    }
    
    // MARK: - Category Endpoints
    func fetchCategories(budgetId: Int? = nil) -> AnyPublisher<CategoriesResponse, APIError> {
        let endpoint = budgetId != nil ? "categories?budget_id=\(budgetId!)" : "categories"
        return request(endpoint: endpoint)
    }
    
    // MARK: - Transaction Endpoints
    func fetchTransactions(userId: Int? = nil, categoryId: Int? = nil) -> AnyPublisher<TransactionsResponse, APIError> {
        var endpoint = "transactions"
        
        if userId != nil || categoryId != nil {
            endpoint += "?"
            
            if let userId = userId {
                endpoint += "user_id=\(userId)"
                
                if categoryId != nil {
                    endpoint += "&"
                }
            }
            
            if let categoryId = categoryId {
                endpoint += "category_id=\(categoryId)"
            }
        }
        
        return request(endpoint: endpoint)
    }
    
    func createTransaction(amount: Double, description: String?, date: String, userId: Int, categoryId: Int? = nil) -> AnyPublisher<Transaction, APIError> {
        var transaction: [String: Any] = [
            "amount": amount,
            "date": date,
            "user_id": userId
        ]
        
        if let description = description {
            transaction["description"] = description
        }
        
        if let categoryId = categoryId {
            transaction["category_id"] = categoryId
        }
        
        guard let body = try? JSONSerialization.data(withJSONObject: transaction) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return request(endpoint: "transactions", method: "POST", body: body)
    }
} 