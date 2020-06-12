# install.packages("VIM")
# install.packages("RColorBrewer")
# install.packages("viridis")
# install.packages('plotly')
# install.packages("ggfortify")
# install.packages("Rserve")
# install.packages("forecast")

# load library
library(pacman)
pacman::p_load(
  caret,
  chron,
  dplyr,
  forecast,
  ggfortify,
  ggplot2,
  lubridate,
  openxlsx,
  plotly,
  RColorBrewer,
  RMySQL,
  Rserve,
  tidyverse,
  VIM,
  viridis
)

# tidyverse - Package for tidying data
# lubridate - for working with dates/times of a time series
# VIM - Visualizing and imputing missing values
# openxlsx - to use write.xlsx function

# 1. Loading dataset ----
# Reading the data file in txt format, creating a tibble which is a data frame suitble for tidyverse packages. 
# Here the col_types argument has been used to define column data types as floats or double by setting the column types to 'd'. 
# Missing values will be assigned to '?' for now as a place holder

originaldf <-
  read_delim(
    'C:\\Users\\minju\\Ubiqum\\14 Module 3 time series\\IoT-time-series-energy-consumptions-smartmeters\\household_power_consumption.txt',
    col_names = TRUE,
    col_types = cols(
      Global_active_power = 'd',
      Global_reactive_power = 'd',
      Voltage = 'd',
      Global_intensity = 'd',
      Sub_metering_1 = 'd',
      Sub_metering_2 = 'd',
      Sub_metering_3 = 'd'
    ),
    delim = ';',
    na = '?'
  )
                        
# having a quick overview of the dataset
summary(originaldf)
head(originaldf)
str(originaldf)
tail(originaldf)

# 2,075,259 observations
# 25,979 missing values (NA's)

# 2. Exploring and preparing data ----

# 2.1 Create new DateTime feature by combining Date and Time ----
df1 <- unite(originaldf, Date, Time, col = 'DateTime', sep = ' ')

# convert data type of new DateTime feature
df1$DateTime <- as.POSIXct(df1$DateTime,
                           format = "%d/%m/%Y %T",
                           tz = "GMT")

# check class of new DateTime feature
class(df1$DateTime)

# 2.2 Select approprirate period of data ----

# only keep data that covering full years.
# therefore, only keep data in 2007, 2008, 2009
df2 <- filter(df1, year(DateTime) !=2006)
df2<- filter(df2, year(DateTime) !=2010)

# 2.3. Checking missing data ---
# visualize extent and pattern of missing data
aggr(
  df2,
  col = c('orange', 'lightgrey'),
  numbers = TRUE,
  sortVars = TRUE,
  labels = names(df2),
  cex.axis = .7,
  gap = 3,
  ylab = c("Histogram of missing data", "Pattern"),
  digits = 2
)

# missing values aren't scattered randomly throughout the data, but rather concentrate into some entire rows. 
# therefore, rows with missing data were removed because there is no danger of losing information. 
df3 <- na.omit(df2)

# check whether all NA has been removed
sum(is.na(df3))

# 2.4 Transfering columns' measuring units and names ----

# first transfer the Global active power to "active energy consumed every minute 
# (in kilowatt hour)" by *1000/60
# also transfer the Global reactive power to the same measuring unit
df3$global_active_powerWh <- df3$Global_active_power * 1000 / 60
df3$global_reactive_powerWh <- df3$Global_reactive_power * 1000 / 60
# total engergy consumption in this household
df3$total_consump = df3$global_active_powerWh + df3$global_reactive_powerWh

# rename several coloumns

df4 <-
  setnames(
    df3,
    old = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
    new = c('kitchen', 'laundry', 'Heater_AC')
  )


# adding one variable showing the "active energy consumed every minute (in watt hour)" in the household by electrical equipment not measured in sub-meterings 1, 2 and 3 name it "non_subm_measured_energy"

household_pwr <- mutate(df4,
                        submeters_unmeasured = global_active_powerWh - kitchen
                        - laundry - Heater_AC)


# showing how many cases of non_subm_measured_energy are negative
sum(household_pwr$submeters_unmeasured <0) # 1011 cases are negative - need to find out how to deal with this? 

# creating long form of data set
household_pwr_tidy <- household_pwr %>%
  gather(Meter, Watt_hr, `kitchen`, `laundry`, `Heater_AC`)


