-- Create person table

create table if not exists persons as (
    id int,
    first_name text,
    last_name text,
    email text,
    phone text,
    birthday date,
    gender text,
    address variant,
    website,
    image text
):



-- SQL to Anonymize the data

with persons as (

select 
    id
    , split_part(email, '@', 2) as email_provider
    , year(current_date) - year(birthday) as age
    , case when age <= 10 then [0-10]
        when age > 10 and <= 20 then [11-20]
        when age > 20 and <= 20 then [21-30]
        when age > 30 and <= 20 then [31-40]
        when age > 40 and <= 20 then [41-50]
        when age > 50 and <= 20 then [51-60]
        when age > 60 and <= 20 then [61-70]
        when age > 70 and <= 20 then [71-80]
        when age > 80 and <= 20 then [81-90]
        when age > 90 and <= 20 then [91-1000]
        else [>100] end as age_group
    , address:country as country

from db.schema.persons

)

-- Which percentage of users live in Germany and use Gmail as an email provider?




-- Which are the top three countries in our database that use Gmail as an email provider (Note: Multiple countries can share the same rank.)

-- How many people over 60 years use Gmail as an email provider?