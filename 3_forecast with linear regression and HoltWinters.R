# This script should follow the script of "2_experiement on granularity". 

# 5. Forecast - linear regression model

# 5.1 Linear regression model predicting submeter 3
# Apply time series linear regression to the sub-meter 3 ts object and use summary to obtain R2 and RMSE from the model you built

fitSM3 <- tslm(tsSM3_070809weekly ~ trend + season)
summary(fitSM3)
# Create the forecast for sub-meter 3. Forecast ahead 20 time periods 

forecastfitSM3 <- forecast(fitSM3, h = 40)

# Plot the forecast for sub-meter 3.
plot(forecastfitSM3)

# Create sub-meter 3 forecast with confidence levels 80 and 90
forecastfitSM3c <- forecast(fitSM3, h = 40, level = c(80, 90))

# Plot sub-meter 3 forecast, limit y and add labels
plot(
  forecastfitSM3c,
  ylim = c(0, 40),
  ylab = "Watt-Hours",
  xlab = "Time"
)


# Decompose Sub-meter 3 into trend, seasonal and remainder
components070809SM3weekly <- decompose(tsSM3_070809weekly)
# Plot decomposed sub-meter 3 
plot(components070809SM3weekly)
# Check summary statistics for decomposed sub-meter 3 
summary(components070809SM3weekly)


# 5.2 Linear regression model predicting submeter 1

fitSM1 <- tslm(tsSM1_070809weekly2 ~ trend + season)
summary(fitSM1)

# Create the forecast for sub-meter 1. Forecast ahead 20 time periods 
forecastfitSM1 <- forecast(fitSM1, h=40)

# Plot the forecast for sub-meter 1. 
plot(forecastfitSM1)

# Create sub-meter 1 forecast with confidence levels 80 and 90
forecastfitSM1c <- forecast(fitSM1, h = 40, level = c(80, 90))

# Plot sub-meter 1 forecast, limit y and add labels
plot(
  forecastfitSM1c,
  ylim = c(0, 40),
  ylab = "Watt-Hours",
  xlab = "Time"
)


# Decompose Sub-meter 3 into trend, seasonal and remainder
components070809SM1weekly <- decompose(tsSM1_070809weekly2)
# Plot decomposed sub-meter 3 
plot(components070809SM1weekly)
# Check summary statistics for decomposed sub-meter 1
summary(components070809SM1weekly)

# 5.3 Linear regression model predicting submeter 2

fitSM2 <- tslm(tsSM1_070809weekly3 ~ trend + season) 
summary(fitSM2)

# Create the forecast for sub-meter 2. Forecast ahead 20 time periods 
forecastfitSM2 <- forecast(fitSM2, h=40)

# Plot the forecast for sub-meter 2
plot(forecastfitSM2)

# Create sub-meter 2 forecast with confidence levels 80 and 90
fitSM2 <- forecast(fitSM2, h=40, level=c(80,90))

# Plot sub-meter 2 forecast, limit y and add labels
plot(fitSM2,
     ylim = c(0, 30),
     ylab = "Watt-Hours",
     xlab = "Time")

# Decompose Sub-meter 2 into trend, seasonal and remainder
components070809SM2weekly <- decompose(tsSM1_070809weekly3)
# Plot decomposed sub-meter 2
plot(components070809SM2weekly)
# Check summary statistics for decomposed sub-meter 2
summary(components070809SM2weekly)

# 6. Holt-Winter forecasst----

# 6.1 Holt-Winter forecasst - submeter 3
# Seasonal adjusting sub-meter 3 by subtracting the seasonal component & plot
tsSM3_070809Adjusted <-
  tsSM3_070809weekly - components070809SM3weekly$seasonal
autoplot(tsSM3_070809Adjusted)

# Test Seasonal Adjustment by running Decompose again. Note the very, very small scale for Seasonal
plot(decompose(tsSM3_070809Adjusted))

# Holt Winters Exponential Smoothing & Plot
tsSM3_HW070809 <-
  HoltWinters(tsSM3_070809Adjusted, beta = FALSE, gamma = FALSE)
plot(tsSM3_HW070809, ylim = c(0, 25))

# HoltWinters forecast & plot
tsSM3_HW070809for <- forecast(tsSM3_HW070809, h = 25)

plot(
  tsSM3_HW070809for,
  ylim = c(0, 20),
  ylab = "Watt-Hours",
  xlab = "Time - Heater & AC"
)

# Forecast HoltWinters with diminished confidence levels
tsSM3_HW070809for<- forecast(tsSM3_HW070809, h = 25, level = c(10, 25))

# Plot only the forecasted area
plot(
  tsSM3_HW070809for,
  ylim = c(0, 20),
  ylab = "Watt-Hours",
  xlab = "Time - Heater & AC",
  start(2010)
)


# 6.2 Holt-Winter forecasst - submeter 1

# Seasonal adjusting sub-meter 1 by subtracting the seasonal component & plot
tsSM1_070809Adjusted <-
  tsSM1_070809weekly2 - components070809SM1weekly$seasonal
autoplot(tsSM1_070809Adjusted)

# Test Seasonal Adjustment by running Decompose again. Note the very, very small scale for Seasonal
plot(decompose(tsSM1_070809Adjusted))

# Holt Winters Exponential Smoothing & Plot
tsSM1_HW070809 <-
  HoltWinters(tsSM1_070809Adjusted, beta = FALSE, gamma = FALSE)
plot(tsSM1_HW070809, ylim = c(0, 25))

# HoltWinters forecast & plot

# Forecast HoltWinters with diminished confidence levels
tsSM1_HW070809forC <- forecast(tsSM1_HW070809, h = 25, level = c(10, 25))

# Plot only the forecasted area
plot(
  tsSM1_HW070809forC,
  ylim = c(0, 20),
  ylab = "Watt-Hours",
  xlab = "Time - Kitchen",
  start(2010)
)

# 6.3 Holt-Winter forecasst - submeter 2

# Seasonal adjusting sub-meter 2 by subtracting the seasonal component & plot
tsSM2_070809Adjusted <-
  tsSM1_070809weekly3 - components070809SM2weekly$seasonal

autoplot(tsSM2_070809Adjusted)

# Test Seasonal Adjustment by running Decompose again. Note the very, very small scale for Seasonal
plot(decompose(tsSM2_070809Adjusted))

# Holt Winters Exponential Smoothing & Plot
tsSM2_HW070809 <-
  HoltWinters(tsSM2_070809Adjusted, beta = FALSE, gamma = FALSE)

plot(tsSM2_HW070809, ylim = c(0, 25))

# HoltWinters forecast & plot
tsSM2_HW070809for <- forecast(tsSM2_HW070809, h = 25)

plot(
  tsSM2_HW070809for,
  ylim = c(0, 20),
  ylab = "Watt-Hours",
  xlab = "Time - Laundry"
)

# Forecast HoltWinters with diminished confidence levels
tsSM2_HW070809forC <- forecast(tsSM2_HW070809, h = 25, level = c(10, 25))

# Plot only the forecasted area
plot(
  tsSM2_HW070809forC,
  ylim = c(0, 20),
  ylab = "Watt-Hours",
  xlab = "Time - Laundry",
  start(2010)
)

# end of script 3