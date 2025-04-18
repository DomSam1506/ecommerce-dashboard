# Import relevant libraries
from faker import Faker
import pandas as pd
import random

fake = Faker()

# Define product categories, products, and price/quantity ranges
product_categories = {
    "Electronics": {
        "products": ["Smartphone", "Laptop", "Wireless Earbuds", "Smartwatch", "Tablet", "Gaming Console"],
        "price_range": (500, 2000),
        "stock_range": (20, 100)
    },
    "Clothing": {
        "products": ["T-Shirt", "Jeans", "Sweater", "Jacket", "Sneakers", "Dress","Hoodie","Socks","Sweatpants"],
        "price_range": (15, 250),
        "stock_range": (50, 200)
    },
    "Home & Kitchen": {
        "products": ["Blender", "Vacuum Cleaner", "Microwave", "Air Fryer", "Couch", "Dining Table","Rice Cooker"],
        "price_range": (75, 1000),
        "stock_range": (30, 150)
    },
    "Beauty & Personal Care": {
        "products": ["Shampoo", "Face Cream", "Perfume", "Lipstick", "Sunscreen", "Body Lotion"],
        "price_range": (5, 100),
        "stock_range": (100, 300)
    },
    "Sports & Outdoors": {
        "products": ["Yoga Mat", "Dumbbells", "Running Shoes", "Tent", "Hiking Backpack", "Bicycle"],
        "price_range": (50, 800),
        "stock_range": (30, 200)
    },
    "Toys & Games": {
        "products": ["Lego Set", "Action Figures", "Puzzle", "Board Game", "Dollhouse", "RC Car"],
        "price_range": (5, 200),
        "stock_range": (50, 200)
    },
    "Books": {
        "products": ["Novel", "Textbook", "Cookbook", "Biography", "Children's Book", "Self-Help Book"],
        "price_range": (5, 50),
        "stock_range": (100, 500)
    },
    "Automotive": {
        "products": ["Car Battery", "Oil Filter", "Tire", "Car Wash Kit", "Seat Cover", "Headlights"],
        "price_range": (50, 1000),
        "stock_range": (20, 100)
    },
    "Health & Wellness": {
        "products": ["Vitamins", "Protein Powder", "Fitness Tracker", "Massage Gun", "Essential Oils"],
        "price_range": (10, 500),
        "stock_range": (50, 150)
    },
    "Pet Supplies": {
        "products": ["Dog Leash", "Cat Toy", "Pet Bed", "Fish Tank", "Bird Cage", "Pet Food"],
        "price_range": (5, 300),
        "stock_range": (50, 200)
    }
}

# Generate a reasonable number of products with  prices and stock quantities
num_products = 2500

# Empty array to store generated data
product_data = []

for _ in range(num_products):
    # Pick a random category
    category = random.choice(list(product_categories.keys()))  
    
    product_info = product_categories[category]
    
    # Pick a product name
    base_name = random.choice(product_info["products"])  
    
    # Select a price to two decimal places
    price = round(random.uniform(product_info["price_range"][0], product_info["price_range"][1]), 2) 
    
    # Select a stock 
    stock_quantity = random.randint(product_info["stock_range"][0], product_info["stock_range"][1])  
    
    # Random Supplier ID from 1 to 200 according to database
    supplier_id = random.randint(1, 200)  
    
    # Random date within 5 years
    created_date = fake.date_between(start_date="-5y", end_date="today")  

    # Fill data 
    product_data.append([base_name, category, price, stock_quantity, supplier_id, created_date])

# Create a DataFrame
df_products = pd.DataFrame(product_data, columns=["Name", "Category", "Price", "StockQuantity", "SupplierID", "CreatedDate"])

# Save to CSV
df_products.to_csv("products.csv", index=False)

