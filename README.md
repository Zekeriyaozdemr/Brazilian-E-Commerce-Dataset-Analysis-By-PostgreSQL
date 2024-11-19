The following data set was used in this analysis.
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

                                                                                         CASE 1 : Order Analysis
                                                                                         
Question 1: Examine order distributions monthly
"In November 2017, a record sales figure was achieved. 
The reason for this sales spike could be the Black Friday discounts. 
However, in December 2016, only 1 sale was recorded, and there were no sales in November. 
The issue here needs to be investigated to determine whether it is due to data loss or whether the company might have performed maintenance or something similar during that period. 
Seasonal analysis cannot be conducted because data for all months of every year is not available. 
The decline in December 2017 could be due to people making a lot of purchases in the previous month, as well as expectations of a New Year’s price increase."

Question 2: Examine order distributions in order status breakdown
"When we compare the number of canceled orders to the delivered orders, the cancellation rate is at a relatively positive level. 
A unique order ID has been assigned at every level where orders are present. 
However, we are focusing on the Delivered and Canceled/Unavailable orders in this analysis. 
In February 2018, the number of canceled orders significantly increased. We can revisit this by analyzing the order category breakdown. 
There has not been any dramatic decline in sales. 
Since we only have the complete data for 2017, we cannot make a year-over-year comparison, but it can be observed that sales in 2018 have increased compared to the previous year."

Question 3: Examine order quantities by product category
"The product categories with the highest sales are Home Goods and Health/Beauty products. 
Since our company is based in Brazil, it would be more accurate to consider the country's special holidays. 
When looking at special holidays, the top categories generally remain unchanged, while sales in lower-ranked categories, such as gift items, tend to increase. 
The 'Christmas' categories are typically sold before Christmas."

Question 4 (P1): Examine the number of orders based on days of the week
           (P2): Examine the number of orders based on days of the month
"When we look at the sales by day, Tuesday is the day with the highest sales. 
If we consider the month as a whole, the 24th of the month has the highest sales. 
This could be because customers who receive their salaries on Monday evening may start purchasing on Tuesday morning. 
Similarly, the high sales on the 24th could be due to private sector companies depositing salaries after the 20th of the month."

                                                                                        CASE 2 : Customer Analysis

Question 1: In Which Cities Do Customers Shop More? Determine the city where the customer orders the most and make the analysis accordingly.
"There is a single customer who has placed orders from more than one city. 
When we change the city to the one from which this customer placed the most orders, the result appears as shown in the table. 
In general, the customers who placed the most orders are from the cities in Brazil with the highest population and income levels. 
However, the city of 'Salvador' appears in 8th place despite being the 3rd largest city. 
The city with the highest number of orders is 'São Paulo', which accounts for nearly 30% of all orders. 
Due to the customer potential in this city, special campaigns could be targeted specifically at São Paulo and Salvador."

                                                                                        CASE 3 : Seller Analysis
                                                                                        
Question 1: Top 5 sellers who deliver orders to customers in the fastest way. Analysis was made based on customers whose average order quantity was over 30. 
"As a filter for the sellers who deliver orders to the customers the fastest, I based it on the time difference between the order creation date and the order delivery date. 
This is because, both the selection of the shipping company is actually the seller's responsibility, and in some cases, the order confirmation date appears later than the delivery date. 
The cause of this issue should be investigated.
In this query, only delivered orders were considered. The average scores and total reviews received by sellers have been grouped by seller.
Since there are many sellers who complete delivery within one day, the average sales volume of the sellers has been calculated, and only those who made 30 or more sales have been filtered.
The seller who delivers the order to the customer the fastest, with sales above average, is ranked first with 4 days. 
Their average score is higher than the others, and the number of reviews is at an average level. 
A motivational email could be sent to this seller, or a commission discount could be applied to some categories they are currently selling."

Question 2: Which Sellers Sell Products in More Categories? Do Sellers with Many Categories Have a High Number of Orders?
"In the query, categories with empty names have been labeled as 'UNKNOWN CATEGORY.' The top 50 sellers have been listed.
When counting categories by seller, the maximum number of categories with sales is 27. There are sellers who make much more sales across 10 different categories.
However, the seller with ID '955fee92-16a6-5b61-7aa5-c0531780ce60', who made a total of '1499 sales' across 23 different categories, can be considered a successful seller.
The conclusion to be drawn here is that selling products across more categories does not necessarily mean selling more products, but there are exceptional cases."

                                                                                          CASE 4 : Payment Analysis
                                                                                          
Question 1: In Which Region Do Users With High Number of Installments When Making Payments Live Most?
"In this query, the payment type used is credit card. The average installment amount is calculated based on the payment type and used as a filter.
In short, users who make installments above the average are classified as users with a high number of installments.
When counting these users by city, it is observed that the cities with the highest number of installments are the largest and most populous cities in Brazil.
Here, only 'Salvador' stands out, as despite being the 3rd largest city in Brazil, it ranks 7th in terms of cities making purchases with installments. 
This issue needs to be investigated to determine whether it is due to the shopping habits of the people in Salvador or insufficient customer reach."

Question 2: Calculate the Number of Successful Orders and Total Successful Payment Amount by Payment Type.
"Only 'DELIVERED' order statuses have been considered as successful orders. 
According to this filter, 74% of users use credit cards. Only 2% of users use debit cards. 
24% of customers make purchases using coupons and tickets. In this region, companies may be providing employees with gift vouchers and coupons at the end of the month."

Question 3: Make Category Based Analysis of Orders Paid in Single Payment and Installments. In which categories is payment in installments used most?
"In this query, where we performed a count by category, products with missing category names have been grouped under the heading 'UNKNOWN CATEGORY.'
The total sales quantity, installment-based, cash, and card types for all product categories have been ranked. 
Upon review, the most sold order categories are Home Goods, Beauty Products, Sports Goods, and Computer Accessories.
A large percentage of products purchased with credit cards are bought in installments.
Products bought in a single payment are generally much cheaper.
For products purchased primarily in installments, offering discounts for cash payments could help reduce installment purchases. 
For more expensive products, the number of installments could be reduced. 
For cheaper but frequently purchased products, a limit on the number of installments could be set, encouraging customers to make cash purchases instead."

                                                                                            CASE 5 : RFM ANALYSIS

"In the RFM analysis of the Olist dataset, customer segmentation has been classified according to the range specified above.
The table shown above is the output we obtained. The group we have classified as 'CHAMPIONS' is our most valuable customer group. 
However, the number of customers in this group is so small that it can be considered negligible. The group of customers most likely to be lost is classified as 'AT RISK.'
Our goal should be to work on strategies to move each customer group to a higher tier.
The 'LOYAL' customer group is the one that spends the most money and generates the highest profit for the company.
The absence of the 'CHAMPIONS' group may be due to the fact that very expensive products are not sold frequently.
Therefore, we could consider offering short-term, site-wide discounts. 
By analyzing which product categories have lower sales, we could apply targeted discounts to those categories in order to increase customer variety."


