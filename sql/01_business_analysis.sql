SELECT
    COUNT(DISTINCT "Order Id") AS total_orders,
    COUNT(DISTINCT "Customer Id") AS total_customers,
    COUNT(DISTINCT "Order Item Id") AS total_order_items,
    ROUND(SUM("Sales")::numeric, 2) AS total_sales,
    ROUND(AVG("Sales")::numeric, 2) AS avg_sales_per_item,
    ROUND(SUM("Benefit per order")::numeric, 2)
        AS total_recorded_benefit
FROM supply_chain;


-- Question 2: Monthly Sales Performance

SELECT
    "Order_Year",
    "Order_Month",
    "Order_Month_Name",
    ROUND(SUM("Sales")::numeric, 2) AS monthly_sales,
    COUNT(DISTINCT "Order Id") AS total_orders
FROM supply_chain
GROUP BY
    "Order_Year",
    "Order_Month",
    "Order_Month_Name"
ORDER BY
    "Order_Year",
    "Order_Month";


-- Question 3: Category-wise Sales and Benefit Analysis

SELECT
    "Category Name",
    COUNT(DISTINCT "Order Id") AS total_orders,
    SUM("Order Item Quantity") AS total_quantity_sold,
    ROUND(SUM("Sales")::numeric, 2) AS total_sales,
    ROUND(
        SUM("Benefit per order")::numeric, 2
    ) AS total_recorded_benefit,
    ROUND(AVG("Benefit per order")::numeric, 2)
        AS avg_recorded_benefit
FROM supply_chain
GROUP BY "Category Name"
ORDER BY total_sales DESC;


-- Question 4: Rank Categories by Sales

SELECT
    "Category Name",
    ROUND(SUM("Sales")::numeric, 2) AS total_sales,

    RANK() OVER (
        ORDER BY SUM("Sales") DESC
    ) AS sales_rank,

    DENSE_RANK() OVER (
        ORDER BY SUM("Sales") DESC
    ) AS dense_sales_rank

FROM supply_chain

GROUP BY "Category Name"

ORDER BY sales_rank;


-- Question 5: Late Delivery Analysis by Shipping Mode

SELECT
    "Shipping Mode",

    COUNT(*) AS total_order_items,

    SUM(
        CASE
            WHEN "Delivery Status" = 'Late delivery'
            THEN 1 ELSE 0
        END
    ) AS late_order_items,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN "Delivery Status" = 'Late delivery'
                THEN 1 ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_delivery_percentage

FROM supply_chain

GROUP BY "Shipping Mode"

ORDER BY late_delivery_percentage DESC;


-- Question 6: Delivery Status Distribution

SELECT
    "Delivery Status",
    COUNT(*) AS total_order_items,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_total

FROM supply_chain

GROUP BY "Delivery Status"

ORDER BY total_order_items DESC;


-- Question 7: Shipping Delay Distribution

SELECT
    "Shipping_Delay_Days",
    COUNT(*) AS total_order_items,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage

FROM supply_chain

WHERE "Delivery Status" <> 'Shipping canceled'

GROUP BY "Shipping_Delay_Days"

ORDER BY "Shipping_Delay_Days";


-- Question 8: Customer Segment Performance

SELECT
    "Customer Segment",

    COUNT(DISTINCT "Customer Id") AS total_customers,

    COUNT(DISTINCT "Order Id") AS total_orders,

    ROUND(SUM("Sales")::numeric, 2) AS total_sales,

    ROUND(AVG("Sales")::numeric, 2)
        AS average_sales_per_item,

    ROUND(SUM("Benefit per order")::numeric, 2)
        AS total_recorded_benefit

FROM supply_chain

GROUP BY "Customer Segment"

ORDER BY total_sales DESC;


-- Question 9: Regional Sales Performance

SELECT
    "Order Region",

    COUNT(DISTINCT "Order Id") AS total_orders,

    ROUND(SUM("Sales")::numeric, 2) AS total_sales,

    ROUND(
        SUM("Benefit per order")::numeric, 2
    ) AS total_recorded_benefit,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE "Delivery Status" = 'Late delivery'
        ) / COUNT(*),
        2
    ) AS late_delivery_percentage

FROM supply_chain

GROUP BY "Order Region"

