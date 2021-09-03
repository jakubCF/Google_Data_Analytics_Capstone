# Google Data Analytics Capstone

This is last course from Google Data Analytics specialization prepared by Google and offered on Coursera.com.

Objective is to use all knowledge learned in 7 previous courses which constitutes of  

* ask
* prepare
* process
* analyze
* share

I've chosen dataset about rental bikes and their usage for last 12 months.

## Case study 1 - How does a bike-share navigate speedy success?

### --- ASK ---

Business purpose is to understand casual users, how their usage of services differs from members.

We should identify historical trends for memebers and casual users, so these trends can be compared.

Audience is marketing team and their manager.

### --- PREPARE ---  

Data provided for this analysis are collected by company and could be classifie as first-party data. We use last 12 months. Data do not provide information based on which we can identify users. Data are accessible here: [https://divvy-tripdata.s3.amazonaws.com/index.html](https://divvy-tripdata.s3.amazonaws.com/index.html)  

We are using data from 08/2020 - 07/2021.

All data files have idencial number of columns and names.

### --- PROCESS ---  

First I tried to load everything into one worksheet in MS Excel. Found out there is around 4,7 milion rows... well above possibilities of one worksheet.
Next try was Pandas dataframe in Python. Useable but low performance due to high memory usage. I also tried R studio with the steps that were described in course. It was good way.

But it was much faster to load everything to data model in MS Excel and create pivot table to get some insights, charts. Calculating avarage, min and max ride length was easy.

I found out there is many entries with negative ride length. In total it accounts just for a fraction of all entries but it's necessary to ask why it is and if the issue that let to negative ride length, have had any influence on other entries.

This can completely disqualify all the data for further analysis because without answers to these questions, all data are unreliable.

I continue with the analysis without the answers and will remove all negative and 0 length rides.

In course description is mentioned station HQ QE that represents quality check done by company employees, I haven't found this particular stations in the new dataset but there are other

* HUBBARD ST BIKE CHECKING (LBS-WH-TEST)
* WATSON TESTING - DIVVY

All entries that started or ended in one of those stations will be removed too as they do not represend rides done by customers.

Many start and end points are missing. Any of these entries could potencialy be related to company's quality check. But we will keep it in the dataset.

### --- ANALYZE ---  

Analysis of the last 12 months showed clear differencec in usage of the bikes between members and casual users. Members tend to use it mostly during workweek with slightly lower number of trips over a weekend. On the other side non-members use it way more over a weekend. During workweek non-members make almost half of the trips compare to weekend.

More than half of the trips is made by members but their length is almost half of the trip length of non-member.

When it comes to seasonal patterns, non-members make more trips during summer months (6-7) and members use it more in fall and winter than non-members.

### --- SHARE ---

At the end I prepared presentation with charts summarizing differences between users of bikes.
