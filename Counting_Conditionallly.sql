## Both premium and all customers in one table
SELECT date(created_at), count(1) as All Customers, 
sum( CASE 
	when monthly_plan_amount > 100 then 1
    else 0 
  end
) AS Premium customers
FROM customers
GROUP BY 1



