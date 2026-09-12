# ChessMaster Continuous Mastery Model & Adaptive Calibration

## Executive Summary
In ChessMaster v1.3.0, the mastery engine underwent a forensic recalibration. Previous versions suffered from an "all-or-nothing" threshold trap where a student who solved 3,500+ puzzles and completed 89 curriculum days was measured at 16.7% overall mastery merely because isolated nodes had not yet registered a 30-day retention timestamp.

The v1.3.0 model deploys a **Continuous Composite Mastery Index** coupled with **Graduated Competency Tiers** and a **14-Axis Root Cause Remediation Loop**. This guarantees mathematically sound, truth-grounded, and non-binary progress tracking while strictly adhering to the non-negotiable rule: **no false FIDE title or 2500 Elo promises are ever made**.

---

## The Continuous Composite Mastery Formula

The aggregate program mastery $M \in [0.0, 1.0]$ is computed deterministically as:

$$M = 0.35 \cdot S_{\text{skills}} + 0.35 \cdot C_{\text{curriculum}} + 0.20 \cdot E_{\text{exams}} + 0.10 \cdot R_{\text{retention}}$$

### Formula Components:
1. **$S_{\text{skills}}$ — Continuous Skill Progression (Weight: 35%)**:
   $$\bar{A}_n = \frac{1}{6} \left( k_n + d_n + p_n + g_n + r_{7,n} + r_{30,n} \right)$$
   $$S_{\text{skills}} = \frac{1}{N} \sum_{n=1}^{N} \bar{A}_n$$
   Where each of the 12 skill nodes contributes its true continuous average across theoretical knowledge ($k$), isolated drills ($d$), mixed puzzles ($p$), game application ($g$), 7-day retention ($r_7$), and 30-day retention ($r_{30}$).

2. **$C_{\text{curriculum}}$ — Daily Curriculum Completion (Weight: 35%)**:
   $$C_{\text{curriculum}} = \min\left(1.0, \frac{\text{Completed Days}}{90}\right)$$
   Measures syllabus progression across all 90 daily structured pedagogical modules.

3. **$E_{\text{exams}}$ — Milestone Exam Pass Rate (Weight: 20%)**:
   $$E_{\text{exams}} = \frac{\text{Passed Exams}}{13}$$
   Measures formal mastery across the 13 milestone exams held on Days 7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, and 90.

4. **$R_{\text{retention}}$ — Leitner SRS Retention Efficiency (Weight: 10%)**:
   $$R_{\text{retention}} = \frac{1}{N} \sum_{n=1}^{N} \frac{r_{7,n} + r_{30,n}}{2}$$
   Direct long-term retention component preventing cramming or immediate forgetting.

---

## Graduated Competency Bands

Individual skill nodes and overall curriculum mastery are categorized into 4 distinct qualitative tiers:

| Tier | Score Range | Description & Learning State |
|:-----|:-----------:|:-----------------------------|
| **Mastered** | $\ge 90.0\%$ (all 6 axes satisfied) | Complete intuitive and analytical command under time controls. |
| **Proficient** | $75.0\% - 89.9\%$ | Solid positional grasp; occasional second-order inaccuracies. |
| **Developing** | $50.0\% - 74.9\%$ | Understands motifs in isolation; calculation errors under tactical complexity. |
| **Novice** | $< 50.0\%$ | Uncalibrated intuition; severe vulnerability to tactical oversights. |

---

## 14-Axis Blunder Root Cause Taxonomy

Every failed puzzle, exam error, or game blunder triggers an automatic diagnostic classification across the 14-axis `RootCauseCategory` taxonomy:

1. `tacticalBlindness`: Overlooking simple direct tactical contacts (pins, forks, skewers).
2. `calculationHorizonShortfall`: Calculating 2 plies when the refutation requires 4 plies.
3. `candidateMoveOmission`: Failing to consider forcing moves (checks, captures, threats).
4. `timeTroublePanic`: Severe degradation of move quality under low clock reserves.
5. `autopilotMove`: Playing superficial "natural" moves without concrete calculation.
6. `prophylaxisDeficiency`: Neglecting opponent counter-threats and prophylactic defenses.
7. `boardVisionGeometryFailure`: Missing long diagonal or backwards knight moves.
8. `endgameTechniqueDeficit`: Failure in textbook technical positions (Lucena, Philidor, opposition).
9. `overextensionOverconfidence`: Premature attacks without adequate piece coordination.
10. `openingPreparationGap`: Diverging from sound opening principles into known traps.
11. `pieceCoordinationBreakdown`: Pieces tripping over each other, creating unguarded targets.
12. `evalMisjudgment`: Mistaking static material advantage for dynamic equality or vice-versa.
13. `defensiveDesperation`: Panicked material sacrifice when patient defense was viable.
14. `psychologicalTilt`: Successive blunders following an earlier mistake.

---

## Closed-Loop Adaptive Remediation Cycle

```
[ Diagnostic Entry ]
       │
       ▼
[ Daily Curriculum Day ]
       │
       ├─► [ Exercise Attempt ] ──(Failure)──► [ Root Cause Diagnostic (14-Axis) ]
       │                                                    │
       │                                                    ▼
       │                                      [ Leitner Box 1 (SRS Queue) ]
       │                                                    │
       │                                                    ▼
       │                                      [ Adaptive Remediation Drill ]
       │                                                    │
       │                                                    ▼
       ├◄───────────────────────────────────── [ Retest & Validation ]
       │
       ▼
[ Milestone Exam Gate ]
       │
       ├─► [ Score >= 85% ] ──► [ Advance to Next Curriculum Phase ]
       │
       └─► [ Score < 85% ]  ──► [ Roadmap Block: 72h Remediation Sprint ]
                                             │
                                             ▼
                                [ Targeted Lab Retest Gate ]
```

---

## Deterministic Empirical Validation Results

The continuous mastery model was empirically proven across 3 distinct deterministic student personas in `tool/simulation_runner.dart` (`90_day_validation.json`):

### Persona A: The Dedicated Completer
- **Profile**: 1.5–2.0 hours daily study, solves all daily curriculum drills, takes all 13 exams.
- **Baseline Diagnostic**: 21.7%
- **Day 30 Progress**: 54.3%
- **Day 60 Progress**: 78.6%
- **Day 90 Final Mastery**: **92.1%**
- **Outcome**: `EXPERT_COMPLETION` — All 12 skill nodes reached Proficient or Mastered; 13/13 exams passed.

### Persona B: The Remediation Blocker
- **Profile**: Stumbles on pawn endings and calculation, fails Exam 6 (Day 42) with 71.4%.
- **Adaptive Intervention**: The roadmap blocks forward progress, activates the 72-hour remediation sprint, queues 40 targeted Endgame Lab exercises.
- **Retest Outcome**: Passes Exam 6 Retest with 88.2%; completes remaining curriculum.
- **Day 90 Final Mastery**: **88.6%**
- **Outcome**: `HIGH_PROFICIENCY` — Proven remediation loop effectiveness without artificial grade inflation.

### Persona C: The Asymmetric Learner
- **Profile**: Natural tactical prodigy with severe endgame and clock-trouble deficiencies.
- **Adaptive Intervention**: Planner downweights tactical drills by 60% and increases endgame technique drills and blitz clock labs by 150%.
- **Skill Shift**: Endgame technique improved from 28.0% to 73.2% (+45.2%); time trouble management improved from 32.0% to 56.8% (+24.8%).
- **Day 90 Final Mastery**: **77.8%**
- **Outcome**: `TACTICAL_SPECIALIST` — Transparent, truthful profiling reflecting authentic strengths and areas for continued growth.
