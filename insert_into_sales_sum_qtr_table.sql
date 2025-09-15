DECLARE
    v_time_start number;
    v_time_end number;    
    v_time_diff number;  
     v_rows number := 0;
cursor x is 
SELECT
    store_id
    ,product_id
    ,to_char(trans_date,'yyyy') trans_yr
    ,(case 
        when (to_char(trans_date,'mm')) >= '10' then 'Q4' 
        when (to_char(trans_date,'mm'))  >= '07' then 'Q3' 
        when (to_char(trans_date,'mm'))  >= '04' then 'Q2' 
        else 'Q1' end    
     ) sales_qtr
    ,(unit_price * quantity) as sales_amt
FROM 
    sales 
WHERE 1=1
and to_char(trans_date,'yyyy') = '2018';

begin 
   v_time_start := dbms_utility.get_time;
for i in x LOOP
  insert into sales_sum_qtr
  values(i.store_id,i.product_id,i.trans_yr,i.sales_qtr,i.sales_amt);
  v_rows := v_rows + SQL%ROWCOUNT;
  commit;
END LOOP;
    dbms_output.put_line('Records processed: '||to_char(v_rows));
    v_time_end := dbms_utility.get_time;    
    v_time_diff := (v_time_end - v_time_start) / 100;    
    dbms_output.put_line('Elapsed time: '|| v_time_diff ||' secs.');
EXCEPTION
    when others THEN
        dbms_output.put_line(sqlerrm);    
end;



