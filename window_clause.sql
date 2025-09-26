-- WINDOW Clause
-- In previous releases the window frame was defined as part the analytic function call. 
-- The following query uses the FIRST_VALUE analytic function to display the lowest salary in each department, along with the raw data about the employees in the department.
select segment,
       discount_band,
       round(sum(gross_sales)) total_sales,
       first_value(round(sum(gross_sales)))
       over(partition by discount_band
            order by round(sum(gross_sales))
       ) lowest_total
  from fin_trans_sample
 where 1 = 1
 group by segment,
          discount_band
/

-- using WINDOW clause
with sales_gross as (
   select segment,
          discount_band,
          sum(gross_sales) total_sales
     from fin_trans_sample
    where 1 = 1
    group by segment,
             discount_band
)
select segment,
       discount_band,
       total_sales,
       first_value(total_sales)
       over w1 as lowest_total_sales
  from sales_gross
window w1 as ( partition by discount_band
               order by total_sales );