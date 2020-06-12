# This script should follow the first one "1_EDA and data cleaning_time series"

# 4. To experiement on gradualarity----
# 4.1 reducing the granularity from one observation per minute to one observation every 10 minutes
houseDay10 <-
  filter(
    houseDay,
    year(DateTime) == 2008 & month(DateTime) == 1
    & day(DateTime) == 9
    &
      (
        minute(DateTime) == 0 |
          minute(DateTime) == 10 | minute(DateTime) == 20 |
          minute(DateTime) == 30 |
          minute(DateTime) == 40 | minute(DateTime) == 50
      )
  )    

# Plot sub-meter 1, 2 and 3 with title, legend and labels - 10 Minute frequency
plot_ly(
  houseDay10,
  x = ~ houseDay10$DateTime,
  y = ~ houseDay10$kitchen,
  name = 'Kitchen',
  type = 'scatter',
  mode = 'lines'
) %>%
  add_trace(y = ~ houseDay10$laundry,
            name = 'Laundry Room',
            mode = 'lines') %>%
  add_trace(y = ~ houseDay10$Heater_AC,
            name = 'Water Heater & AC',
            mode = 'lines') %>%
  layout(
    title = "Power Consumption January 9th, 2008 with 10 Minus Frequency",
    xaxis = list(title = "Time"),
    yaxis = list (title = "Power (watt-hours)")
  )         


#4.2 Further excercises: change to a difference day for visualization 
#specify a day June 18 2008 - summer day
houseDaysummer <- filter(df4,
                         year(DateTime) == 2008 &
                           month(DateTime)  == 6 &
                           day(DateTime) == 19)

plot_ly(
  houseDaysummer,
  x = ~ houseDaysummer$DateTime,
  y = ~ houseDaysummer$kitchen,
  name = 'Kitchen',
  type = 'scatter',
  mode = 'lines'
) %>%
  add_trace(y = ~ houseDaysummer$laundry,
            name = 'Laundry Room',
            mode = 'lines') %>%
  add_trace(y = ~ houseDaysummer$Heater_AC,
            name = 'Water Heater & AC',
            mode = 'lines') %>%
  layout(
    title = "Power Consumption Summer June 19 2008",
    xaxis = list(title = "Time"),
    yaxis = list (title = "Power (watt-hours)")
  )

# 4.3 with 10 minutes frequency 
housedaysummer10 <-
  filter(
    houseDaysummer,
    year(DateTime) == 2008 & month(DateTime) == 6
    & day(DateTime) == 19
    &
      (
        minute(DateTime) == 0 |
          minute(DateTime) == 10 | minute(DateTime) == 20 |
          minute(DateTime) == 30 |
          minute(DateTime) == 40 | minute(DateTime) == 50
      )
  )


housedaysummer10 <-
  filter(
    houseDaysummer,
    year(DateTime) == 2008 & month(DateTime) == 6
    & day(DateTime) == 19
    & (minute(DateTime) == 0 | 10 | 20 |
         30 |  40 | 50)
  )

plot_ly(
  housedaysummer10,
  x = ~ housedaysummer10$DateTime,
  y = ~ housedaysummer10$kitchen,
  name = 'Kitchen',
  type = 'scatter',
  mode = 'lines'
) %>%
  add_trace(y = ~ housedaysummer10$laundry,
            name = 'Laundry Room',
            mode = 'lines') %>%
  add_trace(
    y = ~ housedaysummer10$Heater_AC,
    name = 'Water Heater & AC',
    mode = 'lines'
  ) %>%
  layout(
    title = "Power Consumption June 18th 2008 with 10 Mins Frequency",
    xaxis = list(title = "Time"),
    yaxis = list (title = "Power (watt-hours)")
  )


# 4.4 specify a weekend day June 22 2008 - Saturday
housedayweekend <-
  filter(df4,
         year(DateTime) == 2008 & month(DateTime) == 6
         & day(DateTime) == 21)

plot_ly(
  housedayweekend,
  x = ~ housedayweekend$DateTime,
  y = ~ housedayweekend$kitchen,
  name = 'Kitchen',
  type = 'scatter',
  mode = 'lines'
) %>%
  add_trace(y = ~ housedayweekend$laundry,
            name = 'Laundry Room',
            mode = 'lines') %>%
  add_trace(
    y = ~ housedayweekend$Heater_AC,
    name = 'Water Heater & AC',
    mode = 'lines'
  ) %>%
  layout(
    title = "Power Consumption June 21st 2008 (Weekend)",
    xaxis = list(title = "Time"),
    yaxis = list (title = "Power (watt-hours)")
  )

