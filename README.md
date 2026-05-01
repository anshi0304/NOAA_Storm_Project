
# NOAA Storm Events Analysis

## Introduction

This project analyzes severe weather events in the United States using the 2025 NOAA Storm Events database. The purpose of the project is to understand which storm event types had the greatest population health impact, which event types occurred most often in different states, and how storm patterns changed by month.

The report is written as if it could be read by a government or municipal manager who may need to understand storm risks and prepare for severe weather events. This project does not make specific recommendations, but it summarizes patterns that could help with planning, preparedness discussions, and resource prioritization.

The final report is written in R Markdown and published as an HTML report.

## Project Goals

The main goals of this project are:

- Analyze population health impact from severe weather events.
- Identify which storm event types caused the most injuries and deaths.
- Examine which event types occurred most often in different states.
- Study how storm event types varied by month.
- Create a reproducible data analysis project using raw NOAA CSV files.
- Present results through tables, figures, and written explanations.

## Data Source

The data comes from the NOAA Storm Events database. Three raw CSV files were used for the 2025 analysis:

- `StormEvents_details-ftp_v1.0_d2025_c20260323.csv`
- `StormEvents_fatalities-ftp_v1.0_d2025_c20260323.csv`
- `StormEvents_locations-ftp_v1.0_d2025_c20260323.csv`

The files were downloaded from the NOAA Storm Events CSV file page:

https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/

NOAA documentation was also used to understand how the files are structured and how variables are defined:

https://www.ncdc.noaa.gov/stormevents/ftp.jsp

https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/Storm-Data-Bulk-csv-Format.pdf

## Research Questions

This project answers the following questions:

1. Across the United States, which types of events are most harmful with respect to population health?
2. Across the United States, which types of events are most happening in which states?
3. Which types of events are characterized by which months?
4. Which states had the highest total population health impact from storm events in 2025?

## Project Files

The project folder contains the following files:

* `NOAA_Storm_Project.Rmd`

  * The main R Markdown report.
  * Includes the written explanation, code, tables, figures, limitations, conclusion, and references.

* `NOAA_Storm_Project.html`

  * The knitted HTML version of the R Markdown report.
  * This is the final report that can be published to RPubs.

* `NOAA_Storm_Project.R`

  * The code-only R script for the project.
  * Includes the full analysis workflow from loading the data to creating the tables and figures.

* `NOAA_Storm_Project.Rproj`

  * The RStudio project file.
  * Helps keep the project organized in one working directory.

* `StormEvents_details-ftp_v1.0_d2025_c20260323.csv`

  * The raw NOAA details file.
  * Contains the main information about each storm event, such as event type, state, dates, deaths, injuries, and damage fields.

* `StormEvents_fatalities-ftp_v1.0_d2025_c20260323.csv`

  * The raw NOAA fatalities file.
  * Contains additional fatality-related information connected to storm events.

* `StormEvents_locations-ftp_v1.0_d2025_c20260323.csv`

  * The raw NOAA locations file.
  * Contains geographic and location-related information for storm events.

* `StormEvents_joined_data.csv`

  * The joined dataset created from the three raw NOAA files.
  * This file is created by joining the raw files using `EVENT_ID`.

* `README.md`

  * The project documentation file.
  * Explains the project purpose, files, workflow, variables, and reproducibility steps.

## Pre-Reqs

To run this project, you will need:

* R
* RStudio
* The three NOAA Storm Events CSV files
* The required R packages

The required R packages are:

* `dplyr`
* `readr`
* `ggplot2`

To install the packages, run:

```r
install.packages("dplyr")
install.packages("readr")
install.packages("ggplot2")
```

## Installation and Set Up

1. Download the three raw NOAA CSV files for 2025:

   * `StormEvents_details-ftp_v1.0_d2025_c20260323.csv`
   * `StormEvents_fatalities-ftp_v1.0_d2025_c20260323.csv`
   * `StormEvents_locations-ftp_v1.0_d2025_c20260323.csv`

2. Create a project folder named:

   ```text
   NOAA_Storm_Project
   ```

3. Place all three raw CSV files in the project folder.

4. Open RStudio.

5. Open the RStudio project file:

   ```text
   NOAA_Storm_Project.Rproj
   ```

6. Open the R Markdown file:

   ```text
   NOAA_Storm_Project.Rmd
   ```

7. Check the folder path in the code:

   ```r
   folder_path <- "~/Documents/NOAA_Storm_Project"
   ```

   If your project folder is saved somewhere else, update the path before running the project.

8. Click **Knit** in RStudio to create the HTML report.

## Step-by-Step Workflow

The project follows this pipeline from raw data to final output:

1. Download the three raw NOAA CSV files for 2025.

2. Save all three files in the same project folder.

3. Load the required R libraries:

   * `dplyr`
   * `readr`
   * `ggplot2`

4. Define the project folder path in R.

5. Create file paths for the details, fatalities, and locations files using `file.path()`.

6. Read the three raw CSV files into R using `read_csv()`.

7. Join the three datasets using `EVENT_ID`.

8. Save the joined dataset as:

   ```text
   StormEvents_joined_data.csv
   ```

9. Clean the joined dataset by keeping one row per `EVENT_ID`.

10. Select only the variables needed for the analysis.

11. Create new variables:

* `total_fatalities`
* `total_injuries`
* `health_impact`
* `month`

12. Use the cleaned dataset to answer the four project questions.

13. Create tables and figures for each question.

14. Knit the R Markdown report to HTML.

15. Publish the final HTML report to RPubs.

## Data Processing Explanation

The three NOAA files were joined using `EVENT_ID` because this variable connects the same storm event across the details, fatalities, and locations files.

The details file was used as the main dataset because it contains the main storm event information. The locations and fatalities files were joined to add more information connected to each event.

