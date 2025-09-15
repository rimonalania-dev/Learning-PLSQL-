declare
   v_time_start    number;
   v_time_end      number;
   v_time_diff     number;
   v_rows          number := 0;
   type qtr_sales is
      table of sales_sum_qtr%rowtype;
   v_tab_qtr_sales qtr_sales;
begin
   v_time_start := dbms_utility.get_time;
   select store_id
        ,product_id
        ,to_char(trans_date,'yyyy') trans_yr
        ,(case
                when (to_char(trans_date,'mm')) >= '10' then 'Q4'
                when (to_char(trans_date,'mm')) >= '07' then 'Q3'
                when (to_char(trans_date,'mm')) >= '04' then 'Q2'
                else 'Q1'
             end) sales_qtr
        ,( unit_price * quantity ) as sales_amt
   bulk collect
     into v_tab_qtr_sales
     from sales
    where 1 = 1
      and to_char(trans_date,'yyyy') = '2018';

   forall i in v_tab_qtr_sales.first..v_tab_qtr_sales.last
      insert into sales_sum_qtr values ( v_tab_qtr_sales(i).store_id,
                                         v_tab_qtr_sales(i).product_id,
                                         v_tab_qtr_sales(i).trans_yr,
                                         v_tab_qtr_sales(i).sales_qtr,
                                         v_tab_qtr_sales(i).sales_amt );
   v_rows := v_rows + sql%rowcount;
   commit;
   dbms_output.put_line('Records processed: ' || to_char(v_rows));
   v_time_end := dbms_utility.get_time;
   v_time_diff := ( v_time_end - v_time_start ) / 100;
   dbms_output.put_line('Elapsed time: '|| v_time_diff|| ' secs.');
exception
   when others then
      dbms_output.put_line(sqlerrm);
end;