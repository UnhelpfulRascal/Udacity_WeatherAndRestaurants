use role sysadmin;
use warehouse udacity_wh;
use database udacity_project;
use schema dwh;


//list the ratings for each business review with corresponding precipitation and maximum temmperature values    

select Dim_BusinessCheckInCovid.business_name, Integrate_ClimateYelp.precipitation, Integrate_ClimateYelp.max_temperature, Integrate_ClimateYelp.rating
  from Dim_BusinessCheckInCovid
     join Facts_WeathAndRest on (Dim_BusinessCheckInCovid.business_id = Facts_WeathAndRest.business_id)
     join Integrate_ClimateYelp on (Integrate_ClimateYelp.review_id = Facts_WeathAndRest.review_id)
  where (Dim_BusinessCheckInCovid.city = 'Las Vegas') and (Dim_BusinessCheckInCovid.state = 'NV')
  order by Integrate_ClimateYelp.rating desc;

   
 //list the count for 5 star rating for each businesses with corresponding precipitation and maximum temperature values  
                                  
select Dim_BusinessCheckInCovid.business_name, count_if(Integrate_ClimateYelp.rating = 5) as FIVE_STAR_RATING, 
       avg(Integrate_ClimateYelp.precipitation) as AVE_PRECIP, min(Integrate_ClimateYelp.precipitation) as MIN_PRECIP, max(Integrate_ClimateYelp.precipitation) as MAX_PRECIP, 
       avg(Integrate_ClimateYelp.max_temperature) as AVE_TEMP, min(Integrate_ClimateYelp.max_temperature) as MIN_TEMP, max(Integrate_ClimateYelp.max_temperature) as MAX_TEMP
  from Dim_BusinessCheckInCovid
     join Facts_WeathAndRest on (Dim_BusinessCheckInCovid.business_id = Facts_WeathAndRest.business_id)
     join Integrate_ClimateYelp on (Integrate_ClimateYelp.review_id = Facts_WeathAndRest.review_id)
  where (Dim_BusinessCheckInCovid.city = 'Las Vegas') and (Dim_BusinessCheckInCovid.state = 'NV')
  group by Dim_BusinessCheckInCovid.business_name
  order by count_if(Integrate_ClimateYelp.rating = 5) desc;
/*it can be noted that most 5 star rating was given to the business when the average precipitation and maximum temperature are
close to 2 inches and 61.5 degree fahrenheit respectively.*/

