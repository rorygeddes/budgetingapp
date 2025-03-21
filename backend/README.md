# Budget App Backend

This is the Python Flask backend for the Budget App. It provides RESTful API endpoints for managing budgets, categories, and transactions.

## Setup

1. Create a virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip3 install -r requirements.txt
```

3. Initialize the database:
```bash
python3 -m flask --app run.py init-db
```

4. (Optional) Seed the database with sample data:
```bash
python3 -m flask --app run.py seed-db
```

5. Run the development server:
```bash
python3 run.py
```

The API will be available at http://localhost:5000.

## API Endpoints

### Users
- `GET /api/users` - Get all users
- `GET /api/users/<id>` - Get a specific user

### Budgets
- `GET /api/budgets` - Get all budgets (optional query param: user_id)
- `POST /api/budgets` - Create a new budget

### Categories
- `GET /api/categories` - Get all categories (optional query param: budget_id)

### Transactions
- `GET /api/transactions` - Get all transactions (optional query params: user_id, category_id)
- `POST /api/transactions` - Create a new transaction

## Testing

Run tests with pytest:
```bash
python3 -m pytest
``` 