A many-to-many warning may appear during the join because some storm events can have multiple location records or multiple fatality records. To keep the analysis at the storm-event level, the cleaned dataset keeps one row per `EVENT_ID`. This helps avoid double-counting storm events in the event-level summaries.

The joined dataset is saved as `StormEvents_joined_data.csv` so there is a clear intermediate output between the raw data and the final analysis.

## Data Dictionary

The main variables used in this project are:

| Variable            | Description                                                                                                   |
| ------------------- | ------------------------------------------------------------------------------------------------------------- |
| `EVENT_ID`          | Unique identifier for each storm event. Used to join the details, fatalities, and locations files.            |
| `STATE`             | State where the storm event was recorded.                                                                     |
| `EVENT_TYPE`        | Type of storm event, such as thunderstorm wind, flood, tornado, winter storm, or heat.                        |
| `MONTH_NAME`        | Month when the storm event occurred.                                                                          |
| `month`             | Cleaned version of `MONTH_NAME` used in the analysis.                                                         |
| `BEGIN_DATE_TIME`   | Date and time when the storm event began.                                                                     |
| `END_DATE_TIME`     | Date and time when the storm event ended.                                                                     |
| `INJURIES_DIRECT`   | Injuries directly caused by the storm event.                                                                  |
| `INJURIES_INDIRECT` | Injuries indirectly connected to the storm event.                                                             |
| `DEATHS_DIRECT`     | Deaths directly caused by the storm event.                                                                    |
| `DEATHS_INDIRECT`   | Deaths indirectly connected to the storm event.                                                               |
| `DAMAGE_PROPERTY`   | Reported property damage from the storm event.                                                                |
| `DAMAGE_CROPS`      | Reported crop damage from the storm event.                                                                    |
| `total_fatalities`  | Created variable that adds `DEATHS_DIRECT` and `DEATHS_INDIRECT`.                                             |
| `total_injuries`    | Created variable that adds `INJURIES_DIRECT` and `INJURIES_INDIRECT`.                                         |
| `health_impact`     | Created variable that adds `total_fatalities` and `total_injuries`. Used to measure population health impact. |

## Transformation Decisions

Several transformation decisions were made during the project:

* The three NOAA files were joined by `EVENT_ID` because this variable connects the same storm event across the datasets.
* The cleaned dataset keeps one row per `EVENT_ID` to avoid double-counting after joining the files.
* Only the variables needed for the project questions were kept in the cleaned dataset.
* `total_fatalities` was created by adding direct and indirect deaths.
* `total_injuries` was created by adding direct and indirect injuries.
* `health_impact` was created by combining total fatalities and total injuries.
* `month` was created from the NOAA `MONTH_NAME` variable so monthly storm patterns could be analyzed.

The `health_impact` variable was created because the first research question focuses on population health. Looking at fatalities and injuries together gives a broader view of how storm events affected people.

## Analysis Summary

The report includes four main parts of analysis:

* Event types with the highest population health impact.
* Most common storm event types by state.
* Monthly patterns for common storm event types.
* States with the highest total population health impact.

The results are shown using both tables and figures. Tables provide exact values, while figures make the patterns easier to compare visually.

## Figures Included

The final report includes four figures:

* **Figure 1:** Top 10 storm event types by total population health impact in 2025.
* **Figure 2:** Top 10 states by total number of recorded storm events in 2025.
* **Figure 3:** Number of recorded storm events by month for the five most common event types in 2025.
* **Figure 4:** Top 10 states by total population health impact from storm events in 2025.

The report uses four figures, which stays within the assignment requirement of no more than five figures.

## Reproducibility

This project is designed to be reproducible. Another user should be able to recreate the results by following the setup and workflow steps.

To reproduce the project:

1. Download the same three NOAA CSV files.
2. Place the files in the `NOAA_Storm_Project` folder.
3. Open `NOAA_Storm_Project.Rproj` in RStudio.
4. Open `NOAA_Storm_Project.Rmd`.
5. Check that the folder path matches the project folder location.
6. Install the required R packages if needed.
7. Click **Knit** to create the HTML report.

The project should be run from the RStudio project folder so the file paths work correctly. If the folder is saved in a different location, update `folder_path` in both the `.Rmd` and `.R` files.

No data was manually edited outside of R. The raw files are loaded, joined, cleaned, summarized, and visualized using R code.

## Output

The main intermediate output is:

* `StormEvents_joined_data.csv`: intermediate joined dataset created from the three raw NOAA files.

The final outputs are:

* `NOAA_Storm_Project.html`: knitted HTML version of the final report.
* `NOAA_Storm_Project.Rmd`: R Markdown report with code, explanations, tables, and figures.
* `NOAA_Storm_Project.R`: code-only R script for the analysis.
* RPubs URL: public link to the published HTML report.
* GitHub repository URL: repository containing the project files and documentation.

## Limitations

There are a few limitations to this project.

First, the analysis only uses the 2025 NOAA Storm Events data, so it does not show long-term trends across multiple years.

Second, the data depends on recorded and reported storm events. Some events may be missing, incomplete, or reported differently across states.

Third, the cleaned dataset keeps one row per `EVENT_ID` to avoid double-counting after the files are joined. This makes the event-level summaries clearer, but it may leave out some detailed location-level or fatality-level information.

Due to these limitations, the results should be understood as a summary of recorded 2025 storm events rather than a complete picture of all severe weather risks.

## RPubs Link

RPubs URL:
```text
https://rpubs.com/Anshi0304/NOAA-Storm-Events-Analysis
```

## GitHub Repository

GitHub Repository URL:
```text
https://github.com/anshi0304/NOAA_Storm_Project.git
```

## Author

Anshika Sharma

