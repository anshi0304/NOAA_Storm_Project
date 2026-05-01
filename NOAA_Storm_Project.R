# NOAA Storm Events Final Project
# Analysis of NOAA Storm Events in the United States, 2025
# Author: Anshika Sharma
#
# Purpose:
# This script loads the raw NOAA Storm Events CSV files, joins them by EVENT_ID,
# creates a cleaned dataset, and answers the four required analysis questions.
#
# Data files used:
# 1. StormEvents_details-ftp_v1.0_d2025_c20260323.csv
# 2. StormEvents_fatalities-ftp_v1.0_d2025_c20260323.csv
# 3. StormEvents_locations-ftp_v1.0_d2025_c20260323.csv
#
# Important note:
# The raw CSV files should be saved in the same project folder before running this script.

# ------------------------------------------------------------
# 1. Load necessary libraries
# ------------------------------------------------------------

# dplyr is used for data cleaning, joining, grouping, and summarizing.
library(dplyr)

# readr is used to read and write CSV files.
library(readr)

# lubridate is included in case date handling is needed.
library(lubridate)

# ggplot2 is used to create the figures.
library(ggplot2)

# ------------------------------------------------------------
# 2. Define the project folder and file paths
# ------------------------------------------------------------

# This folder path tells R where the project files are saved.
# If another person runs this script, they may need to change this path
# to match the location of their own project folder.
folder_path <- "~/Documents/NOAA_Storm_Project"

# These lines create the full file paths for the three raw NOAA CSV files.
# Using file.path() is better than typing the full path manually because it
# builds the path in a cleaner and more reproducible way.
details_file <- file.path(folder_path, "StormEvents_details-ftp_v1.0_d2025_c20260323.csv")
fatalities_file <- file.path(folder_path, "StormEvents_fatalities-ftp_v1.0_d2025_c20260323.csv")
locations_file <- file.path(folder_path, "StormEvents_locations-ftp_v1.0_d2025_c20260323.csv")

# ------------------------------------------------------------
# 3. Load the raw NOAA CSV files
# ------------------------------------------------------------

# The details file contains the main storm event information,
# such as event type, state, date, injuries, deaths, and damage fields.
details <- read_csv(details_file)

# The fatalities file contains additional fatality-related records
# connected to storm events.
fatalities <- read_csv(fatalities_file)

# The locations file contains location information for storm events.
locations <- read_csv(locations_file)

# ------------------------------------------------------------
# 4. Join the three datasets by EVENT_ID
# ------------------------------------------------------------

# EVENT_ID is used as the key because it connects the same storm event
# across the details, fatalities, and locations files.
#
# left_join() keeps all rows from the details file and adds matching
# information from the locations and fatalities files.
#
# A many-to-many warning may appear because some events can have multiple
# location or fatality records. The cleaning step later keeps one row per
# EVENT_ID for the event-level analysis.
joined_data <- details %>%
  left_join(locations, by = "EVENT_ID") %>%
  left_join(fatalities, by = "EVENT_ID")

# Save the joined dataset as a CSV file.
# This creates the required joined data file in the project folder.
output_file <- file.path(folder_path, "StormEvents_joined_data.csv")
write_csv(joined_data, output_file)

# Print a message showing where the joined file was saved.
message("Joined data saved to: ", output_file)

# View the first few rows of the joined dataset to check that it loaded correctly.
print(head(joined_data))

# ------------------------------------------------------------
# 5. Clean the joined dataset
# ------------------------------------------------------------

# The joined dataset has many columns. For this project, I keep only the
# variables needed to answer the analysis questions.
#
# distinct(EVENT_ID, .keep_all = TRUE) keeps one row per storm event.
# This helps avoid double-counting after joining the locations and fatalities files.
#
# total_fatalities combines direct and indirect deaths.
# total_injuries combines direct and indirect injuries.
# health_impact combines fatalities and injuries to measure population health impact.
# month keeps the NOAA MONTH_NAME variable in a simpler column name.
storm_clean <- joined_data %>%
  distinct(EVENT_ID, .keep_all = TRUE) %>%
  mutate(
    total_fatalities = DEATHS_DIRECT + DEATHS_INDIRECT,
    total_injuries = INJURIES_DIRECT + INJURIES_INDIRECT,
    health_impact = total_fatalities + total_injuries,
    month = MONTH_NAME
  ) %>%
  select(
    EVENT_ID,
    STATE,
    EVENT_TYPE,
    month,
    BEGIN_DATE_TIME,
    END_DATE_TIME,
    INJURIES_DIRECT,
    INJURIES_INDIRECT,
    DEATHS_DIRECT,
    DEATHS_INDIRECT,
    total_fatalities,
    total_injuries,
    health_impact,
    DAMAGE_PROPERTY,
    DAMAGE_CROPS
  )

# View the first few rows of the cleaned dataset.
head(storm_clean)

# ------------------------------------------------------------
# 6. Question 1
# Across the United States, which types of events are most harmful
# with respect to population health?
# ------------------------------------------------------------

