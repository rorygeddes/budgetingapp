import Foundation

// MARK: - User
struct User: Identifiable, Codable {
    let id: Int
    let username: String
    let email: String
    var createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username, email
        case createdAt = "created_at"
    }
}

// MARK: - Budget
struct Budget: Identifiable, Codable {
    let id: Int
    let name: String
    let amount: Double
    let startDate: String
    let endDate: String
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, amount
        case startDate = "start_date"
        case endDate = "end_date"
        case userId = "user_id"
    }
}

// MARK: - Category
struct Category: Identifiable, Codable {
    let id: Int
    let name: String
    let plannedAmount: Double
    let budgetId: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case plannedAmount = "planned_amount"
        case budgetId = "budget_id"
    }
}

// MARK: - Transaction
struct Transaction: Identifiable, Codable {
    let id: Int
    let amount: Double
    let description: String?
    let date: String
    let userId: Int
    let categoryId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, amount, description, date
        case userId = "user_id"
        case categoryId = "category_id"
    }
}

// MARK: - API Responses
struct UsersResponse: Codable {
    let users: [User]
}

struct BudgetsResponse: Codable {
    let budgets: [Budget]
}

struct CategoriesResponse: Codable {
    let categories: [Category]
}

struct TransactionsResponse: Codable {
    let transactions: [Transaction]
} 