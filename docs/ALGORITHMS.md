# Algorithms & Calculations

## Pass Australian Citizenship Test

### Algorithm Specification Document

**Version:** 2.0

**Last Updated:** 2026-07-20

---

# 1. Purpose

This document defines the algorithmic calculations used in the application, including:

- Readiness Score calculation
- Weak Area Analysis
- Performance metrics aggregation
- Recommendation engine

All calculations are performed locally on the user's device. No external services required.

---

# 2. Readiness Score Algorithm

## 2.1 Purpose

The Readiness Score provides a single confidence indicator (0-100%) showing how prepared the user is to take the official Australian Citizenship Test.

Available to every user.

---

## 2.2 Input Data

The algorithm uses the following metrics:

1. **Overall Accuracy** - Accuracy across all practice questions
2. **Mock Exam Performance** - Performance on timed mock exams
3. **Category Coverage** - How many categories the user has practiced
4. **Category Mastery** - Per-category accuracy levels
5. **Difficulty Distribution** - Performance across easy/medium/hard questions
6. **Recent Activity** - Recency of practice sessions
7. **Mock Exam Trend** - Performance trend across multiple exams

---

## 2.3 Algorithm Steps

### Step 1: Calculate Base Accuracy Score (0-100)

```
Base Accuracy = (User Total Correct / User Total Attempts) * 100

Eligibility requirement:
- Determine the number of answered practice questions in every active category
- Every active category must have at least 20 answered practice questions
- If any category has fewer than 20, do not calculate or display a score
- Return "Not enough data" instead
```

Repeated attempts count as answered practice questions. Mock-exam answers do
not count toward this eligibility gate.

The readiness input must include per-category attempt counts. The result should
also expose the categories and remaining attempt counts needed to become
eligible so the UI can guide the user.

---

### Step 2: Calculate Mock Exam Performance Score (0-100)

Only uses completed mock exams.

```
If user has completed 0 mock exams:
  Mock Exam Score = Base Accuracy * 0.5  (reduced confidence for untested)

If user has completed 1+ mock exams:
  Mock Exam Score = (Average of all mock exam scores) * 1.0
  
  Where Mock Exam Score = (Correct Answers / Total Questions) * 100
```

**Weighting:** Mock exams are weighted more heavily as they're closer to official test.

---

### Step 3: Calculate Category Coverage Score (0-100)

```
Active Categories = count of categories with at least 1 attempt
Total Categories = total number of question categories

Coverage Percentage = (Active Categories / Total Categories) * 100

Coverage Score = Coverage Percentage * 0.8
(Capped at 80 points - 20 points reserved for mastery)

Example:
- User has practiced 6 out of 8 categories
- Coverage Score = (6 / 8) * 100 * 0.8 = 60 points
```

---

### Step 4: Calculate Category Mastery Bonus (0-20)

```
Mastery Threshold = 80% accuracy in a category

Mastered Categories = count of categories where accuracy >= 80%

Mastery Bonus = (Mastered Categories / Total Categories) * 20

Example:
- 8 total categories
- User has mastered 5 categories
- Mastery Bonus = (5 / 8) * 20 = 12.5 points
```

---

### Step 5: Calculate Difficulty Distribution Score (0-100)

Test whether user can handle all difficulty levels.

```
Easy Accuracy = (Easy Correct / Easy Attempts) * 100
Medium Accuracy = (Medium Correct / Medium Attempts) * 100
Hard Accuracy = (Hard Correct / Hard Attempts) * 100

Difficulty Score = (Easy Accuracy * 0.2 + Medium Accuracy * 0.4 + Hard Accuracy * 0.4) * 1.0

Rationale:
- Medium and Hard questions weighted more as they indicate true understanding
- Easy questions weighted less as they're confidence builders
```

---

### Step 6: Calculate Recency Score (0-100)

Encourages continued practice close to test date.

```
Last Attempt Date = most recent practice question or exam

Days Since Practice = current_date - last_attempt_date (in days)

If Days Since Practice <= 1:
  Recency Score = 100

Else If Days Since Practice <= 3:
  Recency Score = 70

Else If Days Since Practice <= 7:
  Recency Score = 30

Else (Days Since Practice > 7):
  Recency Score = 0
```

---

### Step 7: Calculate Mock Exam Trend Score (0-100)

Measures improvement across mock exams.

