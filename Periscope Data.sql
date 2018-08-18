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
SELECT date(created_at) dt, count(1) ct, lag(count (1)) Over (order by 1 desc) 
FROM events
Group by created_at
Order by created_at desc
LIMIT 10 

# we really want the change between today and yesterday. To do that, we calculate (ct - ct_yesterday) / ct_yesterday