housedaysummerwkd10 <-
  filter(
    housedayweekend,
    year(DateTime) == 2008 &
      month(DateTime) == 6 &
      day(DateTime) == 21 &
      (
        minute(DateTime) == 0 |
          minute(DateTime) == 10 |
          minute(DateTime) == 20 |
          minute(DateTime) == 30 |
          minute(DateTime) == 40 | minute(DateTime) == 50
      )
  )

plot_ly(
  housedaysummerwkd10,
  x = ~ housedaysummerwkd10$DateTime,
  y = ~ housedaysummerwkd10$kitchen,
  name = 'Kitchen',
  type = 'scatter',
  mode = 'lines'
) %>%
  add_trace(
    y = ~ housedaysummerwkd10$laundry,
    name = 'Laundry Room',
    mode = 'lines'
  ) %>%
  add_trace(
    y = ~ housedaysummerwkd10$Heater_AC,
    name = 'Water Heater & AC',
    mode = 'lines'
  ) %>%
  layout(
    title = "Power Consumption June 18th 2008 with 10 Mins Frequency",
    xaxis = list(title = "Time"),
    yaxis = list (title = "Power (watt-hours)")
  )


# 4.5 Create a visualization with plotly for a Week of your choosing. Use all three sub-meters and make sure to label. Experiment with granularity. 
  
houseweekwinter <-
  filter(df4, year(DateTime) == 2008 & week(DateTime) == 2)

plot_ly(
  houseweekwinter,
  x = ~ weekdays(houseweekwinter$DateTime),
  y = ~ houseweekwinter$kitchen
  name = 'Kitchen',
  type = 'scatter',
  mode = 'lines'
) %>%
  add_trace(
    y = ~ houseweekwinter$laundry,
    name = 'Laundry Room',
    mode = 'lines'
  ) %>%
  add_trace(
    y = ~ houseweekwinter$Heater_AC,
    name = 'Water Heater & AC',
    mode = 'lines'
  ) %>%
  layout(
    title = "Power Consumption Week 2 (Winter) 2008",
    xaxis = list(title = "Time"),
    yaxis = list (title = "Power (watt-hours)")
  )

#4.6 with every30 minutes as frequncy

houseweekwinter30m <-
  filter(houseweekwinter,
         year(DateTime) == 2008 & week(DateTime) == 2
         & (minute(DateTime) == 30))

plot_ly(
  houseweekwinter30m,
  x = ~ weekdays(houseweekwinter30m$DateTime),
  y = ~ houseweekwinter30m$kitchen,
  name = 'Kitchen',
  type = 'scatter',
  mode = 'lines'
) %>%
  add_trace(
    y = ~ houseweekwinter30m$laundry,
    name = 'Laundry Room',
    mode = 'lines'
  ) %>%
  add_trace(
    y = ~ houseweekwinter30m$Heater_AC,
    name = 'Water Heater & AC',
    mode = 'lines'
  ) %>%
  layout(
    title = "Power Consumption Week 2 (Winter) 2008 with 30 mins Frequency",
    xaxis = list(title = "Time"),
    yaxis = list (title = "Power (watt-hours)")
  ) 

# the plot seems not making much sense.

# 4.7 Try with quarters

housequarter <- filter(df4, year(DateTime) == 2008 | 2009 | 2010)

plot_ly(
  housequarter,
  x = ~ housequarter$DateTime,
  y = ~ housequarter$kitchen,
  name = 'Kitchen',
  type = 'scatter',
  mode = 'lines'
) %>%
  add_trace(
    y = ~ housequarter$laundry,
    name = 'Laundry Room',
    mode = 'lines'
  ) %>%
  add_trace(
    y = ~ housequarter$Heater_AC,
    name = 'Water Heater & AC',
    mode = 'lines'
  ) %>%
  layout(
    title = "Power Consumption Quarterly 2008",
    xaxis = list(title = "Time"),
    yaxis = list (title = "Power (watt-hours)")
  )

housequarter4 <-
  filter(housequarter, year(DateTime) == 2008 & hour(DateTime) == 1)


plot_ly(
  housequarter4,
  x = ~ housequarter4$DateTime,
  y = ~ housequarter4$kitchen,
  name = 'Kitchen',
  type = 'scatter',
  mode = 'lines'
) %>%
  add_trace(
    y = ~ housequarter4$laundry,
    name = 'Laundry Room',
    mode = 'lines'
  ) %>%
  add_trace(
    y = ~ housequarter4$Heater_AC,
    name = 'Water Heater & AC',
    mode = 'lines'
  ) %>%
  layout(
    title = "Power Consumption 2008 (hour = 1)",
    xaxis = list(title = "Time"),
    yaxis = list (title = "Power (watt-hours)")
  ) 

# end of script 2