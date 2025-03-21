# Budget App

A comprehensive budgeting application with a Swift UI frontend and Python Flask backend.

## Project Structure

This project consists of two main components:

1. **iOS App (Swift UI)** - The mobile frontend for the budgeting app
2. **Backend API (Python Flask)** - The RESTful API that handles data storage and business logic

## Getting Started

### Backend Setup

1. Navigate to the backend directory:
```bash
cd backend
```

2. Create a virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip3 install -r requirements.txt
```

4. Initialize the database:
```bash
python3 -m flask --app run.py init-db
```

5. (Optional) Seed the database with sample data:
```bash
python3 -m flask --app run.py seed-db
```

6. Run the development server:
```bash
python3 run.py
```

The API will be available at http://localhost:5000.

### iOS App Setup

1. Open the Xcode project file `aidvisors.xcodeproj`
2. Build and run the project in Xcode

## Features

- Create and manage budgets
- Track expenses and income
- Categorize transactions
- View spending trends and insights (coming soon)
- User authentication (coming soon)

## Technologies Used

- **Frontend**: Swift UI, Combine
- **Backend**: Python, Flask, SQLAlchemy
- **Database**: SQLite (development), PostgreSQL (production ready)

## API Documentation

See the [Backend README](backend/README.md) for detailed API documentation.

## Deployment

### Backend Deployment

The backend is configured to be easily deployable to services like Heroku or AWS.

### iOS App Deployment

The iOS app can be distributed through TestFlight or the App Store.

## License

MIT 