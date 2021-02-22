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