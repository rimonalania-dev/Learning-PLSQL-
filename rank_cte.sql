with sales_sum as
(SELECT
    to_char(trans_date,'mm/yyyy') as trans_date
    ,product_id
    ,round(sum((unit_price * quantity)),2) as sale_amt
FROM
    sales
WHERE 1 = 1
and to_char(trans_date,'yyyy') = '2019'
group by 
to_char(trans_date,'mm/yyyy')
,product_id)
select 
    product_id
    ,trans_date
    ,sale_amt
    ,rank() over (partition by trans_date order by sale_amt desc) as rank
from sales_sum
where sale_amt >= 5000

/


