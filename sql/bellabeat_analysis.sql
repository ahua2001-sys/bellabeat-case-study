-- Check total row counts across raw activity and sleep tables
SELECT 'dailyActivity_mar_apr' AS table_name, COUNT(*) AS row_count
FROM `bellabeat_case_study.dailyActivity_mar_apr`
UNION ALL
SELECT 'dailyActivity_apr_may' AS table_name, COUNT(*) AS row_count
FROM `bellabeat_case_study.dailyActivity_apr_may`
UNION ALL
SELECT 'sleepDay_apr_may' AS table_name, COUNT(*) AS row_count
FROM `bellabeat_case_study.sleepDay_apr_may`;

-- Validate the number of distinct users present in each raw table
SELECT 'dailyActivity_mar_apr' AS table_name, COUNT(DISTINCT Id) AS unique_users
FROM `bellabeat_case_study.dailyActivity_mar_apr`
UNION ALL
SELECT 'dailyActivity_apr_may', COUNT(DISTINCT Id)
FROM `bellabeat_case_study.dailyActivity_apr_may`
UNION ALL
SELECT 'sleepDay_apr_may', COUNT(DISTINCT Id)
FROM `bellabeat_case_study.sleepDay_apr_may`;

-- Inspect record counts per user to confirm ID validity and participation consistency
SELECT
  Id,
  COUNT(*) AS records
FROM `bellabeat_case_study.dailyActivity_mar_apr`
GROUP BY Id
ORDER BY records DESC;

-- Check the data type BigQuery assigned to ActivityDate
SELECT
  column_name,
  data_type
FROM `bellabeat_case_study`.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'dailyActivity_mar_apr'
  AND column_name = 'ActivityDate';

-- Quick preview to confirm ActivityDate is already a DATE and data looks correct
SELECT
  Id,
  ActivityDate,
  TotalSteps,
  Calories
FROM `bellabeat_case_study.dailyActivity_mar_apr`
LIMIT 5;


-- Create a clean, combined daily activity table with one record per user per day
CREATE OR REPLACE TABLE `bellabeat_case_study.daily_activity_clean` AS
WITH combined AS (
  SELECT
    Id,
    ActivityDate AS activity_date,
    TotalSteps,
    TotalDistance,
    TrackerDistance,
    LoggedActivitiesDistance,
    VeryActiveDistance,
    ModeratelyActiveDistance,
    LightActiveDistance,
    SedentaryActiveDistance,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes,
    Calories
  FROM `bellabeat_case_study.dailyActivity_mar_apr`

  UNION ALL

  SELECT
    Id,
    ActivityDate AS activity_date,
    TotalSteps,
    TotalDistance,
    TrackerDistance,
    LoggedActivitiesDistance,
    VeryActiveDistance,
    ModeratelyActiveDistance,
    LightActiveDistance,
    SedentaryActiveDistance,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes,
    Calories
  FROM `bellabeat_case_study.dailyActivity_apr_may`
),
deduped AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY Id, activity_date
      ORDER BY activity_date
    ) AS row_num
  FROM combined
)
SELECT
  Id,
  activity_date,
  TotalSteps,
  TotalDistance,
  TrackerDistance,
  LoggedActivitiesDistance,
  VeryActiveDistance,
  ModeratelyActiveDistance,
  LightActiveDistance,
  SedentaryActiveDistance,
  VeryActiveMinutes,
  FairlyActiveMinutes,
  LightlyActiveMinutes,
  SedentaryMinutes,
  Calories
FROM deduped
WHERE row_num = 1;

-- Confirm row count and unique users in the cleaned activity table
SELECT
  COUNT(*) AS row_count,
  COUNT(DISTINCT Id) AS unique_users
FROM `bellabeat_case_study.daily_activity_clean`;

-- How many duplicate user+date rows existed in the raw combined data?
WITH combined AS (
  SELECT Id, ActivityDate AS activity_date FROM `bellabeat_case_study.dailyActivity_mar_apr`
  UNION ALL
  SELECT Id, ActivityDate AS activity_date FROM `bellabeat_case_study.dailyActivity_apr_may`
)
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT CONCAT(CAST(Id AS STRING), '-', CAST(activity_date AS STRING))) AS distinct_user_days,
  COUNT(*) - COUNT(DISTINCT CONCAT(CAST(Id AS STRING), '-', CAST(activity_date AS STRING))) AS duplicate_rows
FROM combined;

-- Preview SleepDay to confirm its string format before we convert it to a DATE
SELECT
  SleepDay,
  SPLIT(SleepDay, ' ')[OFFSET(0)] AS sleep_day_only
