use ev_sales;
select * from sales;
select * from products;
select * from emails;
select * from email_subject;

select * from sprint_sales_2016;
select * from cumulative_sales_2016 order by cumulative_sales ;

create view cumulative_sales_week as
select date(sales_transaction_date) as new_date, count(*) as `no of unit sold`, sum( count(*)) over (order by date(sales_transaction_date)
rows between 6 preceding and current row) as cumulative_sales from sales where product_id = 7 and date(sales_transaction_date) 
between "2016-10-10" and "2016-10-25" group by date(sales_transaction_date);

select * from cumulative_sales_week;

select cu.new_date, cu.`no of unit sold`, cu.cumulative_sales,
ct.cumulative_sales as ct_sales,round( (cu.cumulative_sales - ct.cumulative_sales) / ct.cumulative_sales,2) as "%growth"
from cumulative_sales_week as cu inner join cumulative_sales_week as ct on 
cu.new_date = ct.new_date + interval 1 day where date(cu.new_date) > '2016-10-16';



-- 1. What is the cummulative sales volume ( in units) for the first 7 days between 10- 10 -
-- 2016 and 16-`10-2016
select * from cumulative_sales_week where new_date = "2016-10-16";


-- 2. On 20th Oct, What are the last 7 days' Cumulative sales of Sprint Scooter ( in units)
select * from cumulative_sales_week where new_date = "2016-10-20" ;


-- 3. On which date did the sales volume reach its highest point?
 select sales_transaction_date,count(customer_id) as Units from sales 
 where product_id = 7 
 group by date(sales_transaction_date) order by count(customer_id) desc limit 1;


-- 4. On 22 -10-2016 by what percentage cummulative sales of last 7 days dropped 
-- compared to last 7 days cummulative sales on 21-10-2016 ?
select cu.new_date, cu.`no of unit sold`, cu.cumulative_sales,
ct.cumulative_sales as ct_sales,round( (cu.cumulative_sales - ct.cumulative_sales) / ct.cumulative_sales,2) as "%growth"
from cumulative_sales_week as cu inner join cumulative_sales_week as ct on 
cu.new_date = ct.new_date + interval 1 day where cu.new_date in("2016-10-22" ,"2016-10-21");






-- 1. Collect email campaign-related data specifically for Sprint scooters.
select date(emails.sent_date) as sent_date, emails.customer_id,count(emails.email_id) Total_Emails, email_subject
from emails join email_subject on emails.email_subject_id = email_subject.email_subject_id 
where emails.email_subject_id =7 group by customer_id ;

select date(emails.sent_date) as sent_date, email_subject, count(emails.customer_id) as total_sales
from emails join email_subject on emails.email_subject_id = email_subject.email_subject_id where date(sent_date)> "2016-09-01" group by emails.email_subject_id ;


-- 2. Include data from the period of 2 months before the sprint model launch, as the 
-- digital marketing campaign started only 2 months before the launch.
select emails.*,email_subject from emails join email_subject on emails.email_subject_id = email_subject.email_subject_id 
where date(sent_date) between "2016-08-01" and "2016-10-01";

-- 3. Connect the two data sets considering that a single customer may have received multiple emails for different products during the campaign
select emails.customer_id, emails.email_subject_id,email_subject from
emails join email_subject on emails.email_subject_id = email_subject.email_subject_id 
group by customer_id,email_subject_id;

select customer_id,count(emails.email_subject_id)as Total_Email from
emails join email_subject on emails.email_subject_id = email_subject.email_subject_id 
group by customer_id;


-- 4. To calculate the Click Rate, Refer to the following formula:
--       Click Rate = ( E-mails Clicked ) / ( E-mail sent - Bounced )
-- Prepare the summary table that shows the comparison between the calculated email 
-- opening rate & Click Rate against the benchmark rates. Typically the industry 
-- benchmark for a quality campaign is an 18% email opening rate and an 8% Click Rat
select emails.email_subject_id,email_subject, count(opened_1)/count(*) as Open_rate from
(select opened as Open_1 from emails where opened = "t") inner join email;

select op.email_subject_id, count(op.opened) / count(top.customer_id) as open_rate from
emails as op inner join emails as top on op.customer_id = top.customer_id where op.opened= "t" group by op.email_subject_id;

select count(*) from emails;
select count(opened) from emails where opened="t";

-- select email_subject_id, count(clicked)/( count(sent_date)-count(bounced) ) as clicked_rate from emails where bounced = "t" group by email_subject_id;

-- select email_subject_id, count(clicked)/( count(sent_date) ) as clicked_rate from emails where clicked = "t" group by email_subject_id;

-- select email_subject_id, count(clicked)/( count(sent_date) ) as clicked_rate from emails where clicked = "t" group by email_subject_id;


select e_s_i, (t_click/t_c) as  Click_Rate from
	(select email_subject_id as e_s_i, count(clicked) as t_click from emails where clicked = "t" group by e_s_i )as stat,
	(select count(*) as t_c from emails) as stat1;
    
select e_s_i, (t_open/t_o) as Open_Rate from
	(select email_subject_id as e_s_i , count(opened) as t_open from emails where opened="t" group by e_s_i)as open_up,
    (select count(*) as t_o from emails)as open_down ;

--------------------------------------------------------------------------------------------------------------------------------------------------------

select concat((t_click/t_c)*100," %") as  Click_Rate from
	(select email_subject_id as e_s_i, count(clicked) as t_click from emails where clicked = "t" )as stat,
	(select count(*) as t_c from emails) as stat1;
    
select concat((t_open/t_o)*100," %") as Open_Rate from
	(select email_subject_id as e_s_i , count(opened) as t_open from emails where opened="t" )as open_up,
    (select count(*) as t_o from emails)as open_down ;










