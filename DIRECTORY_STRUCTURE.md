# Project Directory Structure

## Root
- `README.md` - Main project documentation
- `DIRECTORY_STRUCTURE.md` - This file, explaining the directory layout
- `aidvisors.xcodeproj/` - Xcode project files

## iOS App (Swift UI)
- `aidvisors/` - Main iOS app directory
  - `aidvisorsApp.swift` - Main app entry point
  - `ContentView.swift` - Main content view with tab navigation
  - `Info.plist` - App configuration
  - `Assets.xcassets/` - App assets and images
  
  - `Models/` - Data models
    - `BudgetModels.swift` - Models for budgets, categories, transactions, etc.
  
  - `Views/` - SwiftUI views
    - `BudgetListView.swift` - View for displaying and managing budgets
    - `TransactionsView.swift` - View for displaying and managing transactions
  
  - `ViewModels/` - View models for state management
    - `BudgetViewModel.swift` - State management for budgets
    - `TransactionViewModel.swift` - State management for transactions
  
  - `Services/` - API and data services
    - `APIService.swift` - Service for communicating with the backend API

## Backend (Python Flask)
- `backend/` - Main backend directory
  - `requirements.txt` - Python dependencies
  - `README.md` - Backend documentation
  - `.env` - Environment variables (not in version control)
  - `run.py` - Main entry point for running the Flask app
  
  - `app/` - Flask application code
    - `__init__.py` - Flask app initialization
    - `models.py` - Database models
    - `routes.py` - API routes and controllers
  
  - `tests/` - Backend tests

## Tests
- `aidvisorsTests/` - iOS app tests
- `aidvisorsUITests/` - iOS UI tests
- `backend/tests/` - Backend tests 