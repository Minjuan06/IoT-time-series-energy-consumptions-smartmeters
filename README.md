# IoT-time-series-energy-consumptions-smartmeters
# IoT Time Series -- Energy Consumption

This project is related to data analytics in the field of IoT("Internet of Things"). More specifically, this project is to analyse time series in smart energy usage, modeling patterns of energy usage by time of day and day of the year in a typical residence whose electrical system is monitored by multiple sub-meters.

This case requires deep-dive into smart homes and sub-meters. Some domain knowledge would be helpful to better understand what purposes this project serves: for exmpale, a review on existing players in this market including asking how they define Smart Homes, what role do sub-meters play, what kinds of power usage analytics are currently offered, what can be learned from the analytics, and what are the benefits to consumers. 


## 1. Loading the data and performing EDA

### 1.1 Dataset information

The Electric Power Consumption Data Set can be found through this link (http://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption). The accompanying documentation provides useful information regarding this dataset. 

The data for this project is currently stored on a database in several annual tables (yr_2006, yr_2007, yr_2008, yr_2009, yr_2010). There are 2,075,259 observations and 25,979 missing values (NA's).


By using the RMySQL package to query the database and retrieve data. Observations in 2006 and 2010 don't span an entire year; therefore, the primary data frame excludes these two years' observations but keeps those in 2007, 2008 and 2009. 

Since the Date and Time columns are separate, they needed to be combined within the dataset in order to convert them to the correct format to complete the appropriate analysis. The data description suggests that the data is from France.


**Locations and appliances of individual sub meters**
- Sub meter 1: it corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered) - (in watt-hour of active energy).

- Sub meter 2: it corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light - (in watt-hour of active energy).

- Sub meter 3:it corresponds to an electric water-heater and an air-conditioner - (in watt-hour of active energy). 

**Attributes include:**
- data
- time
- global active power
- global reactive power
- voltage
- global intensity
- sub_metering_1
- sub_metering_2
- sub_metering_3

### 1.2 Visualizations of energy usage across sub meters and time periods

One of the goals of subsetting for visualizations is to adjust granularity to maximize the information to be gained. Granularity describes the frequency of observations within a time series data set. From the data description it showsthat the observations were taken once per minute over the period of almost 4 years. That's over 2 million observations. 

#### 1.2.1 Looking at years and quarters

**Unmeasured energy consumption is susbstantial**

<img src="/graphs/Yearly_energy_consump_of_appliances_each_unmeasured.png"  width="30%" height="30%">

**Sub meter 3 shows energy consumption of water heater and AC much higher than the othe two**

<img src="/graphs/Yearly_energy_consump_of_appliances_3subm.png"  width="30%" height="30%">

**Seasonality - by quarter**

<img src="/graphs/Monthly_seasonality.png"  width="50%" height="50%">

Energy consumption in winters is substantially higher than summer quarters, which is particularly the case for sub meter 3 (water heater and AC). Sub meter 1 and 2 show slightly downward trend while submeter 3 has somehow upward trend. This observation needs further evidence to prove. 

### 1.2.2 Looking at days in one week

Data of the first week of 2017 was extracted to show how daiy energy consumption varies in one week period of time. 

**Peak usages of kitchen and laundry are among days on the weekend**

<img src="/graphs/Peak%20usage_week.png"  width="50%" height="50%">

Peak kitchen usage seems to happen on the weekends (sub meter 1) while peak laundry days appears to be on Saturday, Sunday and Wednesday (sub meter 2). Insights gained from energy consumption by day of the week could be of value to a homeowner as it can readily be related to homeowner energy consumption behaviors. This in turn provides potential opportunities for behavior modification. 

### 1.2.3 Looking at hours during a day

**Peak hours of energy consumption is in the evening time**

<img src="/graphs/Usage%20within%20a%20day.png"  width="50%" height="50%">

The lowest energy usage is, not surprisingly, in the early morning hours where all sub-meters drop to their minimum. If the local electricity provider offers off-peak rates, this chart would help identify opportunities for the homeowner to shift energy consumption to off-peak hours. For example, a timer on the washing machine and/or the dishwasher could be set to run during off-peak time.

This project will base the overall analysis on a frequency of monthly data, given that the monthly time series can cover the full time span, show the seasonality but without loosing the granularity. 

**Using monthly time series for forecast**

<img src="/graphs/Usage%20across%20the%20whole%20time%20frame.png"  width="70%" height="70%">


## 2. Fit linear regression model to monthly time series

When using regression for prediction, the aim is to forecast the future with time series data. A common property of time series data is trend, which can be forecasted through the regression model. Linear models are fit to monthly times series including the trend and seasonal components, then the outcomes are assessed. 

**Overview of all linear regression models' forecast**

<img src="/graphs/Linear%20regression%20forecast%20of%20all%20submeters.png"  width="50%" height="50%">

Seasonal adjustment was conducted to remove the seasonal component of a time series that exhibits a seasonal pattern, with an aim to analyze the trend of a time series independently of the seasonal components. In this analysis, the decompose() function in the forecast package, which estimates the trend, seasonal, and irregular components of a time series was deployed. 

### 2.1 Submeter 1 - Kitchen

**Actual vs. forecast**

<img src="/graphs/Actual_vs_fitted_SM1.png"  width="50%" height="50%">

**Fit of linear model**

<img src="/graphs/Fitted%20vs%20actual%20SM1.png"  width="25%" height="25%">  <img src="/graphs/Residual%20plot%20SM1.png"  width="25%" height="25%">  <img src="/graphs/SM1%20month%20checkresiduals.png"  width="35%" height="35%">

**Decomposition**

<img src="/graphs/Decomposition%20Subm1.png"  width="30%" height="30%">  

### 2.2 Submeter 2 - Laundry room

**Actual vs. forecast**

<img src="/graphs/Actual_vs_fitted_SM2.png"  width="50%" height="50%">

**Fit of linear model**

<img src="/graphs/Fitted%20vs%20actual%20SM2.png"  width="25%" height="25%">  <img src="/graphs/Residual%20plot%20SM2.png"  width="25%" height="25%">  <img src="/graphs/SM2%20TS%20checkresiduals.png"  width="35%" height="35%">

**Decomposition**

<img src="/graphs/Laundry%20decomposition%20no.2.png"  width="30%" height="30%">

### 2.3 Submeter 3 - Heater and Aircon

**Actual vs. forecast**

<img src="/graphs/Actual_vs_fitted_SM3.png"  width="50%" height="50%">

**Fit of linear model**

<img src="/graphs/Fitted%20vs%20actual%20SM3.png"  width="25%" height="25%">  <img src="/graphs/Residual%20plot%20SM3.png"  width="25%" height="25%">  <img src="/graphs/SM3%20mon%20checkresiduals.png"  width="35%" height="35%">

**Decomposition**

<img src="/graphs/Decomposing%20Subm3%20Heater%20AC.png"  width="30%" height="30%">

## 3. Simple exponential smoothing method on a (pick the logical choice) sample of non-seasonal data samples

To make forecasts using simple exponential smoothing, a simple exponential smoothing predictive model is fit to the time series using the HoltWinters() function from the stats package for R. Before fitting the model, seasonal adjusting on all sub meters by subtracting the seasonal component was conducted.

**Removing seasonality**

<img src="/graphs/Decomposition%20SM1.png"  width="30%" height="30%">  <img src="/graphs/Decomposition%20SM2.png"  width="30%" height="30%">  <img src="/graphs/Decomposition%20SM3.png"  width="30%" height="30%">

**HoltWinters Simple Exponential Smoothing with only forecasted areas**

<img src="/graphs/HW%20SM1.png"  width="30%" height="30%">  <img src="/graphs/HW%20SM2.png"  width="30%" height="30%">  <img src="/graphs/HW%20SM3.png"  width="30%" height="30%">