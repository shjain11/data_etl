-- Anonymiize the Data by creating masking policy

--- NAME masking policy
create masking policy name_masking_policy
as (val string)
returns string ->
case
    when current_role() in ('sysadmin') then val -- Admin users see the full name
    else '***' -- All other users see masked data
end;


--- EMAIL masking policy
create masking policy email_masking_policy
as (val string)
returns string ->
case
    when current_role() in ('sysadmin') then val -- Admin users see the full name
    else md5(split_part(val, '@', 1)) || '@' || split_part(val, '@', 2 )-- All other users see masked data
end;



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

alter table persons modify column first_name set masking policy name_masking_policy;
alter table persons modify column last_name set masking policy name_masking_policy;
alter table persons modify column email set masking policy email_masking_policy;


with persons as (

select
    id
    , split_part(email, '@', 2) as email_provider
    , year(current_date) - year(birthday) as age
    , case when age <= 10 then '0-10'
        when age > 10 and <= 20 then '11-20'
        when age > 20 and <= 20 then '21-30'
        when age > 30 and <= 20 then '31-40'
        when age > 40 and <= 20 then '41-50'
        when age > 50 and <= 20 then '51-60'
        when age > 60 and <= 20 then '61-70'
        when age > 70 and <= 20 then '71-80'
        when age > 80 and <= 20 then '81-90'
        when age > 90 and <= 20 then '91-1000'
        else '>100' end as age_group
    , address:country as country

from db.schema.persons

)


-- Which percentage of users live in Germany and use Gmail as an email provider?

, total_users as (
    select
        count(*) as total_user
    from persons
)

, germany_gmail_user as (
    select
        count(*) as germany_gmail_count

    from persons

    where lower (country) = 'germany'
        and lower(email_provider) = 'gmail.com'
)

select
    (germany_gmail_count / total_user) * 100 AS percentage_germany_gmail_users

from  germany_gmail_users, total_users;



-- Which are the top three countries in our database that use Gmail as an email provider (Note: Multiple countries can share the same rank.)

select
    country
    , count(*) as gmail_user_count

from persons
where lower(email_provider) = 'gmail.com'
group by 1
order by 2 desc
limit 3,


-- How many people over 60 years use Gmail as an email provider?

select
    count(*) as gmail_users_over_60

from persons

where lower(email_provider) = 'gmail.com'
  and where age_group in ('61-70', '71-80', '81-90', '>100')
