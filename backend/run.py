from app import create_app, db
from app.models import User, Budget, Category, Transaction

app = create_app()

@app.cli.command("init-db")
def init_db():
    """Initialize the database."""
    db.create_all()
    print("Database initialized!")

@app.cli.command("seed-db")
def seed_db():
    """Seed the database with sample data."""
    # Create a test user
    test_user = User(
        username="test_user",
        email="test@example.com",
        password_hash="pbkdf2:sha256:150000$test$hash"
    )
    db.session.add(test_user)
    db.session.commit()
    
    print("Database seeded!")

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000) 