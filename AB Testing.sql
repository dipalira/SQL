# Simple A/B Test Validations
'1. Check for orphaned users'
#how many users fall into the three possible buckets: Entered but not converted, entered and converted, and converted but not entered?
SELECT  COUNT(
			CASE when ab_test_entrant.user_id not null and ab_test_conversion.user_id  null THEN 1
	     		ELSE 0
	     	END
			)as users_entered_but_not_converted,
		COUNT(
			CASE when ab_test_entrant.user_id not null and ab_test_conversion.user_id not null THEN 1
			     ELSE 0
			END
					)as users_entered_and_converted,
		COUNT(
			CASE when ab_test_entrant.user_id  null and ab_test_conversion.user_id not null THEN 1
			     ELSE 0
			END
					)as converted_and_not_entered

FROM ab_test_entrant FULL OUTER JOIN ab_test_entrant on ab_test_entrant.user_id = ab_test_entrant.user_id 
'2. Check for conversions after test entries'
#what is the distribution of days it takes to get from entry to conversion?

SELECT DATE_PART('day', date(ab_test_entrant_date), date(conversion_date)), count(*)
FROM ab_test_entrant JOIN ab_test_entrant on ab_test_entrant.user_id = ab_test_entrant.user_id 
Group by 1
'3. Check for data populating in each bucket'
#Finally, do I have the expected number of versions, collecting conversions in each bucket?