```
If user has completed < 2 mock exams:
  Trend Score = 0 (insufficient data)

If user has completed >= 2 mock exams:
  Exams Sorted By Date (oldest first)
  
  First Exam Score = score of first exam
  Latest Exam Score = score of most recent exam
  
  Score Difference = Latest Exam Score - First Exam Score
  
  If Score Difference >= 10:
    Trend Score = 100 (strong improvement)
  
  Else If Score Difference >= 5:
    Trend Score = 70 (moderate improvement)
  
  Else If Score Difference >= 0:
    Trend Score = 30 (stable or slight improvement)
  
  Else (Score Difference < 0):
    Trend Score = 0 (score declined)
```

---

## 2.4 Final Readiness Score Calculation

### Composite Score (Before Adjustments)

```
Readiness Score (Raw) = 
    (Base Accuracy * 0.25) +
    (Mock Exam Score * 0.30) +
    (Coverage Score + Mastery Bonus) * 0.20 +
    (Difficulty Score * 0.15) +
    (Recency Score * 0.05) +
    (Trend Score * 0.05)

Total Weight: 0.25 + 0.30 + 0.20 + 0.15 + 0.05 + 0.05 = 1.0
```

---

### No-Mock Confidence Adjustment

```
If user has NOT completed at least 1 full mock exam:
  
  Apply Penalty:
  Readiness Score = Readiness Score (Raw) * 0.7
  
  Rationale: Untested users should show lower confidence
  
  Note: Still display the score but with visual indicator
        "Practice a mock exam to get a more accurate readiness score"
```

---

### Australian Values Readiness Adjustment

The official test requires all five Australian values questions to be correct.
This is a mandatory readiness constraint, not merely another weighted category.

Use the five most recently answered Australian values practice questions and
official-style mock exam results:

```
Recent Values Practice Perfect =
  the most recent 5 Australian values practice answers are all correct

Qualifying Mock =
  overall score >= configured pass mark
  AND Australian values score == 5/5

If Recent Values Practice Perfect is false:
  Readiness Score = MIN(Readiness Score, 69)

Else if there is no completed mock exam:
  Readiness Score = MIN(Readiness Score, 79)

Else if the most recent mock exam is not a Qualifying Mock:
  Readiness Score = MIN(Readiness Score, 79)

Else if the most recent mock is Qualifying but the previous mock is not:
  Readiness Score = MIN(Readiness Score, 89)

Else if the two most recent mocks are both Qualifying:
  No Australian values cap is applied
```

Older mistakes do not permanently prevent readiness. The rule measures recent,
repeatable performance.

---

### Final Score

```
Readiness Score = MAX(0, MIN(100, Readiness Score))

Round to nearest integer for display
```

---

## 2.5 Readiness Bands & Interpretation

```
90-100  "Ready For Test"       - High confidence, take the test
80-89   "Very Well Prepared"   - Strong preparation, ready soon
70-79   "Well Prepared"        - Good progress, some gaps remain
60-69   "Moderately Prepared"  - Continue focused practice
50-59   "Making Progress"      - Dedicate more study time
40-49   "Early Stage"          - Keep practicing consistently
0-39    "Build Foundation"     - Start with easier questions
```

---

## 2.6 Example Calculation

**User Profile:**
- 150 total practice attempts, 120 correct (80% accuracy)
- 3 mock exams completed: 78%, 81%, 85% (average 81.3%)
- At least 20 practice attempts in each of all 8 active categories
- 3 categories mastered at 80%+ accuracy
- Performance: Easy 90%, Medium 82%, Hard 75%
- Last practice: 2 days ago
- Mock exam trend: +7% improvement

**Calculation:**

```
1. Base Accuracy = 80
2. Mock Exam Score = 81.3
3. Coverage Score = 100% * 0.8 = 80
4. Mastery Bonus = (3/8) * 20 = 7.5
5. Difficulty Score = (90 * 0.2 + 82 * 0.4 + 75 * 0.4) = 81.2
6. Recency Score = 70 (practice within 3 days)
7. Trend Score = 70 (7% improvement across exams)

Raw Score = (80 * 0.25) + (81.3 * 0.30) + ((80 + 7.5) * 0.20) + (81.2 * 0.15) + (70 * 0.05) + (70 * 0.05)
          = 20 + 24.39 + 17.5 + 12.18 + 3.5 + 3.5
          = 81.07

No mock exam penalty (3 exams completed)
Assume recent values practice is 5/5 and the two latest mock exams both meet
the overall and 5/5 values requirements, so no values cap applies.
Final Score = 81 (rounded)

User displays as: "Very Well Prepared" (80-89 band)
```

