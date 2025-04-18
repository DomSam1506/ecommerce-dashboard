# E-Commerce Sales & Profitability Dashboard
An interactive business intelligence dashboard built in Power BI to analyze sales, customer trends, product performance, and profitability over 3 years using SQL and Python-generated data.

---

##   Story of the Project
This personal project results from my curiosity and desire to learn the basics of data analysis. I first designed the tables and relationships in SQL. Then, I generated mock data using both Mockaroo and Python. There were a lot of issues and things I had to sort out either by learning online or trying a different way of thinking. Eventually, my tables were set up, and the queries were done. I used W3School's free SQL course to learn about more advanced functions like RANK() and CTEs. It was fascinating learning about these powerful tools. The final step was visualizing my queries using Power BI. This was the hardest part, as I was also learning Power BI for the first time. After several redesigns, issues, and frustrations, my dashboard was complete! Through this personal project, I have gained valuable skills on SQL advanced queries, Python data generation and storage and of course storytelling with data. I hope you enjoy the finished product, and thank you so much for your time.

---
---
##  How to Explore

1. Download `ECOMMERCE PROJECT.pbix`
2. Open with **Power BI Desktop**
3. Use slicers, filters, and tabs to explore the dashboard pages:
   - **Home Page with Recommendations**
   - **Sales Overview**
   - **Customer Insights**
   - **Product & Supplier**
   - **Profitability Analysis**
   
---
---

##  SQL Table Relationships

The database follows a **3NF-compliant star schema** structure. Below is the logical relationship between the tables:

- **Customers** (CustomerID) ⟷ **Orders** (CustomerID)
- **Orders** (OrderID) ⟷ **OrderDetails** (OrderID)
- **Products** (ProductID) ⟷ **OrderDetails** (ProductID)
- **Suppliers** (SupplierID) ⟷ **Products** (SupplierID)



[ER Diagram]![Screenshot 2025-04-01 115532](https://github.com/user-attachments/assets/562d19f2-2fa3-4d88-aa8c-709346b1e421)


---
---
##  Tools & Technologies Used

- **Power BI Desktop** – Data modeling and interactive dashboards  
- **MySQL** – Backend data querying  
- **Python** – Product data generation  
- **Mockaroo** – Simulated customer, order, and supplier data  
- **GitHub** – Version control and project showcase

---

---

##  Project Files

| File | Description |
|------|-------------|
| `ECOMMERCE PROJECT.pbix` | Power BI dashboard file |
| `ProductData.py` | Python script for generating product data |
| `EcommerceProject.sql` | SQL schema and queries |
| `README.md` | Project summary and documentation |

---

##  Disclaimer

This project uses **synthetic data** generated from **Mockaroo** and Python scripts. It is intended solely for learning and portfolio purposes. No personal or private data was used in this project.

---

## Author

Created by Dominion Ubong Samuel, Data Science Student at SFU.  
Aspiring Data Scientist

---


