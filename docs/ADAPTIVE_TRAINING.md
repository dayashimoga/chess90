# Adaptive Training & Daily Planner

The ChessMaster Adaptive Training Scheduler dynamically shifts daily study time based on the user's available time budget, active weaknesses, and Leitner spaced-repetition queue.

## Supported Time Modes

1. **Intensive GM Day (Default: ~7.5 to 8 Hours)**:
   - Tactical Foundation & Pattern Vision: 50 minutes
   - Deep Concrete Calculation: 90 minutes
   - Positional Strategy & Current Curriculum Phase: 60 minutes
   - Endgame Technique: 60 minutes
   - Opening Repertoire & Model Games: 45 minutes
   - Serious Classical Game (Tournament conditions): 120 minutes
   - Human Self-Analysis & Root-Cause Engine Audit: 60 minutes
   - Weakness Retraining & Spaced Review: 30 minutes.

2. **Standard Mode (30 to 60 Minutes)**:
   - Spaced Review: 10 minutes
   - Core Curriculum Lab: 40% of remaining time
   - Serious Game & Self-Analysis: 40% of remaining time.

3. **Express Mode (5 to 15 Minutes)**:
   - Spaced Repetition Review Queue: 5 minutes
   - High-Intensity Weakness Drill: remaining time.

## Spaced Repetition (Leitner System)
Interval progression across 6 stages:
```
Stage 0: Same Session (0 days)
Stage 1: 1 Day
Stage 2: 3 Days
Stage 3: 7 Days
Stage 4: 14 Days
Stage 5: 30 Days (Permanent Retention)
```
- Correct attempt: Item advances to `stage + 1`.
- Incorrect attempt: Item is demoted back to `stage 0` or `stage 1`.
- Any mistake diagnosed in post-game analysis is automatically minted into a `ReviewItem` and scheduled for spaced review.