# creating another df including unmeasured energy consumption for creating graphs, but not using it for further analysis
hpt2 <- household_pwr %>%
  gather(Meter,
         Watt_hr,
         `kitchen`,
         `laundry`,
         `Heater_AC`,
         `submeters_unmeasured`)

# converting meter feature to categorical
household_pwr_tidy$Meter <- factor(household_pwr_tidy$Meter)

# inspecting the data set
glimpse(household_pwr_tidy)


# removing rows where non_subm_measured_energy is lower than 0
household_pwr <- filter(df_energyconsum, non_subm_measured_energy >=0)


# 3. Visualizations of Energy Usage Across Sub-Meters and Time Periods ----

# Final outputs of visualizations were conducted in Tableau

# starting by visualizing the least granular of time periods (yearly) 

# 3.1 Year_Proportional Plot
household_pwr_tidy %>%
  group_by(year(DateTime), Meter) %>%
  summarise(sum = sum(Watt_hr)) %>%
  ggplot(aes(
    x = factor(`year(DateTime)`),
    sum,
    group = Meter,
    fill = Meter
  )) +
  labs(x = 'Year', y = 'Proportion of Energy Usage') +
  ggtitle('Proportion of Total Yearly Energy Consumption') +
  geom_bar(stat = 'identity', color = 'black') +
  scale_color_viridis(discrete = TRUE, option = "D") +
  scale_fill_viridis(discrete = TRUE) +
  theme(panel.border = element_rect(colour = 'black', fill = NA)) +
  theme(text = element_text(size = 14))

## 3.2 plot showing the percentage of unmeasured energy
hpt2 %>%
  group_by(year(DateTime), Meter) %>%
  summarise(sum = sum(Watt_hr)) %>%
  ggplot(aes(
    x = factor(`year(DateTime)`),
    sum,
    group = Meter,
    fill = Meter
  )) +
  labs(x = 'Year', y = 'Proportion of Energy Usage') +
  ggtitle('Proportion of Total Yearly Energy Consumption (incl. unmeasured)') +
  geom_bar(stat = 'identity', color = 'black') +
  scale_color_viridis(discrete = TRUE, option = "D") +
  scale_fill_viridis(discrete = TRUE) +
  theme(panel.border = element_rect(colour = 'black', fill = NA)) +
  theme(text = element_text(size = 14))

# 3.3 Compared High Energy Consumption for Day of Week (Summer & Winter)
# Filter and plot data for weeks 1-8
household_pwr_tidy %>%
  filter(week(DateTime) == c(1:8)) %>%
  mutate(Day = lubridate::wday(DateTime, label = TRUE, abbr = TRUE)) %>%
  group_by(Day, Meter) %>%
  summarise(sum = sum(Watt_hr / 1000)) %>%
  ggplot(aes(x = factor(Day), y = sum)) +
  labs(x = 'Day of the Week', y = 'kWh') +
  ylim(0, 85) +
  ggtitle('Total Energy Usage by Day for Weeks of \nHigh Consumption in Winter Months') +
  geom_bar(stat = 'identity', aes(fill = Meter), colour = 'black') +
  scale_color_viridis(discrete = TRUE, option = "D") +
  scale_fill_viridis(discrete = TRUE) +
  theme(panel.border = element_rect(colour = 'black', fill = NA)) +
  theme(text = element_text(size = 14))

# 3.4 Visualizing the summer weeks 18 - 25
#-Filter and plot data for weeks 18-25
household_pwr_tidy %>%
  filter(week(DateTime) == c(18:25)) %>%
  mutate(Day = lubridate::wday(DateTime, label = TRUE, abbr = TRUE)) %>%
  group_by(Day, Meter) %>%
  summarise(sum = sum(Watt_hr / 1000)) %>%
  ggplot(aes(x = factor(Day), y = sum)) +
  labs(x = 'Day of the Week', y = 'kWh') +
  ylim(0, 85) +
  ggtitle('Total Energy Usage by Day for Weeks of \nHigh Consumptionin Summer Months') +
  geom_bar(stat = 'identity', aes(fill = Meter), colour = 'black') +
  scale_color_viridis(discrete = TRUE, option = "D") +
  scale_fill_viridis(discrete = TRUE) +
  theme(panel.border = element_rect(colour = 'black', fill = NA)) +
  theme(text = element_text(size = 14))


  #-Quarterly bar plot
