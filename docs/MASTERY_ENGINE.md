# Mastery Engine & Gate Validation

The ChessMaster Mastery Engine guarantees that no user is awarded false progress or unearned badges. Progress requires passing quantitative gates.

## Mastery Gate Thresholds

A skill node is granted `[MASTERED]` status **if and only if** all six criteria are simultaneously satisfied:

| Metric | Required Threshold | Description |
| :--- | :--- | :--- |
| **Knowledge Score** | `>= 90.0%` | Understanding of theoretical principles & rules |
| **Isolated Drill Accuracy** | `>= 90.0%` | Accuracy in targeted, motif-specific laboratory exercises |
| **Mixed Puzzle Accuracy** | `>= 85.0%` | Accuracy in mixed tactical and strategic puzzle batteries |
| **Real-Game Application** | `>= 80.0%` | Successful execution in serious / tournament games |
| **7-Day Retention** | `>= 85.0%` | Recall accuracy on review items after 7 days |
| **30-Day Retention** | `>= 80.0%` | Recall accuracy on review items after 30 days |

## Decay Detection
- Skills are marked `[DECAYING]` if:
  1. `DateTime.now().difference(lastPracticed).inDays > 14`, OR
  2. Retention tests drop below 80%.
- Decaying skills are flagged on the user's dashboard and immediately queued for retesting in the next daily plan.

## Weekly Exam Gates
Weekly exams on days `7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 90`:
- Strict pass threshold: `>= 85.0%`.
- If an exam is failed, the daily planner prevents advancing to higher-order curriculum days and redistributes hours to weakness reinforcement.