# Group the cleaned data by EVENT_TYPE so each weather event type can be compared.
# Then calculate total fatalities, injuries, and combined health impact.
health_by_event <- storm_clean %>%
  group_by(EVENT_TYPE) %>%
  summarize(
    total_fatalities = sum(total_fatalities, na.rm = TRUE),
    total_injuries = sum(total_injuries, na.rm = TRUE),
    total_health_impact = sum(health_impact, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(total_health_impact))

# Show the 10 event types with the highest combined health impact.
head(health_by_event, 10)

# Create Figure 1:
# This bar chart shows the top 10 event types by total population health impact.
# coord_flip() is used because event names can be long, and horizontal bars
# are easier to read.
health_by_event %>%
  slice_max(total_health_impact, n = 10) %>%
  ggplot(aes(x = reorder(EVENT_TYPE, total_health_impact),
             y = total_health_impact)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Most Harmful Storm Event Types by Population Health Impact",
    x = "Event Type",
    y = "Total Fatalities and Injuries"
  )

# ------------------------------------------------------------
# 7. Question 2
# Across the United States, which types of events are most happening
# in which states?
# ------------------------------------------------------------

# Count how many times each EVENT_TYPE appears in each STATE.
# This shows event frequency by state and event type.
events_by_state <- storm_clean %>%
  group_by(STATE, EVENT_TYPE) %>%
  summarize(
    event_count = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(event_count))

# For each state, keep the single event type that occurred most often.
# with_ties = FALSE keeps only one event type if there is a tie.
top_event_by_state <- events_by_state %>%
  group_by(STATE) %>%
  slice_max(event_count, n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  arrange(STATE)

# Show the most common event type for the first 15 states.
head(top_event_by_state, 15)

# Count the total number of storm events recorded in each state.
# This is used for the state-level frequency chart.
state_event_counts <- storm_clean %>%
  group_by(STATE) %>%
  summarize(
    total_events = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(total_events))

# Create Figure 2:
# This bar chart shows the 10 states with the highest number of recorded events.
# This answers where storm events were recorded most often.
state_event_counts %>%
  slice_max(total_events, n = 10) %>%
  ggplot(aes(x = reorder(STATE, total_events),
             y = total_events)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 States by Number of Storm Events",
    x = "State",
    y = "Number of Recorded Events"
  )

# ------------------------------------------------------------
# 8. Question 3
# Which types of events are characterized by which months?
# ------------------------------------------------------------

# Count how many times each EVENT_TYPE occurred in each month.
# This helps identify monthly or seasonal patterns.
events_by_month <- storm_clean %>%
  group_by(month, EVENT_TYPE) %>%
  summarize(
    event_count = n(),
    .groups = "drop"
  ) %>%
  arrange(month, desc(event_count))

# For each month, keep the event type that occurred most often.
top_event_by_month <- events_by_month %>%
  group_by(month) %>%
  slice_max(event_count, n = 1, with_ties = FALSE) %>%
  ungroup()

# Display the most common event type for each month.
top_event_by_month

# Find the five most common event types overall.
# Limiting the plot to five event types keeps the figure readable.
top_five_events <- storm_clean %>%
  count(EVENT_TYPE, sort = TRUE) %>%
  slice_max(n, n = 5) %>%
  pull(EVENT_TYPE)

# Filter the cleaned data to only include the five most common event types.
# Then count how often those event types occurred in each month.
monthly_top_events <- storm_clean %>%
  filter(EVENT_TYPE %in% top_five_events) %>%
  group_by(month, EVENT_TYPE) %>%
  summarize(
    event_count = n(),
    .groups = "drop"
  )

# Create Figure 3:
# This grouped bar chart compares the top five event types across months.
# position = "dodge" places the bars side by side within each month.
monthly_top_events %>%
  ggplot(aes(x = month, y = event_count, fill = EVENT_TYPE)) +
  geom_col(position = "dodge") +
  labs(
    title = "Common Storm Event Types by Month",
    x = "Month",
    y = "Number of Recorded Events",
    fill = "Event Type"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# ------------------------------------------------------------
# 9. Question 4
# Which states had the highest total population health impact
# from storm events in 2025?
# ------------------------------------------------------------

# Group the cleaned data by STATE.
# Then calculate total fatalities, total injuries, and combined health impact.
health_by_state <- storm_clean %>%
  group_by(STATE) %>%
  summarize(
    total_fatalities = sum(total_fatalities, na.rm = TRUE),
    total_injuries = sum(total_injuries, na.rm = TRUE),
    total_health_impact = sum(health_impact, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(total_health_impact))

# Show the 10 states with the highest population health impact.
head(health_by_state, 10)

# Create Figure 4:
# This bar chart shows the states with the highest combined fatalities and injuries.
# It focuses on human impact instead of only event frequency.
health_by_state %>%
  slice_max(total_health_impact, n = 10) %>%
  ggplot(aes(x = reorder(STATE, total_health_impact),
             y = total_health_impact)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 States by Population Health Impact",
    x = "State",
    y = "Total Fatalities and Injuries"
  )

# ------------------------------------------------------------
# End of script
# ------------------------------------------------------------