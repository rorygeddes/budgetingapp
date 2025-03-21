from flask import Blueprint, jsonify, request
from .models import User, Budget, Category, Transaction
from . import db
from datetime import datetime

main_bp = Blueprint('main', __name__)

# API health check
@main_bp.route('/api/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy", "timestamp": datetime.utcnow().isoformat()})

# User routes
@main_bp.route('/api/users', methods=['GET'])
def get_users():
    users = User.query.all()
    return jsonify({
        'users': [{'id': user.id, 'username': user.username, 'email': user.email} for user in users]
    }), 200

@main_bp.route('/api/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    user = User.query.get_or_404(user_id)
    return jsonify({
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'created_at': user.created_at.isoformat()
    }), 200

# Budget routes
@main_bp.route('/api/budgets', methods=['GET'])
def get_budgets():
    user_id = request.args.get('user_id', type=int)
    if user_id:
        budgets = Budget.query.filter_by(user_id=user_id).all()
    else:
        budgets = Budget.query.all()
    
    return jsonify({
        'budgets': [{
            'id': budget.id,
            'name': budget.name,
            'amount': budget.amount,
            'start_date': budget.start_date.isoformat(),
            'end_date': budget.end_date.isoformat(),
            'user_id': budget.user_id
        } for budget in budgets]
    }), 200

@main_bp.route('/api/budgets', methods=['POST'])
def create_budget():
    data = request.get_json()
    
    try:
        new_budget = Budget(
            name=data['name'],
            amount=data['amount'],
            start_date=datetime.strptime(data['start_date'], '%Y-%m-%d').date(),
            end_date=datetime.strptime(data['end_date'], '%Y-%m-%d').date(),
            user_id=data['user_id']
        )
        
        db.session.add(new_budget)
        db.session.commit()
        
        return jsonify({
            'id': new_budget.id,
            'name': new_budget.name,
            'amount': new_budget.amount,
            'start_date': new_budget.start_date.isoformat(),
            'end_date': new_budget.end_date.isoformat(),
            'user_id': new_budget.user_id
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 400

# Category routes
@main_bp.route('/api/categories', methods=['GET'])
def get_categories():
    budget_id = request.args.get('budget_id', type=int)
    if budget_id:
        categories = Category.query.filter_by(budget_id=budget_id).all()
    else:
        categories = Category.query.all()
    
    return jsonify({
        'categories': [{
            'id': category.id,
            'name': category.name,
            'planned_amount': category.planned_amount,
            'budget_id': category.budget_id
        } for category in categories]
    }), 200

# Transaction routes
@main_bp.route('/api/transactions', methods=['GET'])
def get_transactions():
    user_id = request.args.get('user_id', type=int)
    category_id = request.args.get('category_id', type=int)
    
    query = Transaction.query
    
    if user_id:
        query = query.filter_by(user_id=user_id)
    
    if category_id:
        query = query.filter_by(category_id=category_id)
    
    transactions = query.all()
    
    return jsonify({
        'transactions': [{
            'id': transaction.id,
            'amount': transaction.amount,
            'description': transaction.description,
            'date': transaction.date.isoformat(),
            'user_id': transaction.user_id,
            'category_id': transaction.category_id
        } for transaction in transactions]
    }), 200

@main_bp.route('/api/transactions', methods=['POST'])
def create_transaction():
    data = request.get_json()
    
    try:
        new_transaction = Transaction(
            amount=data['amount'],
            description=data.get('description', ''),
            date=datetime.strptime(data['date'], '%Y-%m-%d').date(),
            user_id=data['user_id'],
            category_id=data.get('category_id')
        )
        
        db.session.add(new_transaction)
        db.session.commit()
        
        return jsonify({
            'id': new_transaction.id,
            'amount': new_transaction.amount,
            'description': new_transaction.description,
            'date': new_transaction.date.isoformat(),
            'user_id': new_transaction.user_id,
            'category_id': new_transaction.category_id
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 400 