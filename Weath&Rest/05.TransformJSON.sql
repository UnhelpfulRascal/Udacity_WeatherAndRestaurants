//create schema for staging
use role sysadmin;
use warehouse udacity_wh;
use database udacity_project;
create or replace schema staging;
use schema staging;

// temp storage for json to csv to transform data
create or replace file format json_to_csv_format
  field_delimiter = none
  record_delimiter = '\\n';

create or replace stage json_stage
  file_format = json_to_csv_format;
 
 
-- run in terminal or shell
put file://d:\Documents\Adipster\WeatherAndRestaurants\business.json @json_stage auto_compress=true;
put file://d:\Documents\Adipster\WeatherAndRestaurants\checkin.json @json_stage auto_compress=true;
put file://d:\Documents\Adipster\WeatherAndRestaurants\covid_features.json @json_stage auto_compress=true;
put file://d:\Downloads\reviews*.json @json_stage auto_compress=true;
put file://d:\Documents\Adipster\WeatherAndRestaurants\tip.json @json_stage auto_compress=true;
put file://d:\Downloads\users*.json @json_stage auto_compress=true;


list @json_stage;


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
    hours variant
);


copy into business(business_id, name, address, city, state, postal_code, latitude, longitude, 
                   stars, review_count, is_open, attributes, categories, hours)
   from (select parse_json($1):business_id, parse_json($1):name, parse_json($1):address, parse_json($1):city, parse_json($1):state,
         parse_json($1):postal_code, parse_json($1):latitude, parse_json($1):longitude, parse_json($1):stars, parse_json($1):review_count, 
         parse_json($1):is_open, parse_json($1):attributes, parse_json($1):categories, parse_json($1):hours
         from @json_stage/business.json.gz t)
   on_error = 'continue';
   

create or replace table checkin (
    business_id string,
    date string
);

copy into checkin(business_id, date)
   from (select parse_json($1):business_id, parse_json($1):date
         from @json_stage/checkin.json.gz)
   on_error = 'continue';

create or replace table covid_features (
   business_id string,
   highlights string,
   "delivery or takeout" boolean,
   "Grubhub enabled" boolean,
   "Call To Action enabled" boolean,
   "Request a Quote Enabled" boolean,
   "Covid Banner" string,
   "Temporary Closed Until" string,
   "Virtual Services Offered" string
);


copy into covid_features(business_id, highlights, "delivery or takeout", "Grubhub enabled", "Call To Action enabled", "Request a Quote Enabled", 
                         "Covid Banner", "Temporary Closed Until", "Virtual Services Offered")
   from (select parse_json($1):business_id, parse_json($1):highlights, parse_json($1):"delivery or takeout", parse_json($1):"Grubhub enabled", 
         parse_json($1):"Call To Action enabled", parse_json($1):"Request a Quote Enabled", parse_json($1):"Covid Banner", 
         parse_json($1):"Temporary Closed Until", parse_json($1):"Virtual Services Offered"
         from @json_stage/covid_features.json.gz t)
   on_error = 'continue';


create or replace table reviews (
    review_id string,
    user_id string,
    business_id string,
    stars float,
    useful number,
    funny number,
    cool number,
    text string, 
    date timestamp_ntz
);


copy into reviews(review_id, user_id, business_id, stars, useful, funny, cool, text, date)
   from (select parse_json($1):review_id, parse_json($1):user_id, parse_json($1):business_id, parse_json($1):stars, parse_json($1):useful, 
         parse_json($1):funny, parse_json($1):cool, parse_json($1):text, to_timestamp_ntz(parse_json($1):date)
         from @json_stage t)
   pattern='.*reviews[0-9].json.gz'
   on_error = 'continue';


create or replace table tip (
    user_id string,
    business_id string,
    text string,
    date timestamp_ntz,
    compliment_count number
);


copy into tip(user_id, business_id, text, date, compliment_count)
   from (select parse_json($1):user_id, parse_json($1):business_id, parse_json($1):text, 
         to_timestamp_ntz(parse_json($1):date), parse_json($1):compliment_count
         from @json_stage/tip.json.gz t)
   on_error = 'continue';


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
    compliment_photos number
);


copy into users(user_id, name, review_count, yelping_since, useful, 
                funny, cool, elite, friends, fans, average_stars, 
                compliment_hot, compliment_more, compliment_profile, 
                compliment_cute, compliment_list, compliment_note, compliment_plain,
                compliment_cool, compliment_funny, compliment_writer, compliment_photos)
   from (select parse_json($1):user_id, parse_json($1):name, parse_json($1):review_count, parse_json($1):yelping_since, parse_json($1):useful, 
         parse_json($1):funny, parse_json($1):cool, parse_json($1):elite, parse_json($1):friends, parse_json($1):fans, parse_json($1):average_stars, 
         parse_json($1):compliment_hot, parse_json($1):compliment_more, parse_json($1):compliment_profile, parse_json($1):compliment_cute, 
         parse_json($1):compliment_list, parse_json($1):compliment_note, parse_json($1):compliment_plain, parse_json($1):compliment_cool,
         parse_json($1):compliment_funny, parse_json($1):compliment_writer, parse_json($1):compliment_photos
         from @json_stage t)
   pattern='.*users[0-4].json.gz'
   on_error = 'continue';


show tables