ORDER BY total_sales DESC;


-- Question 10: Top 10 Customers by Sales

SELECT
    "Customer Id",

    "Customer Segment",

    COUNT(DISTINCT "Order Id") AS total_orders,

    ROUND(SUM("Sales")::numeric, 2) AS total_sales,

    ROUND(
        SUM("Benefit per order")::numeric, 2
    ) AS total_recorded_benefit

FROM supply_chain

GROUP BY
    "Customer Id",
    "Customer Segment"

ORDER BY total_sales DESC

LIMIT 10;


-- Question 11: Customer Sales Ranking

WITH customer_sales AS (
    SELECT
        "Customer Id",
        "Customer Segment",
        SUM("Sales") AS total_sales
    FROM supply_chain
    GROUP BY
        "Customer Id",
        "Customer Segment"
),

ranked_customers AS (
    SELECT
        "Customer Id",
        "Customer Segment",
        ROUND(total_sales::numeric, 2) AS total_sales,

        DENSE_RANK() OVER (
            ORDER BY total_sales DESC
        ) AS customer_rank

    FROM customer_sales
)

SELECT *
FROM ranked_customers
WHERE customer_rank <= 10
ORDER BY customer_rank;


-- Question 12: Month-over-Month Sales Growth

WITH monthly_sales AS (
    SELECT
        "Order_Year",
        "Order_Month",
        SUM("Sales") AS total_sales
    FROM supply_chain
    GROUP BY
        "Order_Year",
        "Order_Month"
),

sales_comparison AS (
    SELECT
        "Order_Year",
        "Order_Month",
        total_sales,

        LAG(total_sales) OVER (
            ORDER BY "Order_Year", "Order_Month"
        ) AS previous_month_sales

    FROM monthly_sales
)

SELECT
    "Order_Year",
    "Order_Month",

    ROUND(total_sales::numeric, 2) AS current_sales,

    ROUND(previous_month_sales::numeric, 2)
        AS previous_month_sales,

    ROUND(
    (
        100.0 * (total_sales - previous_month_sales)
        / NULLIF(previous_month_sales, 0)
    )::numeric,
    2
) AS month_over_month_growth_percentage

FROM sales_comparison

ORDER BY "Order_Year", "Order_Month";

SELECT
    "Shipping Mode",
    COUNT(DISTINCT "Order Id") AS total_orders,
    ROUND(
        AVG("Days for shipping (real)")::numeric, 2
    ) AS avg_actual_shipping_days,
    ROUND(
        AVG("Days for shipment (scheduled)")::numeric, 2
    ) AS avg_scheduled_shipping_days,
    ROUND(
        AVG("Shipping_Delay_Days")::numeric, 2
    ) AS avg_shipping_delay
FROM supply_chain
WHERE "Order Status" <> 'CANCELED'
GROUP BY "Shipping Mode"
ORDER BY avg_actual_shipping_days DESC;

WITH order_summary AS (
    SELECT
        "Order Id",
        "Customer Id",
        SUM("Sales") AS order_sales,
        SUM("Order Item Quantity") AS total_items
    FROM supply_chain
    GROUP BY "Order Id", "Customer Id"
)
SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(order_sales)::numeric, 2) AS total_revenue,
    ROUND(AVG(order_sales)::numeric, 2) AS average_order_value,
    ROUND(AVG(total_items)::numeric, 2) AS average_items_per_order,
    ROUND(MAX(order_sales)::numeric, 2) AS highest_order_value
FROM order_summary;

WITH category_performance AS (
    SELECT
        "Category Name",
        SUM("Sales") AS total_sales,
        SUM("Benefit per order") AS total_benefit,
        COUNT(DISTINCT "Order Id") AS total_orders
    FROM supply_chain
    GROUP BY "Category Name"
)
SELECT
    "Category Name",
    total_orders,
    ROUND(total_sales::numeric, 2) AS total_sales,
    ROUND(total_benefit::numeric, 2) AS total_recorded_benefit,
    ROUND(
        (100.0 * total_benefit / NULLIF(total_sales, 0))::numeric,
        2
    ) AS benefit_to_sales_percentage
FROM category_performance
ORDER BY benefit_to_sales_percentage ASC
LIMIT 10;