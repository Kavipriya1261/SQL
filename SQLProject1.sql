use shopping;

create table customers 
(Customer_id int not null ,  
Customer_name varchar(100) not null,   
Age int not null,  
Location varchar (100) not null,
 Previous_purchased int not null );
  
  alter table customers 
  add constraint pk_custom primary key (Customer_id);
desc customers;
select *  from customers;
create index idx_customer
on customers(Customer_id);

create table product
(Customer_id int not null,
Product varchar (100) not null,
Category varchar(100) not null);

 alter table product 
 add foreign key (Customer_id) references customers (Customer_id);
 desc product;
 create index idx_product
 on product(Product);
 select * from product;
 
 create table details
(Customer_id int not null, Product varchar (100) not null,
Size Varchar(22) not null,
color varchar(50) not null,
season varchar(90) not null,
review_rating int,
foreign key (Customer_id) references customers(Customer_id),
foreign key(Product) references product(Product)
);
desc details;
select *from details;


create table coupon_codes
(Customer_id int not null,
Subscription_status varchar(90) not null,
Discount_status varchar (90) not null, Promo_code varchar (90));
desc coupon_codes;
alter table coupon_codes
add foreign key(Customer_id) references customers(Customer_id);
select * from coupon_codes;


create table payment
(Customer_id int not null,
shipping_type varchar(100) not null,
payment_method varchar (90) not null,
purchase_interval varchar(90) not null,
purchase_date date not null
);
alter table payment 
add constraint pk foreign key(Customer_id) references customers(Customer_id);
alter table payment add (payment_amount int);
desc payment;
select * from payment;


-----
update payment set 
purchase_interval = 'Two weeks' where purchase_interval = 'Fortnightly';

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));


---To fetch number of products purchased by each customer---

select distinct Customer_name,count(Product) as total_product, Product from  customers 
join product on customers.Customer_id = product.Customer_id 
 group by Customer_name order by count(Product) desc ;

---To fetch least purchased customers---

select * from customers 
 where Previous_purchased <10 order by Previous_purchased desc ;

---To find customers based on total amount paid---
 
 select Customer_name, sum(payment_amount) as Total_amount_paid,
 round(avg(payment_amount),2) as avg_amount_paid
 from customers join payment on customers.Customer_id=payment.Customer_id 
 group by Customer_name having sum(payment_amount)> 500
 order by sum(payment_amount) desc;

---To find payment method used by each customers---
 
 SELECT  Customer_name,payment_method, count(payment_method) as times_used from customers
 left join payment on customers.Customer_id=payment.Customer_id
 group by Customer_name;

---To select least reviewed products count---

 select distinct Customer_name, review_rating,count( product ) as products_reviewed 
 from customers 
 join details on customers.Customer_id=details.Customer_id 
 where review_rating < 4 group by Customer_name;

---To find the Active Customers---
 
 select Customer_name, purchase_interval from customers
 join payment on customers.Customer_id=payment.Customer_id
 where purchase_interval = 'Weekly'  order by Customer_name ;

---operators---
select concat_ws('-',Product,Size,color) as products, season from details 
where season like '%_a__%'  ;
select concat_ws('-',Product,Size,color) as products, season from details 
where season between 'Summer' and 'Winter' ;

---joins---
select distinct Customer_name, payment_amount, Product from customers
join payment on customers.Customer_id=payment.payment_amount
join details on payment.Customer_id=details.Customer_id
where payment_amount > 50 and payment_amount <80;

----Case----
SELECT 
    Product,
    sum(payment_amount) as Summation_amount,
    CASE
        WHEN payment_amount BETWEEN 20 AND 40 THEN 'cheap'
        WHEN payment_amount BETWEEN 41 AND 69 THEN 'affordable'
        WHEN payment_amount BETWEEN 70 AND 100 THEN 'expensive'
        else 'moderate'
    END AS cost_label
from product join payment on product.Customer_id=payment.Customer_id group by Product;

----view---
select * from purchased_day order by Location;

----stored procedure----
call Product_info;
      
	 
 
 
 
 
 
 