household_pwr_tidy %>%
  filter(year(DateTime) < 2010) %>%
  group_by(quarter(DateTime), Meter) %>%
  summarise(sum = round(sum(Watt_hr / 1000), 3)) %>%
  ggplot(aes(x = factor(`quarter(DateTime)`), y = sum)) +
  labs(x = 'Quarter of the years', y = 'kWh') +
  ggtitle('Total Quarterly Energy Consumption of the years') +
  geom_bar(stat = 'identity', aes(fill = Meter), color = 'black') +
  scale_color_viridis(discrete = TRUE, option = "D") +
  scale_fill_viridis(discrete = TRUE) +
  theme(panel.border = element_rect(colour = 'black', fill = NA)) +
  theme(text = element_text(size = 14))

  #-Monthly bar chart
household_pwr_tidy %>%
  filter(year(DateTime) < 2010) %>%
  mutate(Month = lubridate::month(DateTime, label = TRUE, abbr = TRUE)) %>%
  group_by(Month, Meter) %>%
  summarise(sum = round(sum(Watt_hr) / 1000), 3) %>%
  ggplot(aes(x = factor(Month), y = sum)) +
  labs(x = 'Month of the years', y = 'kWh') +
  ggtitle('Total Energy Usage by Month of the Year') +
  geom_bar(stat = 'identity', aes(fill = Meter), colour = 'black') +
  scale_color_viridis(discrete = TRUE, option = "D") +
  scale_fill_viridis(discrete = TRUE) +
  theme(panel.border = element_rect(colour = 'black', fill = NA)) +
  theme(text = element_text(size = 14))

  
  #-Hour of day bar chart
household_pwr_tidy %>%
  filter(month(DateTime) == c(1, 2, 11, 12)) %>%
  group_by(hour(DateTime), Meter) %>%
  summarise(sum = round(sum(Watt_hr) / 1000), 3) %>%
  ggplot(aes(x = factor(`hour(DateTime)`), y = sum)) +
  labs(x = 'Hour of the Day', y = 'kWh') +
  ggtitle('Total Energy Usage by Hour of the Day') +
  geom_bar(stat = 'identity', aes(fill = Meter), colour = 'black') +
  scale_color_viridis(discrete = TRUE, option = 'D') +
  scale_fill_viridis(discrete = TRUE) +
  theme(panel.border = element_rect(colour = 'black', fill = NA)) +
  theme(text = element_text(size = 14))


# convert data type of new DateTime feature
household_pwr_tidy$DateTime <-
  as.POSIXct(household_pwr_tidy$DateTime,
             format = "%d/%m/%Y %T",
             tz = "GMT")

glimpse(household_pwr_tidy)
str(household_pwr_tidy)


# Try plotting as instructed in the Plan of Attack
# Subset the second week of 2008 - All Observations
houseWeek <- filter(df4, year(DateTime) == 2008 &
                      week(DateTime)  == 2)

# Plot subset houseWeek with Sub_metering_1 only
plot(houseWeek$kitchen)


# Subset the 9th day of January 2008 - All observations
houseDay <- filter(df4,
                   year(DateTime) == 2008 &
                     week(DateTime)  == 2 & day(DateTime) == 9)
# Plot sub-meter 1
plot_ly(
  houseDay,
  x = ~ houseDay$DateTime,
  y = ~ houseDay$kitchen,
  type = 'scatter',
  mode = 'lines'
)

# Plot sub-meter 1, 2 and 3 with title, legend and labels - All observations 
plot_ly(
  houseDay,
  x = ~ houseDay$DateTime,
  y = ~ houseDay$kitchen,
  name = 'Kitchen',
  type = 'scatter',
  mode = 'lines'
) %>%
  add_trace(y = ~ houseDay$laundry,
            name = 'Laundry Room',
            mode = 'lines') %>%
  add_trace(y = ~ houseDay$Heater_AC,
            name = 'Water Heater & AC',
            mode = 'lines') %>%
  layout(
    title = "Power Consumption January 9th, 2008",
    xaxis = list(title = "Time"),
    yaxis = list (title = "Power (watt-hours)")
  )
# end of script 1.