FROM `bellabeat_case_study.sleepDay_apr_may`
LIMIT 5;

-- Create a clean sleep table with one record per user per day (Apr–May only)
CREATE OR REPLACE TABLE `bellabeat_case_study.sleep_day_clean` AS
WITH parsed AS (
  SELECT
    Id,
    PARSE_DATE('%m/%d/%Y', SPLIT(SleepDay, ' ')[OFFSET(0)]) AS sleep_date,
    TotalSleepRecords,
    TotalMinutesAsleep,
    TotalTimeInBed
  FROM `bellabeat_case_study.sleepDay_apr_may`
),
deduped AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY Id, sleep_date
      ORDER BY sleep_date
    ) AS row_num
  FROM parsed
)
SELECT
  Id,
  sleep_date,
  TotalSleepRecords,
  TotalMinutesAsleep,
  TotalTimeInBed
FROM deduped
WHERE row_num = 1;


-- Confirm row count and unique users in the cleaned sleep table
SELECT
  COUNT(*) AS row_count,
  COUNT(DISTINCT Id) AS unique_users,
  MIN(sleep_date) AS min_date,
  MAX(sleep_date) AS max_date
FROM `bellabeat_case_study.sleep_day_clean`;


-- Create an analysis-ready table combining daily activity and sleep data
CREATE OR REPLACE TABLE `bellabeat_case_study.activity_sleep_joined` AS
SELECT
  a.Id,
  a.activity_date,
  a.TotalSteps,
  a.TotalDistance,
  a.VeryActiveMinutes,
  a.FairlyActiveMinutes,
  a.LightlyActiveMinutes,
  a.SedentaryMinutes,
  a.Calories,
  s.TotalMinutesAsleep,
  s.TotalTimeInBed
FROM `bellabeat_case_study.daily_activity_clean` a
LEFT JOIN `bellabeat_case_study.sleep_day_clean` s
  ON a.Id = s.Id
 AND a.activity_date = s.sleep_date;


-- Verify size and coverage of the joined table
SELECT
  COUNT(*) AS row_count,
  COUNT(DISTINCT Id) AS unique_users,
  COUNT(TotalMinutesAsleep) AS days_with_sleep_data
FROM `bellabeat_case_study.activity_sleep_joined`;

-- Calculate average daily activity metrics across all users
SELECT
  AVG(TotalSteps) AS avg_daily_steps,
  AVG(VeryActiveMinutes) AS avg_very_active_minutes,
  AVG(FairlyActiveMinutes) AS avg_fairly_active_minutes,
  AVG(LightlyActiveMinutes) AS avg_lightly_active_minutes,
  AVG(SedentaryMinutes) AS avg_sedentary_minutes
FROM `bellabeat_case_study.activity_sleep_joined`;

-- Analyze average daily steps by day of the week
SELECT
  FORMAT_DATE('%A', activity_date) AS day_of_week,
  AVG(TotalSteps) AS avg_daily_steps
FROM `bellabeat_case_study.activity_sleep_joined`
GROUP BY day_of_week
ORDER BY avg_daily_steps DESC;

-- Analyze how sleep duration varies by daily step count
SELECT
  CASE
    WHEN TotalSteps < 5000 THEN 'Low activity'
    WHEN TotalSteps BETWEEN 5000 AND 9999 THEN 'Moderate activity'
    ELSE 'High activity'
  END AS activity_level,
  AVG(TotalSteps) AS avg_steps,
  AVG(TotalMinutesAsleep) AS avg_minutes_asleep,
  COUNT(*) AS days_count
FROM `bellabeat_case_study.activity_sleep_joined`
WHERE TotalMinutesAsleep IS NOT NULL
GROUP BY activity_level
ORDER BY avg_steps;

-- Analyze sleep efficiency (minutes asleep vs time in bed) by activity level
SELECT
  CASE
    WHEN TotalSteps < 5000 THEN 'Low activity'
    WHEN TotalSteps BETWEEN 5000 AND 9999 THEN 'Moderate activity'
    ELSE 'High activity'
  END AS activity_level,
  AVG(TotalMinutesAsleep / TotalTimeInBed) AS avg_sleep_efficiency,
  COUNT(*) AS days_count
FROM `bellabeat_case_study.activity_sleep_joined`
WHERE TotalMinutesAsleep IS NOT NULL
  AND TotalTimeInBed IS NOT NULL
GROUP BY activity_level
ORDER BY avg_sleep_efficiency DESC;


