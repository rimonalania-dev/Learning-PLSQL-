-- time_bucket
select sale_date  
,TIME_BUCKET(sale_date, INTERVAL '3' MONTH, DATE '2000-01-01', start) as ThreeMonth_Buckets
,TIME_BUCKET(sale_date, INTERVAL '3' YEAR, DATE '2000-01-01', start)  as ThreeYear_Buckets
from fin_trans_sample  