---

# 3. Weak Area Analysis Algorithm

## 3.1 Purpose

Identifies knowledge gaps and categories where user needs focused practice.

Available to every user.

---

## 3.2 Algorithm

### Step 1: Calculate Per-Category Metrics

For each category:

```
Category Accuracy = (Category Correct / Category Attempts) * 100
Category Attempt Count = Category Attempts
```

Only include categories with >= 5 attempts (minimum sample size).

---

### Step 2: Identify Weak Categories

```
Overall Accuracy (all categories) = Total Correct / Total Attempts

Weakness Threshold = Overall Accuracy - 15 percentage points

Weak Categories = Categories where:
  - Category Accuracy < Weakness Threshold
  - Category has >= 5 attempts
  - Category is "active" (not archived)
```

---

### Step 3: Rank by Severity

```
For each weak category:
  Severity Gap = Weakness Threshold - Category Accuracy
  
  Rank by Severity Gap (largest gap = most severe)
```

---

### Step 4: Identify Frequently Missed Topics

Within each weak category, find most-missed questions:

```
Category Weak Questions = Questions in category where:
  - User attempted the question
  - User answered incorrectly (>= 2 times if attempted multiple times)
  - Question difficulty is "medium" or "hard"
  
Sort by frequency of incorrect attempts
```

---

### Step 5: Generate Weak Area Report

```
Return Top 3 Weak Areas:
1. Category Name (Accuracy: 62%, Target: 77%)
   - Frequently missed topics
   - Recommended focus areas
   
2. Category Name (Accuracy: 68%, Target: 77%)
   - Frequently missed topics
   
3. Category Name (Accuracy: 71%, Target: 77%)
   - Frequently missed topics

If < 3 weak areas found:
  Display all weak areas (may be < 3)

If 0 weak areas found:
  Display: "No weak areas detected. Great work!"
```

---

## 3.3 Update Frequency

Weak area analysis is recalculated:

- After each practice session completes
- After each mock exam completes
- When user views the "Weak Area Analysis" screen

---

# 4. Performance Metrics Aggregation

## 4.1 Overall Statistics

```
Questions Attempted = COUNT(all user_question_attempts)
Correct Answers = COUNT(user_question_attempts WHERE isCorrect = 1)
Incorrect Answers = COUNT(user_question_attempts WHERE isCorrect = 0)
Overall Accuracy = (Correct Answers / Questions Attempted) * 100
```

---

## 4.2 Category Statistics

For each category:

```
Category Accuracy = Category Correct / Category Attempts * 100
Difficulty Breakdown:
  - Easy Accuracy
  - Medium Accuracy
  - Hard Accuracy
  - Recent Activity (last 7 days)
```

---

## 4.3 Mock Exam Statistics

```
Total Exams Completed = COUNT(exam_attempts WHERE isCompleted = 1)
Average Score = AVG(exam_attempts.score)
Pass Rate = COUNT(exam_attempts WHERE isPassed = 1) / COUNT(exam_attempts WHERE isCompleted = 1) * 100
Best Score = MAX(exam_attempts.score)
Worst Score = MIN(exam_attempts.score)
Score Trend = (Latest Score - Oldest Score) / (exam count - 1)
```

---

## 4.4 Update Strategy

Performance metrics are cached in `user_performance_metrics` table.

```
Recalculation Trigger:
- After each practice session ends
- After each exam completes
- Manual refresh from analytics screen

Recalculation Scope:
- Only affected categories are recalculated
- Overall stats are aggregated from individual category stats
```

---

# 5. Recommendation Engine

## 5.1 Purpose

Suggest optimal next study actions to user.

---

## 5.2 Recommendation Logic

### Next Action Recommendations

```
Rule 1: If user has never started a mock exam:
  Recommendation: "Try a mock exam to test your knowledge"
  
Rule 2: If readiness score < 60:
  Recommendation: "Focus on weak areas: [Top 3 categories]"
  
Rule 3: If readiness score >= 80 and user has 3+ exams:
  Recommendation: "You're well prepared! Ready for the official test?"
  
Rule 4: If weak areas exist:
  Recommendation: "Practice [Weakest Category]: Your accuracy is 65%"
  
Rule 5: If coverage < 70% (< 70% of categories practiced):
  Recommendation: "Explore more categories to build comprehensive knowledge"
  
Rule 6: If no practice in 7+ days:
  Recommendation: "Keep your momentum! Continue practicing"
```

