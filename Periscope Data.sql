### Correlated Queries
#Table: We have a users table and a widgets table, and each user has many widgets. users.id is the primary key on users, 
# and widgets.user_id is the corresponding foreign key in widgets.
Users = {id}
## Correlated indexed Query - 1
SELECT *
FROM user INNER JOIN widgets ON user.id = 
		(SELECT widget_id 
		WHERE  user.id = widgets.user_id
		ORDER BY widgets.created_at DESC
		LIMIT 1)


## Correlated non indexed query - scan table once
SELECT * FROM users JOIN
(SELECT DISTINCT ON (widgets.user_id) 
FROM widgets
ORDER BY created_at desc
) as recent
ON recent.id = users.id


## Day-over-Day Challenges
#To start, let’s count the daily events for the last 10 days:
SELECT date(created_at), count(1) 
FROM events
Group by created_at
Order by created_at desc
LIMIT 10 

# Get yesterdays value one up 
SELECT date(created_at) dt, count(1) ct, lag(count (1)) Over (order by 1 desc) ct_yesterday
FROM events
Group by created_at
Order by created_at desc
LIMIT 10 

# we really want the change between today and yesterday. To do that, we calculate (ct - ct_yesterday) / ct_yesterday
Select dt, ct,ct_yesterday, round(100*(ct - ct_yesterday) / ct_yesterday, 2) || % as daily_delta
From 
(SELECT date(created_at) dt, count(1) ct, lag(count (1)) Over (order by 1 desc) as ct_yesterday
FROM events
Group by created_at
Order by created_at desc
LIMIT 10 ) FT


## Selecting Only One Row Per Group
# start with table
SELECT date(created_at) as dt, count(1) dt, platform
FROM gameplays
group by 1
# POSTGRES
SELECT  dt, ct, platform,
(
SELECT date(created_at) as dt, count(1) dt, platform, row_number() Over (Partition by dt Order by ct Desc) as row_num
FROM gameplays
group by 1
)
WHERE row_num =1 
#MySQL
SELECT dt,substring_index(group_concat(platform,Order by ct desc),',',1), ct
(SELECT date(created_at) as dt, count(1) dt, platform
FROM gameplays
group by 1) filtered
group by 1

## Using CTEs and Unions to Compute Running Totals
# Intial Query "with"
WITH individual_performance AS (
		SELECT DATE_TRUNC('MONTH', plan_start) AS m,
		users.name salesperson,
    	sum(purchase_price) revenue
    	FROM   payment_plans join users 
    	on users.id = payment_plans.sales_owner_id
  		group by 1, 2
	)
SELECT 
m, 
salesperson, 
revenue 
from individual_performance
union all 
select 
  m, 
  'Total', 
  sum(revenue) 
from individual_performance 
group by 1
##