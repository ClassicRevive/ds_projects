-- query1 get monthly orders data for physical copies ordered specifically
-- by stores

SELECT buyer_name AS buyer, -- buyer dimension
    product_name AS game, game_category AS genre, game_rating AS rating, platform -- game dimension
    year, month, country, state, town, primary_language AS language,  -- buyer/date dimension
    total_units_sold AS totalSold, total_production_cost AS totalCost,  -- facts
    total_month_profit AS totalProfit, total_sales AS totalSales
FROM Monthly_orders
JOIN Product USING (product_key)
JOIN Date_augmented USING (date_key)
JOIN Buyer USING (buyer_key)
WHERE is_store == True AND physical_copy == True
GROUP BY buyer_key, product_key, date_key
ORDER BY totalSold DESC;


-- query2 get the total profit and orders made during each promotion

SELECT promo_name, as promotion, promo_start as startDate, promo_end as endDate, -- promo dimension
    promo_details as details,
    sum(units_sold) as totalSold, sum(total_profit) as totalProfit  -- facts
FROM orders
JOIN Promotion USING (promo_key)
GROUP BY promo_key
ORDER BY totalSold DESC
