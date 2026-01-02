# Bellabeat Case Study: How Can a Wellness Technology Company Play It Smart?

## Executive Summary

This case study examines how consumers use smart wellness devices and how those usage patterns can inform Bellabeat’s product and marketing strategy. Using Fitbit fitness tracker data from approximately 30 users, the analysis identifies trends in physical activity and sleep behavior. Results show that users are moderately active overall, with most movement coming from light activity rather than intense exercise. Activity varies by day of the week, and sleep outcomes are more strongly associated with balanced, moderate activity levels than with extreme activity. These findings suggest that Bellabeat should continue emphasizing holistic wellness, consistency, and sustainable habits rather than high‑intensity fitness goals.

## Key Highlights

Analyzed smart device usage data from ~30 Fitbit users to identify activity and sleep behavior patterns

Cleaned and transformed raw CSV data using SQL (BigQuery), including deduplication and date standardization

Found that users are moderately active, with most movement coming from light daily activity

Identified clear day-of-week trends, with highest activity on Saturdays and lowest on Sundays

Discovered that moderate activity levels are associated with the highest sleep efficiency

Translated behavioral insights into actionable product and marketing recommendations for Bellabeat

## Business Questions Answered

- How do users engage with smart wellness devices in their daily lives?
- How active are users on average, and how does activity vary over time?
- Do activity patterns differ by day of the week?
- How are physical activity levels related to sleep duration and sleep efficiency?
- How can these insights inform Bellabeat’s product and marketing strategy?

## Tools Used

- SQL (Google BigQuery)
- Spreadsheets (initial data inspection)
- GitHub (documentation and project sharing)

## Step 1: Ask

The business problem addressed in this case study is understanding how consumers use smart wellness devices in their daily lives and determining how those behaviors can be applied to Bellabeat’s products to guide marketing strategy. By analyzing smart device data from non‑Bellabeat users, this study aims to align Bellabeat’s marketing and product positioning with real, observed user behavior. Grounding decisions in real‑world usage patterns helps Bellabeat improve engagement, target the right behaviors, and increase the likelihood of long‑term product and campaign success.

## Step 2: Prepare

The analysis uses the Fitbit Fitness Tracker Data dataset, publicly available on Kaggle and collected from Fitbit users who consented to share their personal wellness data. The dataset consists of multiple CSV files containing daily and hourly metrics such as steps, calories burned, activity intensity, and sleep data. The data spans approximately two months, from March to May 2016, and represents usage behavior from roughly 30 individual users.
This dataset provides sufficient detail to explore high‑level patterns in daily activity and sleep habits, which can be used to infer broader trends in smart device usage. However, several limitations affect how broadly the results can be generalized. The sample size is relatively small, all participants are Fitbit users who may be more health‑conscious than average, and the data is from 2016, meaning user behavior may differ from how consumers interact with modern devices today.
While these limitations do not invalidate the analysis, they indicate that findings should be interpreted as directional insights rather than definitive conclusions. Despite these constraints, the dataset is appropriate for Bellabeat’s business questions because it directly captures key behaviors such as physical activity, sleep patterns, and daily engagement with wellness technology.

## Step 3: Process

SQL was used as the primary tool for cleaning, aggregating, and analyzing the data due to the dataset’s size and structure. Spreadsheets were used for initial inspection and validation. This approach ensured efficiency, reproducibility, and clarity throughout the analysis process.
Daily activity data was available across the full analysis period, while daily sleep summary data was only available for a subset of dates. Sleep insights were therefore analyzed using available records, while activity trends were evaluated across the full dataset. User identifiers were validated for consistency, duplicate records were removed, date fields were standardized, and activity and sleep data were combined using a left join to preserve activity records even when sleep data was missing.

## Step 4: Analyze

### Overall Activity Levels

On average, users take approximately 7,200 steps per day. Most daily movement comes from light activity, while high‑intensity activity accounts for a relatively small portion of total movement. Sedentary time is high, indicating that users engage with wellness tracking primarily as part of everyday lifestyle management rather than structured fitness routines.

### Activity by Day of Week

Activity levels vary meaningfully by day of the week. Users are most active on Saturdays and least active on Sundays, while midweek activity remains relatively stable. This suggests that routine‑based movement plays a larger role than planned exercise and that lower‑activity days present opportunities for targeted engagement.

### Activity and Sleep Duration

Higher daily activity levels are not associated with longer sleep duration. In fact, days with higher step counts correspond to slightly shorter sleep times. This indicates that sleep behavior may be influenced more by lifestyle demands and daily schedules than by physical activity alone.

### Activity and Sleep Efficiency

Moderate activity levels are associated with the highest sleep efficiency, while high activity levels show lower efficiency. This suggests that balanced, sustainable activity supports better sleep quality than either very low or very high activity levels.

## Step 5: Share

The analysis reveals that most users are moderately active and engage with wellness devices as part of their daily routines rather than for intense fitness training. Activity patterns fluctuate by day of the week, and balanced activity levels are linked to better sleep efficiency. These insights reinforce the importance of positioning Bellabeat as a holistic wellness brand focused on consistency, balance, and long‑term habit building.

Key Findings:

- Users are moderately active, with most movement coming from light activity
- Activity is highest on Saturdays and lowest on Sunday
- Higher activity does not necessarily lead to longer sleep  
- Moderate activity is associated with better sleep efficiency than extreme activity levels  

## Step 6: Act

Based on these findings, the following recommendations are proposed:

- Emphasize sustainable, moderate activity rather than extreme fitness goals  
- Use day-of-week patterns to deliver targeted, timely engagement, especially on low-activity days such as Sundays  
- Highlight sleep quality and recovery, not just sleep duration, in both product features and marketing messaging  

These actions align closely with Bellabeat’s brand values and support a holistic approach to wellness.

## Limitations and Future Opportunities:

This analysis is limited by a small sample size, older data, and incomplete sleep records. Future analyses could incorporate larger and more recent datasets, additional metrics such as stress or heart rate, and longer time horizons to better understand behavior changes over time.

## Conclusion

By analyzing real‑world smart device usage data, this case study demonstrates how Bellabeat can refine its marketing and product strategy to better support everyday wellness. The findings underscore the value of balance, consistency, and holistic health, reinforcing Bellabeat’s positioning as a wellness technology company designed for sustainable, real‑life use.
