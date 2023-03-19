-- Which are the top 10 members by spending
select member_id, row_number() over (partition by member_id order by total_amount desc) as top_spending
from
(select s.member_id, sum(p.amount)  as total_amount
from sales s 
inner join transaction t on s.transaction_id = t.id
inner join payment p on t.payment_id = p.id
group by s.member_id) acc
where acc.top_spending <= 10;

-- Which are the top 3 items that are frequently brought by members
select i.name, row_number() over (partition by i.name order total_purchase desc) as top_purchase
from (select t.item_id, count(*) as total_purchase
from transaction t
group by t.item_id) acc
inner join item i on acc.item_id = i.id
where acc.top_purchase <= 3;