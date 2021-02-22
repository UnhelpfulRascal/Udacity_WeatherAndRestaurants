//dwh schema 
use role sysadmin;
use warehouse udacity_wh;
use database udacity_project;
use schema dwh;


create or replace table Dim_BusinessCheckinCovid (
  business_id string, 
  business_name string,
  address string,
  city string, 
  state string,
  business_rating float,
  checkin_dates string,
  highlights string
);
insert into Dim_BusinessCheckinCovid select distinct b.business_id, b.name, b.address, b.city, b.state, b.stars, ci.date, cf.highlights
from ods.business b, ods.checkin ci, ods.covid_features cf
where (b.business_id = ci.business_id) and (b.business_id = cf.business_id);


create or replace table Dim_UsersTip (
  user_id string,
  username string,
  review_count string,
  yelping_since timestamp_ntz,
  user_stars float,
  tip_text string
);
insert into Dim_UsersTip select distinct u.user_id, u.name, u.review_count, u.yelping_since, u.average_stars, t.text 
from ods.users u, ods.tip t
where (u.user_id = t.user_id);


create or replace table Integrate_ClimateYelp (
  review_id string,
  precipitation float,
  max_temperature float,
  rating float,
  date date
);
insert into Integrate_ClimateYelp select distinct r.review_id, p.precipitation, t.max, r.stars, r.date
from ods.reviews r, ods.precipitation p, ods.temperature t
where (to_date(r.date) = try_to_date(p.date, 'YYYYMMDD')) and (to_date(r.date) = try_to_date(t.date, 'YYYYMMDD'));


create or replace table Facts_WeathAndRest (
  business_id string,
  review_id string,
  user_id string,
  constraint fk_business_id foreign key (business_id) references ods.business (business_id), 
  constraint fk_review_id foreign key (review_id) references ods.reviews (review_id), 
  constraint fk_user_id foreign key (user_id) references ods.users (user_id)
);
insert into Facts_WeathAndRest select distinct b.business_id, r.review_id, u.user_id
from ods.business b, ods.reviews r, ods.users u
where (b.business_id = r.business_id) and (u.user_id = r.user_id); 