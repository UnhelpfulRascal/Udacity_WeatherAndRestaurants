//create new schema 
use role sysadmin;
use warehouse udacity_wh;
use database udacity_project;
create or replace schema ods; 
use schema ods;


create or replace table precipitation (
    date string,
    precipitation float,
    precipitation_normal float
);
insert into precipitation select * from staging.precipitation;


create or replace table temperature (
    date string,
    min float,
    max float,
    normal_min float,
    normal_max float
);
insert into temperature select * from staging.temperature;


create or replace table business (
    business_id string,
    name string,
    address string,
    city string,
    state string,
    postal_code string,
    latitude float,
    longitude float,
    stars float,
    review_count number,
    is_open number,
    attributes variant,
    categories string,
    hours variant,
    constraint pk_business_id primary key (business_id)
);
insert into business select * from staging.business;


create or replace table checkin (
    business_id string,
    date string,
    constraint fk_business_id foreign key (business_id) references business(business_id) 
);
insert into checkin select * from staging.checkin;


create or replace table covid_features (
   business_id string,
   highlights string,
   "delivery or takeout" boolean,
   "Grubhub enabled" boolean,
   "Call To Action enabled" boolean,
   "Request a Quote Enabled" boolean,
   "Covid Banner" string,
   "Temporary Closed Until" string,
   "Virtual Services Offered" string,
   constraint fk_business_id foreign key (business_id) references business(business_id)
);
insert into covid_features select * from staging.covid_features;


create or replace table users (
    user_id string,
    name string,
    review_count string,
    yelping_since timestamp,
    useful number,
    funny number,
    cool number,
    elite string,
    friends variant,
    fans number,
    average_stars float,
    compliment_hot number,
    compliment_more number,
    compliment_profile number,
    compliment_cute number,
    compliment_list number,
    compliment_note number,
    compliment_plain number,
    compliment_cool number,
    compliment_funny number,
    compliment_writer number,
    compliment_photos number,
    constraint pk_user_id primary key (user_id)
);
insert into users select * from staging.users;


create or replace table reviews (
    review_id string,
    user_id string,
    business_id string,
    stars float,
    useful number,
    funny number,
    cool number,
    text string, 
    date timestamp_ntz,
    constraint pk_review_id primary key (review_id), 
    constraint fk_user_id foreign key (user_id) references users(user_id),
    constraint fk_business_id foreign key (business_id) references business(business_id)
);
insert into reviews select * from staging.reviews;


create or replace table tip (
    user_id string,
    business_id string,
    text string,
    date timestamp_ntz,
    compliment_count number,
    constraint fk_user_id foreign key (user_id) references users(user_id),
    constraint fk_business_id foreign key (business_id) references business(business_id)
);
insert into tip select * from staging.tip;
