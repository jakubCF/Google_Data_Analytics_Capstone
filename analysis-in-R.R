library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data
setwd("C:/Users/JAK4GMZ/GitHub/Google_Data_Analytics_Capstone/source_data")

ds082020 <- read_delim(file = "202008-divvy-tripdata.csv",col_select = c(1,2,3,4,5,13))
ds092020 <- read_delim(file = "202009-divvy-tripdata.csv",col_select = c(1,2,3,4,5,13))
ds102020 <- read_delim(file = "202010-divvy-tripdata.csv",col_select = c(1,2,3,4,5,13))
ds112020 <- read_delim(file = "202011-divvy-tripdata.csv",col_select = c(1,2,3,4,5,13))
ds122020 <- read_delim(file = "202012-divvy-tripdata.csv",col_select = c(1,2,3,4,5,13))
ds012021 <- read_delim(file = "202101-divvy-tripdata.csv",col_select = c(1,2,3,4,5,13))
ds022021 <- read_delim(file = "202102-divvy-tripdata.csv",col_select = c(1,2,3,4,5,13))
ds032021 <- read_delim(file = "202103-divvy-tripdata.csv",col_select = c(1,2,3,4,5,13))
ds042021 <- read_delim(file = "202104-divvy-tripdata.csv",col_select = c(1,2,3,4,5,13))
ds052021 <- read_delim(file = "202105-divvy-tripdata.csv",col_select = c(1,2,3,4,5,13))
ds062021 <- read_delim(file = "202106-divvy-tripdata.csv",col_select = c(1,2,3,4,5,13))
ds072021 <- read_delim(file = "202107-divvy-tripdata.csv",col_select = c(1,2,3,4,5,13))

head(ds082020)


all_trips <- bind_rows(ds082020, ds092020,ds102020,ds112020,ds122020,ds012021,
                       ds022021,ds032021,ds042021,ds052021,ds062021,ds072021)

colnames(all_trips)
nrow(all_trips)
dim(all_trips)

all_trips$date <- as.Date(all_trips$started_at) #The default format is yyyy-mm-dd
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)

str(all_trips)

is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)

all_trips_v2 <- all_trips[!(all_trips$start_station_name == "WATSON TESTING - DIVVY" | all_trips$start_station_name == "HUBBARD ST BIKE CHECKING (LBS-WH-TEST)" | all_trips$ride_length<=0),]
all_trips_v2 <- subset(all_trips_v2, select = -c(start_station_name))
all_trips_v2 <- na.omit(all_trips_v2)

mean(all_trips_v2$ride_length) #straight average (total ride length / rides)
median(all_trips_v2$ride_length) #midpoint number in the ascending array of ride lengths
max(all_trips_v2$ride_length) #longest ride
min(all_trips_v2$ride_length) #shortest ride

# Compare members and casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

# Notice that the days of the week are out of order. Let's fix that.
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# See the average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

sum_member <- all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(member_casual, weekday)								# sorts

# Let's visualize the number of rides by rider type
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# Let's create a visualization for average duration
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

counts <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)
write.csv(counts, file = '../export_from_R/avg_ride_length.csv')

write.csv(sum_member, file = "../export_from_R/count_avg_ride.csv")

sum_year <- all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, month, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(member_casual, month, weekday)								# sorts

write.csv(sum_year, file = "../export_from_R/sum_year_count_avg_ride.csv")
