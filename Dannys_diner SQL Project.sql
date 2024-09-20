CREATE SCHEMA dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  

/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT s.customer_id, SUM(m.price) AS total_amount_spend
FROM dannys_diner.sales AS s
INNER JOIN dannys_diner.menu AS m
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_amount_spend DESC

-- 2. How many days has each customer visited the restaurant?

select s.customer_id, count(distinct (s.order_date)) as total_days_visited
from dannys_diner.sales as s
group by s.customer_id
order by total_days_visited desc

-- 3. What was the first item from the menu purchased by each customer?

with cte as (
select s.customer_id,s.order_date,m.product_id,m.product_name
from dannys_diner.sales as s
inner join dannys_diner.menu as m 
on s.product_id=m.product_id 
),
cte2 as (
select customer_id,order_date,product_name,
dense_rank()
over (partition by customer_id order by order_date asc) as dr
from cte 
)
select customer_id,product_name 
from cte2
where dr=1


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

with cte as (
select s.product_id,m.product_name,
count(*)
over (partition by s.product_id ) as total_num
from dannys_diner.sales as s 
inner join dannys_diner.menu as m
on s.product_id=m.product_id
)
select product_name,total_num
from cte 
where total_num in ( select max(total_num) from cte)
limit 1


-- 5. Which item was the most popular for each customer?

with cte as (
select s.customer_id , m.product_name,count(*) as total_ordered
from dannys_diner.sales as s
inner join dannys_diner.menu as m
on s.product_id=m.product_id
group by s.customer_id,m.product_name
),
cte2 as (
select customer_id,product_name,total_ordered, 
dense_rank()
over (partition by customer_id order by total_ordered desc ) as dr
from cte
)
select customer_id,product_name
from cte2
where dr=1

-- 6. Which item was purchased first by the customer after they became a member?

with cte as (
select s.customer_id, s.order_date,s.product_id,me.product_name
from dannys_diner.sales as s
inner join dannys_diner.members as m
on s.customer_id=m.customer_id
inner join dannys_diner.menu as me
on s.product_id=me.product_id
where s.order_date > m.join_date 

order by s.order_date asc 
),
cte2 as (
select customer_id,order_date,product_name,
dense_rank()
over(partition by customer_id order by order_date asc) as dr
from cte 
)
select customer_id,product_name
from cte2
where dr=1

-- 7. Which item was purchased just before the customer became a member?

with cte as (
select s.customer_id, s.order_date,s.product_id,me.product_name
from dannys_diner.sales as s
inner join dannys_diner.members as m
on s.customer_id=m.customer_id
inner join dannys_diner.menu as me
on s.product_id=me.product_id
where s.order_date < m.join_date 

order by s.order_date desc 
),
cte2 as (
select customer_id,order_date,product_name,
dense_rank()
over(partition by customer_id order by order_date desc) as dr
from cte 
)
select customer_id,product_name
from cte2
where dr=1

-- 8. What is the total items and amount spent for each member before they became a member?

select s.customer_id,count(me.product_id) as total_item,sum(me.price) as total_amount
from dannys_diner.sales as s
inner join dannys_diner.members as m
on s.customer_id=m.customer_id
inner join dannys_diner.menu as me
on s.product_id=me.product_id
where s.order_date < m.join_date 
group by  s.customer_id
order by s.customer_id  asc

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

with cte as (
select s.customer_id,m.product_name,m.price
from dannys_diner.sales as s
inner join dannys_diner.menu as m
on s.product_id=m.product_id
),
cte2 as (
select customer_id,
  case 
      when product_name='curry' then price*10
	  when product_name='ramen' then price*10
	  else price*10*2 
  end as points
from cte
)
select customer_id, sum(points) as total_points
from cte2 
group by customer_id
order by customer_id asc

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

WITH cte AS (
    SELECT 
        s.customer_id,
        me.product_name,
        me.price,
        CASE 
            WHEN s.order_date <= mem.join_date + INTERVAL '7 days' 
                 AND (me.product_name = 'ramen' OR me.product_name = 'curry') 
            THEN me.price * 2
            ELSE me.price
        END AS points
    FROM dannys_diner.sales AS s
    INNER JOIN dannys_diner.menu AS me ON s.product_id = me.product_id
    INNER JOIN dannys_diner.members AS mem ON s.customer_id = mem.customer_id
    WHERE s.order_date > mem.join_date  
      AND s.order_date BETWEEN '2021-01-01' AND '2021-01-31'
)
SELECT customer_id, SUM(points) AS total_points
FROM cte 
GROUP BY customer_id;
