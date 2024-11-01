--Creating Gym_Tracking Table

create table Gym_Tracking(
	Gym_id int,
	Age int,
	Gender Varchar(25),
	Weight float,
	Height float,
	Max_BPM numeric,
	Avg_BPM numeric,
	Resting_BPM numeric,
	Session_Duration float,
	Calories_Burned numeric,
	Workout_Type varchar(100),
	Fat_Percentage float,
	Water_Intake float,
	Workout_Frequency int,
	BMI float	
);


select * from Gym_Tracking;


-- 1. Find Average Age of Gym Members?

select round(avg(age),0) as average_age 
from Gym_Tracking;


-- 2. Find Average Age of Gym Members Based on Gender?

select Gender,round(avg(age),0) as average_age 
from Gym_Tracking
group by Gender;

-- 3.Count the Number of Each Gender?

select Gender,Count(*)
from Gym_Tracking
group by Gender;

-- 4.Find all Unique Workout Type Categories?

select distinct(Workout_Type) from Gym_Tracking;



-- 5.Find Average BMI of both Genders?

select Gender, round(avg(BMI)::numeric,2) as Average_BMI
from Gym_Tracking
group by Gender;

-- 6.Determione Calories Burnt for Each Workout_Type?

select Workout_Type, sum(Calories_Burned) as Total_Calories_Burned
from Gym_Tracking
group by Workout_Type;


-- 7.Caluclate Average Session_Duration  for Members Aged over 40.

select round(avg(Session_Duration)::numeric,2) as Average_Session
from Gym_Tracking
where age>=40;


-- 8. Find the Count of Members have a Workout_Frequency  Greater than the Average?

select count(gym_id)
from gym_tracking
where Workout_Frequency>(select avg(Workout_Frequency) from gym_tracking);


-- 9.Find the Most Common Workout_Type in both Genders?

with GenderWorkoutCount as (
    select Gender,Workout_Type,count(*) as Frequency
    from Gym_Tracking
    group by Gender,Workout_Type
)
select Gender,Workout_Type
from GenderWorkoutCount as gw
where Frequency=(
    select max(Frequency)
    from GenderWorkoutCount
    where Gender=gw.Gender
);

-- 10.Caluclate Average Calories_Burned for each age group (in intervals of 10 years)?

select
    concat(floor((Age-0.1)/10)* 10,'-',floor((Age-0.1)/10)*10+10) as Age_Group,
    round(avg(Calories_Burned),2) as Avg_Calories_Burned
from Gym_Tracking
group by Age_Group
order by Age_Group;


-- 11. Find the Average Calories_Burned for Members with Fat_Percentage Above and Below 25?

select
		case when Fat_Percentage>25 then 'Above 25%' else 'Below 25%' end as Fat_Category,
        round(avg(Calories_Burned),2) as average_calories_burnt
from Gym_Tracking
group by Fat_Category;



-- 12.Find the highest Calories_Burned for each Workout_Type?

select Workout_Type, max(Calories_Burned) as Maximum_Calories_Burned
from Gym_Tracking
group by Workout_Type
order by Maximum_Calories_Burned;



-- 13.Find the average Max_BPM for members whose Session_Duration is above the median?

with Median_Session_Duration as(
	select percentile_cont(0.5) within group(order by Session_Duration) as Median
	from Gym_Tracking
)
select round(avg(Max_BPM),2) as Average_Max_BPM
from Gym_Tracking,Median_Session_Duration
where Session_Duration>Median;


-- 14.Find the Correlation between BMI and Calories_Burned?

select round(corr(BMI,Calories_Burned)::numeric,2) as BMI_Calories_Correlation 
from Gym_Tracking;

-- 15. Find Top 10 members with the highest Calories_Burned per session?

select gym_id,Calories_Burned
from Gym_Tracking
order by Calories_Burned desc
limit 10;


-- 16.Find the Average Resting_BPM for Members who perform Cardio more than twice a week?


select round(avg(Resting_BPM),2) as Average_Resting_BPM
from Gym_Tracking
where Workout_Type='Cardio' and Workout_Frequency>2;


-- 17. Determine the average and maximum Session_Duration  for each gender?


select Gender, round(avg(Session_Duration)::numeric,2) as Average_Session_Duration, max(Session_Duration) as Maximum_Session_Duration
from Gym_Tracking
group by Gender;


-- 18.Determine Variation of Average Fat_Percentage across Different Age Groups.

select
    concat(floor((Age-0.1)/10)* 10,'-',floor((Age-0.1)/10)*10+10) as Age_Group,
    round(avg(Fat_Percentage)::numeric,2) as Avg_Fat_Percentage
from Gym_Tracking
group by Age_Group
order by Age_Group;

-- 19. Identify the relationship between Session_Duration and Calories_Burned for members with above-average BMI.

with avg_bmi as (
    select avg(BMI) as Average_BMI
	from Gym_Tracking
)
select Session_Duration,Calories_Burned
from Gym_Tracking,avg_bmi
where BMI>Average_BMI;


-- 20.What is the effect of Water_Intake on Calories_Burned on Workout_Type?

select Workout_Type,round(avg(Water_Intake)::numeric,2) as Average_Water_Intake,round(avg(Calories_Burned),2) as Average_Calories_Burned
from Gym_tracking
group by Workout_Type
order by Average_Water_Intake desc;




