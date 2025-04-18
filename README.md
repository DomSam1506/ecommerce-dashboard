# E-Commerce Sales & Profitability Dashboard
An interactive business intelligence dashboard built in Power BI to analyze sales, customer trends, product performance, and profitability over 3 years using SQL and Python-generated data.

---

##   Story of the Project
This project began as a personal challenge fueled by my curiosity and eagerness to learn the fundamentals of data analysis, from raw data to actionable insights. I started by designing the SQL database schema and relationships, then used a mix of Python and Mockaroo to generate mock data that mimicked a medium-sized e-commerce business. Some parts, like generating realistic product and order data, were more complex than expected, and I often had to pivot, debug, or research new approaches to get things working.

Along the way, I picked up advanced SQL techniques like RANK() and CTEs using W3Schools' free course and applied them in real queries to uncover deeper insights. The final (and most challenging) step was building the Power BI dashboard. Since it was my first time using Power BI, it took several redesigns, a few setbacks, and a lot of persistence—but I’m proud of how it turned out.

Through this experience, I’ve built skills in SQL, Python, and Power BI—but more importantly, I’ve learned how to troubleshoot creatively, communicate insights clearly, and see a data project through from start to finish. Thanks for checking it out!

---

---

##  Goal
The goal of this personal project was to gain practical, end-to-end experience with data analysis by working with mock data modeled after a medium-sized e-commerce business. Using Python, SQL, and Power BI, I simulated a real-world analytics workflow—extracting insights, identifying business challenges, and proposing data-driven recommendations. This project showcases my ability to turn structured data into strategic actions that could guide decisions in a fast-paced business environment.

---

---
##  Executive Summary:

This dashboard reveals a business with strong sales traction but struggling profitability. Despite over $2.25M in revenue across three years, profit margins are thin, and customer churn is accelerating. To transform top-line momentum into lasting growth, action is needed on pricing, retention, and product strategy.

---
---
##  Key Insights:

### Revenue ≠ Profit: September had the highest revenue but the lowest profit, possibly due to low-margin or heavily discounted products.
Customer Churn Rising: 593 churned customers vs. 193 active, with very few high-value new customers recently.
Tier 1 Customers Drive Value: Joey Rizelli alone contributes outsized revenue; others in Tier 1 likely share that potential.
Profitability Misaligned with Sales: Products like car headlights outperform some top-selling electronics in profit.
Inefficient Product Mix: Electronics sell best, but not all are profitable. Non-tech essentials are quietly delivering higher margins.
Books Category Underperforming: Lowest revenue category, possibly dragging on inventory and lowering margins.
Supply Chain Opportunity: Supplier Wunsch Hagesnes stands out for strong sales, an ideal partner to scale with and grow.
High AOV ≠ High Profit: January’s high Average Order Value didn’t result in proportional profit gains. 


RECOMMENDATIONS 



Increase Profit Margins:  Investigate high-revenue products for cost inefficiencies → Eliminate low-margin bestsellers → Improve overall profitability.


Retain High-Value Customers: Launch a loyalty program targeting Tier 1 clients → Boost repeat purchases → Grow revenue consistency.


Refine Product Mix : Expand profitable non-tech items (e.g., car essentials) → Diversify beyond electronics → Stabilize profits across categories.


Improve Supplier Deals: Renegotiate terms with low-margin, high-volume suppliers → Lower cost of goods → Widen profit margins.


Control Discount Strategy : Limit deep discounts in peak revenue months → Preserve margins during high sales → Sustain profitability year-round.

---
---
##  How to Explore

1. Download `ECOMMERCE PROJECT.pbix`
2. Open with **Power BI Desktop**
3. Use slicers, filters, and sliders to explore the dashboard pages:
   - **Sales Overview**
   - **Customer Insights**
   - **Product & Supplier**
   - **Profitability Analysis**
4. View `EcommerceProject.sql` to see the queries that generated the visualizations (OPTIONAL)
   
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


