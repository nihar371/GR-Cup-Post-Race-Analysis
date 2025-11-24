# GR Cup Post-Race Analysis Dashboard

## Project Overview
In the GR Cup, a single mistake on an exit can lead to being overtaken by multiple drivers; every millisecond matters. Traditionally, post-race analysis relies on fragmented data formats—laps, sectors, telemetry, and weather are often stored separately. This fragmentation makes it difficult for drivers and engineers to synthesize information and understand the specific dynamics of a lap.

This project bridges the driver-engineer gap by consolidating raw timing data into a centralized Post-Race Analysis Dashboard. It transforms disjointed datasets into a relational model, providing clear, actionable insights into performance metrics, sector times, and championship standings.

<iframe title="GR Cup Post Race Analysis" width="600" height="373.5" src="https://app.powerbi.com/view?r=eyJrIjoiNzI3YWNjNDQtYzZiNC00YzQ3LTljODgtNWFmYTVjYmI2YzEzIiwidCI6IjhkMWE2OWVjLTAzYjUtNDM0NS1hZTIxLWRhZDExMmY1ZmI0ZiIsImMiOjN9" frameborder="0" allowFullScreen="true"></iframe>

(Some plots might not be visible, due to data constraints a Fiber, as large telemetry files were not possible to be uploaded. Full walkthrough can be found [here](https://youtu.be/rPs4oI0CnDI))


## System Architecture
The solution implements a full data engineering pipeline, moving from raw data extraction to a structured SQL backend, and finally to a Power BI frontend.

**Tech Stack:**
* **Data Collection:** Python, Requests, BeautifulSoup
* **Data Processing:** Python (Pandas)
* **Database:** PostgreSQL
* **Visualization:** Power BI, DAX

## Technical Implementation

### 1. Data Engineering & ETL Pipeline
The foundation of the dashboard is a robust Extract, Transform, Load (ETL) process designed to handle high-anomaly motorsport data.

* **Acquisition:** Official race data (lap times, sectors, race results, standings) is systematically downloaded from the GR Cup North America source.
* **Enrichment (Web Scraping):** Utilized Python (`requests` and `BeautifulSoup`) to scrape driver and team metadata and images. This process included validating broken links and organizing assets into a structured directory for UI integration.
* **Transformation:** Raw datasets required significant cleaning to ensure uniformity across different race events. Key operations included:
    * Normalizing naming conventions and column formats.
    * Handling missing sector values and pit-lane flags.
    * Filtering invalid laps and duplicate records.

### 2. Relational Modeling (PostgreSQL)
Cleaned CSV data is imported into a PostgreSQL database to establish a strict relational schema. This step was critical for performance optimization and data integrity.

* **Schema Design:** Tables were normalized for laps, sectors, sessions, events, drivers, and teams.
* **Optimization:** Created views to handle complex filtering logic pre-query and implemented indexes on high-cardinality fields (Event, Session, Driver) to reduce query time.
* **Integrity:** Enforced foreign-key-like relationships to ensure consistency across all data points.

### 3. Visualization & Analytics (Power BI)
The visualization layer connects directly to the PostgreSQL backend.

* **Data Modeling:** Established active relationships between core tables.
* **DAX Implementation:** Developed custom Data Analysis Expressions (DAX) to calculate specific motorsport metrics, including:
    * Lap time deltas
    * Sector-by-sector improvements
    * Cumulative championship points
* **UX Design:** The interface uses slicers for dynamic filtering by race, driver, and team.

![Power BI Schema](assets\schema\power_bi_schema_image.png)

## Dashboard Features

The application is segmented into three analytical layers:

### 1. Championship View
A season-wide macro view focusing on long-term performance.
* Driver and team standings.
* Points progression and average points per race.
* Driver contribution ratios to team totals.

### 2. Race Analysis
A focused view on specific event dynamics.
* Fastest laps and average pace comparison.
* Position changes and gap evolution charts.
* Cleaned race results with precise time deltas.

### 3. Driver Analysis
A micro-view for technical engineering comparisons.
* Lap-by-lap telemetry comparison.
* Sector improvements and theoretical best laps.
* Track layout overlays with corner/sector mapping.
* Weather context integration.

## Roadmap
The project is evolving from a descriptive analysis tool into a prescriptive performance assistant.

**Phase 1: Automated Reasoning**
* Algorithmic detection of anomalies (e.g., overheating tires, slow sectors).
* Auto-flagging of laps impacted by traffic or pit entries.

**Phase 2: AI Integration**
* **AI Coaching:** Suggestions for braking points and sector focus areas.
* **Predictive Modeling:** Estimating performance gains based on specific variable improvements.
* **NLP Summaries:** Generating natural-language race summaries for engineers.

**Phase 3: Enhanced Telemetry**
* Integration of sensor data (throttle, brake, steering).
* Machine learning-based driver profiling across multiple seasons.