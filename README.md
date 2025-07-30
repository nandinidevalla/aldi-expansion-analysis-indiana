# 📍 ALDI Expansion Strategy in Indiana

A location intelligence project using SQL and BigQuery to identify high-opportunity regions for ALDI store expansion. Built using real-world mobility and demographic data.

---

## 💡 Project Summary

As part of Purdue’s *Management of Organizational Data (MGMT 58200)* course, our team acted as data analysts for a simulated real estate advisory firm. We used SafeGraph datasets (POI + mobility + demographics) to uncover geographic white spaces for ALDI’s store expansion across Indiana.

> 🔍 This project demonstrates practical skills in **relational data modeling, SQL querying at scale, business rule implementation, and location-based decision support.**

---

## 🛠️ Skills Demonstrated

- **Advanced SQL (BigQuery):** multi-step joins, CTEs, window functions, and JSON parsing
- **Data Aggregation & Feature Engineering:** dwell time, visit counts, grocery density per capita
- **Geospatial Analysis:** county/city-level segmentation, POI-to-county mapping via FIPS codes
- **Business Logic Implementation:** scoring algorithms to prioritize expansion zones
- **Data Storytelling:** summarizing actionable insights through dashboards and presentations

---

## 🔍 Research Questions

1. What’s the current ALDI footprint across Indiana counties?
2. How do foot traffic, dwell time, and store density differ between counties with vs. without ALDI?
3. Which counties show the highest economic potential for new stores?
4. Which **specific cities** in those counties would be ideal for launching a new store?

---

## 📊 Key Insights

- **Morgan County** (no ALDI) and **Tippecanoe County** (has ALDI) surfaced as best expansion candidates.
- **West Lafayette** and **Monrovia** showed above-average income, high dwell time, and stable visit counts.
- Weekday visits were **consistently higher** than weekends — contrary to typical grocery patterns.

---

## 🧰 Tools & Technologies

| Tool         | Purpose                                 |
|--------------|------------------------------------------|
| SQL (BigQuery) | Data wrangling, scoring logic, joins     |
| SafeGraph    | Mobility + POI + demographic datasets    |
| PowerPoint   | Final presentation & stakeholder comms   |
| Python/Excel (optional) | Cleanup and small data prep tasks       |

---

## 📁 Project Structure
queries/ # Raw SQL query log (modular & step-by-step)
report/ # PDF report with narrative, charts & conclusions
presentation/ # Final slide deck used for storytelling


---

## 📎 Resources

- 📄 [Final Report (PDF)](./report/MOD_Group_Project_Team_11.pdf)
- 📊 [SQL Query Log](./queries/MOD_Query_Log_Team11.sql)
- 🖥️ [Presentation Slides](./presentation/MOD_FINAL_PROJECT.pptx)

---

## 👥 Team Members

- Nandini Priya Devalla
- Deepak Saini
- Kshitij Chauhan
- Mokshda Sharma
- Tushar Malankar

---

## 🚀 Why It Matters

This project simulates the kind of **real-world, data-informed decision-making** software and analytics engineers contribute to. It combines structured data processing with business logic, SQL engineering, and storytelling — foundational skills for roles in backend/data/software engineering.

---