---

## 5.3 Display Priority

Recommendations displayed on Home screen in order:

1. Highest priority rule that applies
2. Others in secondary sidebar

---

# 6. Mock Exam Scoring

## 6.1 Score Calculation

```
Score = (Correct Answers / Total Questions) * 100
Score = ROUND(Score, 1)

Examples:
- 17/20 correct = 85.0%
- 15/20 correct = 75.0%
- 14/20 correct = 70.0%
```

---

## 6.2 Pass/Fail Determination

```
Pass Mark is read from exam_configurations table (typically 75%)
Required Australian Values Correct = 5

Overall Requirement Met = Score >= Pass Mark
Values Requirement Met =
  Australian Values Correct == Australian Values Total
  AND Australian Values Total == 5

If Overall Requirement Met AND Values Requirement Met:
  Result = "PASSED"
  Color = Green
  
Else:
  Result = "FAILED"
  Color = Red
```

Examples:

- 15/20 overall and 5/5 Australian values = PASSED
- 19/20 overall and 4/5 Australian values = FAILED
- 14/20 overall and 5/5 Australian values = FAILED
- 14/20 overall and 4/5 Australian values = FAILED

The result model must retain both requirement outcomes so the UI and historical
review can explain why an attempt passed or failed.

---

## 6.3 Category Breakdown

For exam results, calculate per-category performance:

```
For each category in the exam:
  Category Correct = Count of correct answers in this category
  Category Total = Count of questions in this category
  Category Score = (Category Correct / Category Total) * 100
  
Store in exam_history.categoryBreakdown as JSON
```

---

# 7. Algorithmic Considerations

## 7.1 Edge Cases

### Insufficient Data

```
Readiness Score:
- Any active category with < 20 practice attempts: "Not enough data"
- < 1 mock exam: Apply 0.7 penalty to base calculation

Weak Area Analysis:
- Only consider categories with >= 5 attempts
- Show "Keep practicing to see weak areas" if insufficient data

Performance Metrics:
- Division by zero: Check attempt count before calculating accuracy
- NULL values: Treat as 0 in aggregations
```

---

### User With No Mock Exams

```
Mock Exam Score Component = Base Accuracy * 0.5
(Lower weighting due to no real-time performance data)

Display note: "Complete a mock exam for more accurate readiness assessment"
```

---

## 7.2 Performance Optimization

All calculations performed in-memory:

```
1. Load affected rows from SQLite (category attempts, exam scores)
2. Perform calculations in application code
3. Update user_performance_metrics table with results
4. Cache results in memory for display

Avoid:
- Recalculating all users' metrics in one batch
- Complex SQL queries with multiple JOINs for math
- Real-time calculation on every screen load
```

---

## 7.3 Rounding & Precision

```
Accuracy Percentages: 1 decimal place (85.5%)
Readiness Score: Integer (0-100)
Mock Exam Scores: 1 decimal place (81.3%)
Recency Score: Integer (0-100)
Trend Score: Integer (0-100)
```

---

# 8. Testing & Validation

## 8.1 Test Scenarios

### Scenario 1: Brand New User
- 0 attempts
- 0 mock exams
- Expected readiness: "Not enough data"

### Scenario 2: Early Stage User
- 15 practice attempts, 70% accuracy
- 0 mock exams
- Expected readiness: ~35-45 (early stage)

### Scenario 3: Well Prepared User
- 200 practice attempts, 85% accuracy
- 5 mock exams averaging 82%
- 7/8 categories with 5+ attempts
- 5 mastered categories
- Expected readiness: ~78-85 (well prepared)

### Scenario 4: Ready User
- 300+ practice attempts, 88% accuracy
- 6+ mock exams with upward trend
- All 8 categories mastered
- Recent activity within 2 days
- Expected readiness: ~88-95 (ready for test)

---

## 8.2 Algorithmic Validation

```
Readiness Score Range: Always 0-100
Component Validation:
- Base Accuracy: 0-100
- Mock Exam Score: 0-100
- Coverage Score: 0-80
- Mastery Bonus: 0-20
- Difficulty Score: 0-100
- Recency Score: 0-100
- Trend Score: 0-100

After weighting sum: should never exceed 100
```

---
