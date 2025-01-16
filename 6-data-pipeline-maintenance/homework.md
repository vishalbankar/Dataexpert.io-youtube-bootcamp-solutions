# Pipeline Management Plan

## Pipelines Overview
### Business Areas and Pipelines
1. **Profit**
   - Unit-level profit needed for experiments
   - Aggregate profit reported to investors
2. **Growth**
   - Aggregate growth reported to investors
   - Daily growth needed for experiments
3. **Engagement**
   - Aggregate engagement reported to investors

---

## Ownership
### Primary and Secondary Owners
| Pipeline                            | Primary Owner   | Secondary Owner   |
|-------------------------------------|-----------------|-------------------|
| Unit-level profit for experiments   | Data Engineer A | Data Engineer B   |
| Aggregate profit for investors      | Data Engineer B | Data Engineer C   |
| Aggregate growth for investors      | Data Engineer C | Data Engineer D   |
| Daily growth for experiments        | Data Engineer D | Data Engineer A   |
| Aggregate engagement for investors  | Data Engineer A | Data Engineer C   |

---

## On-Call Schedule
### Fair Rotation Plan
1. **Weekly Rotation:** Each data engineer takes a week of on-call duty.
2. **Holiday Consideration:**
   - Holidays are distributed equally among the team members.
   - A swap system is implemented for members unavailable during their assigned week.
   - Two engineers are on-call during holiday weeks to ensure coverage.

---

## Run Books
### Investor Metrics Reporting
Each run book should include:
1. **Pipeline Description:**
   - High-level overview of the purpose.
   - Key inputs and outputs.
2. **Monitoring:**
   - List of dashboards or alerts for monitoring pipeline health.
   - Critical error thresholds.
3. **Common Issues:**
   - Typical failure points.
   - Troubleshooting steps.
4. **Restart Procedure:**
   - Detailed steps to restart the pipeline.
5. **Escalation Process:**
   - Contact details for the primary and secondary owners.

---

## Potential Issues
### Risk Assessment
1. **Unit-level profit needed for experiments**
   - Missing or delayed input data.
   - Bugs in profit calculation logic.
   - Data quality issues due to experimentation edge cases.
2. **Aggregate profit reported to investors**
   - Delays in data aggregation.
   - Schema changes in upstream data sources.
   - Performance bottlenecks during peak loads.
3. **Aggregate growth reported to investors**
   - Incorrect growth metric calculations.
   - Versioning issues with growth data models.
   - Data inconsistencies between sources.
4. **Daily growth needed for experiments**
   - Frequent updates causing data lag.
   - Unverified changes in experimental setups.
   - High volume of data leading to processing delays.
5. **Aggregate engagement reported to investors**
   - Engagement definitions misaligned between teams.
   - Dropped data packets during high traffic.
   - Dashboard visualizations not updating.

---

## Notes
- This plan is subject to revision based on team feedback and pipeline performance.
- Regular reviews and updates to run books are essential to accommodate evolving business requirements.
