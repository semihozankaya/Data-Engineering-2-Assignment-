## Clear your memory and ready the packages
rm(list = ls())
library(tidyverse)

## Define your working folder
folder <- "/home/ozzy/Documents/CEU/DE2/Assignment/Data/"

## Read the raw data (the data can be found in https://www.kaggle.com/carrie1/ecommerce-data)
df <- read_csv(paste0(folder, "Raw/data.csv"))

## Change the date to datetime format
df$InvoiceDate <- as.POSIXct(df$InvoiceDate, format="%m/%d/%Y %H:%M",tz= "GMT")   

## Define the biggest customers in terms of Country of origin
frequency_per_country <- df %>% group_by(Country) %>% count(InvoiceNo) %>% count(Country) %>% arrange(-n)

## Since UK is by far the largest consumer base, take only UK for analysis
df2 <- df %>% filter(Country %in% frequency_per_country$Country[1])

## Filter the returns and take only orders
df2 <- df2 %>% filter(Quantity > 0)

## Filter Stock Code and Item Description
df2 <- df2 %>% select(-2, -3)

## Define a new variable, Price * Quantity
df2 <- df2 %>% mutate(TotalSale = UnitPrice*Quantity)

## Check how many items are ordered per invoice
frequency_per_customer <- df2 %>% group_by(InvoiceNo) %>% count(InvoiceNo) %>% arrange(-n)

## Visualization of order count per invoice
ggplot(frequency_per_customer, aes(x = n)) + geom_histogram(bins = 100) +  geom_vline(xintercept=40, color = "navyblue") 

## We make a judgement call here and take observations that have order counts less than 40 since
# we suspect the higher order counts are placed by wholesale accounts and they don't take weather
# into consideration since their rationale for order is not consumption but stock management.
wholesalers_invoice <- filter(frequency_per_customer, n > 40) %>% select(InvoiceNo) 

## Filtering for the Customers that could be wholesalers by our standards
wholesalers_customerid <- df2 %>% filter(InvoiceNo %in% wholesalers_invoice[[1]]) %>% select(CustomerID)
wholesalers_customerid <- unique(wholesalers_customerid$CustomerID)

## Filtering for other customers
df3 <- df2 %>% filter(!(CustomerID %in% wholesalers_customerid))

## Write the clean data
write_csv(df3, paste0(folder, "Clean/sales.csv"))
