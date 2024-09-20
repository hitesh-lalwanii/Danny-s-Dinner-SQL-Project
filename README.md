# SQL Challenge: Danny's Diner

## Topics Covered
- Common Table Expressions (CTEs)
- Aggregating Data with GROUP BY
- Window Functions for Ranking
- Table Joins

## Introduction

Danny has a deep love for Japanese food, and at the beginning of 2021, he decided to take a leap of faith and open a small restaurant featuring his three favorite dishes: sushi, curry, and ramen.

However, Danny's Diner is struggling, and he needs your help to analyze his data and keep the restaurant afloat. The data collected from the first few months of operation is basic, and Danny is unsure how to use it to improve his business.

## Problem Statement
Danny wants to better understand his customers' behavior—specifically their visiting patterns, spending habits, and favorite menu items. By understanding these insights, he can provide a more personalized experience for loyal customers, which will help him decide if he should expand the customer loyalty program.

He also needs help generating simple datasets for his team to inspect, without requiring complex SQL queries.

Due to privacy concerns, Danny has provided a sample of his customer data. He hopes that with this sample, you can develop SQL queries to help answer his business questions.

## Available Datasets
Danny has shared three key datasets for this case study:

### 1. sales Table
The sales table records all customer purchases, including:

customer_id: Unique identifier for each customer
order_date: Date of the purchase
product_id: ID of the menu item purchased

![Screenshot 2024-09-20 155348](https://github.com/user-attachments/assets/f861f7fb-0b5c-487a-9c8b-5b36671556bf)

### 2. menu Table
The menu table connects the product IDs from the sales table to the actual menu items and their prices:

product_id: Unique identifier for each menu item
product_name: Name of the menu item
price: Price of the menu item

![Screenshot 2024-09-20 155523](https://github.com/user-attachments/assets/969e2c54-e417-4037-a07d-d08b304a66bd)



### 3. members Table
The members table tracks the customers who have joined Danny’s loyalty program:

customer_id: Unique identifier for each customer
join_date: Date the customer joined the loyalty program

![Screenshot 2024-09-20 155608](https://github.com/user-attachments/assets/fd4215b9-f825-49e3-af8d-f83388e6ce53)



## Case Study Questions
Danny needs you to answer the following questions using SQL:

What is the total amount each customer spent at the restaurant?
How many days has each customer visited the restaurant?
What was the first item from the menu purchased by each customer?
What is the most purchased item on the menu, and how many times was it purchased by all customers?
Which item was the most popular for each customer?
Which item was purchased first by the customer after they became a member?
Which item was purchased just before the customer became a member?
What is the total number of items and total amount spent by each customer before they became a member?
If each $1 spent equals 10 points, and sushi has a 2x points multiplier, how many points would each customer have?
In the first week after a customer joins the loyalty program (including their join date), they earn 2x points on all items, not just sushi. How many points do customers A and B have at the end of January?


