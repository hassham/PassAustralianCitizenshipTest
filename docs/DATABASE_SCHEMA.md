# Database Schema

## Pass Australian Citizenship Test

### SQLite Schema Specification

**Version:** 2.0

**Last Updated:** 2026-07-20

---

# 1. Purpose

This document defines the complete SQLite database schema for the Pass Australian Citizenship Test application.

All tables, columns, data types, constraints, and relationships are specified here.

---

# 2. Design Principles

- Normalized schema to eliminate redundancy
- Support for future content updates and migrations
- Efficient querying for common operations
- Support for audit trail (versioning)
- No sensitive user data stored
- All timestamps use UTC milliseconds since epoch

---

# 3. Database Initialization

On first app launch:

1. SQLite database is created
2. All tables are created
3. JSON assets are imported into relevant tables
4. Question content is loaded into the database
5. Exam configuration is loaded

---

# 4. Core Tables

## 4.1 `categories`

Stores all question categories.

```sql
CREATE TABLE categories (
  categoryId INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  displayOrder INTEGER NOT NULL,
  isActive BOOLEAN NOT NULL DEFAULT 1,
  createdAt INTEGER NOT NULL,
  updatedAt INTEGER NOT NULL
);
```

**Indexes:**
- `CREATE INDEX idx_categories_active ON categories(isActive)`
- `CREATE INDEX idx_categories_displayOrder ON categories(displayOrder)`

**Example Data:**
```
Australian History
Government Structure
National Symbols
Rights and Responsibilities
Citizenship Pledge
Australian Values
Laws and Systems
```

---

## 4.2 `questions`

Stores all practice and exam questions.

```sql
CREATE TABLE questions (
  questionId INTEGER PRIMARY KEY AUTOINCREMENT,
  categoryId INTEGER NOT NULL,
  questionText TEXT NOT NULL,
  difficulty TEXT NOT NULL, -- 'easy', 'medium', 'hard'
  questionVersion INTEGER NOT NULL DEFAULT 1,
  status TEXT NOT NULL DEFAULT 'active', -- 'active', 'archived', 'deprecated'
  createdAt INTEGER NOT NULL,
  updatedAt INTEGER NOT NULL,
  FOREIGN KEY (categoryId) REFERENCES categories(categoryId)
);
```

**Constraints:**
- `difficulty` must be one of: 'easy', 'medium', 'hard'
- `status` must be one of: 'active', 'archived', 'deprecated'

**Indexes:**
- `CREATE INDEX idx_questions_categoryId ON questions(categoryId)`
- `CREATE INDEX idx_questions_status ON questions(status)`
- `CREATE INDEX idx_questions_difficulty ON questions(difficulty)`
- `CREATE INDEX idx_questions_active ON questions(status) WHERE status = 'active'`

---

## 4.3 `question_options`

Stores answer options for each question (4 per question).

```sql
CREATE TABLE question_options (
  optionId INTEGER PRIMARY KEY AUTOINCREMENT,
  questionId INTEGER NOT NULL,
  optionText TEXT NOT NULL,
  displayOrder INTEGER NOT NULL, -- 1, 2, 3, 4
  isCorrect BOOLEAN NOT NULL,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (questionId) REFERENCES questions(questionId) ON DELETE CASCADE
);
```

**Constraints:**
- Exactly 4 options per question (validated in application logic)
- Exactly 1 correct answer per question (validated in application logic)
- `displayOrder` must be 1-4

**Indexes:**
- `CREATE INDEX idx_question_options_questionId ON question_options(questionId)`
- `CREATE INDEX idx_question_options_correct ON question_options(isCorrect)`

---

## 4.4 `question_explanations`

Stores detailed explanations for each question.

```sql
CREATE TABLE question_explanations (
  explanationId INTEGER PRIMARY KEY AUTOINCREMENT,
  questionId INTEGER NOT NULL UNIQUE,
  correctExplanation TEXT NOT NULL, -- Why the correct answer is correct
  incorrectExplanations TEXT NOT NULL, -- JSON array of explanations for each incorrect option
  createdAt INTEGER NOT NULL,
  updatedAt INTEGER NOT NULL,
  FOREIGN KEY (questionId) REFERENCES questions(questionId) ON DELETE CASCADE
);
```

**Format for `incorrectExplanations`:**
```json
[
  "Why option 1 is incorrect",
  "Why option 2 is incorrect",
  "Why option 3 is incorrect"
]
```

(Note: Only 3 entries, for the three incorrect options)

**Indexes:**
- `CREATE INDEX idx_explanations_questionId ON question_explanations(questionId)`

---

## 4.5 `question_references`

Stores official source references for each question.

```sql
CREATE TABLE question_references (
  referenceId INTEGER PRIMARY KEY AUTOINCREMENT,
  questionId INTEGER NOT NULL UNIQUE,
  bookTitle TEXT NOT NULL, -- "Our Common Bond"
  chapter TEXT,
  section TEXT,
  page INTEGER,
  externalUrl TEXT,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (questionId) REFERENCES questions(questionId) ON DELETE CASCADE
);
```

**Indexes:**
- `CREATE INDEX idx_references_questionId ON question_references(questionId)`

---

# 5. User Progress Tables

## 5.1 `user_question_attempts`

Tracks every user attempt at a question.

```sql
CREATE TABLE user_question_attempts (
  attemptId INTEGER PRIMARY KEY AUTOINCREMENT,
  questionId INTEGER NOT NULL,
  selectedOptionId INTEGER NOT NULL,
  isCorrect BOOLEAN NOT NULL,
  timeTakenSeconds INTEGER, -- Time spent on this question
  attemptedAt INTEGER NOT NULL, -- UTC timestamp
  sessionId TEXT NOT NULL, -- Links to practice or exam session
  FOREIGN KEY (questionId) REFERENCES questions(questionId),
  FOREIGN KEY (selectedOptionId) REFERENCES question_options(optionId)
);
```

**Indexes:**
- `CREATE INDEX idx_attempts_questionId ON user_question_attempts(questionId)`
- `CREATE INDEX idx_attempts_isCorrect ON user_question_attempts(isCorrect)`
- `CREATE INDEX idx_attempts_sessionId ON user_question_attempts(sessionId)`
- `CREATE INDEX idx_attempts_attemptedAt ON user_question_attempts(attemptedAt DESC)`

---

## 5.2 `user_starred_questions`

Tracks questions starred by the user for revision.

```sql
CREATE TABLE user_starred_questions (
  starId INTEGER PRIMARY KEY AUTOINCREMENT,
  questionId INTEGER NOT NULL UNIQUE,
  starredAt INTEGER NOT NULL, -- UTC timestamp
  unstarredAt INTEGER, -- NULL if currently starred
  isActive BOOLEAN NOT NULL DEFAULT 1,
  FOREIGN KEY (questionId) REFERENCES questions(questionId) ON DELETE CASCADE
);
```

**Indexes:**
- `CREATE INDEX idx_starred_questionId ON user_starred_questions(questionId)`
- `CREATE INDEX idx_starred_active ON user_starred_questions(isActive)`

---

## 5.3 `user_practice_sessions`

Tracks practice sessions (ongoing or completed).

```sql
CREATE TABLE user_practice_sessions (
  sessionId TEXT PRIMARY KEY, -- UUID
  sessionType TEXT NOT NULL, -- 'practice', 'category_practice', 'starred_practice'
  selectedCategories TEXT NOT NULL, -- JSON array of categoryIds
  totalQuestions INTEGER NOT NULL,
  questionsAttempted INTEGER NOT NULL DEFAULT 0,
  correctAnswers INTEGER NOT NULL DEFAULT 0,
  currentQuestionIndex INTEGER NOT NULL DEFAULT 0,
  currentQuestionId INTEGER, -- NULL if session not started
  isCompleted BOOLEAN NOT NULL DEFAULT 0,
  startedAt INTEGER NOT NULL,
  completedAt INTEGER, -- NULL if ongoing
  FOREIGN KEY (currentQuestionId) REFERENCES questions(questionId)
);
```

**Format for `selectedCategories`:**
```json
[1, 3, 5] -- Array of categoryIds
```

**Indexes:**
- `CREATE INDEX idx_sessions_sessionType ON user_practice_sessions(sessionType)`
- `CREATE INDEX idx_sessions_isCompleted ON user_practice_sessions(isCompleted)`
- `CREATE INDEX idx_sessions_startedAt ON user_practice_sessions(startedAt DESC)`

---

# 6. Mock Exam Tables

## 6.1 `exam_configurations`

Stores exam rule configurations (loaded from JSON assets).

```sql
CREATE TABLE exam_configurations (
  configId INTEGER PRIMARY KEY AUTOINCREMENT,
  examName TEXT NOT NULL UNIQUE,
  questionCount INTEGER NOT NULL,
  durationMinutes INTEGER NOT NULL,
  passMark REAL NOT NULL, -- e.g., 75.0
  isActive BOOLEAN NOT NULL DEFAULT 1,
  version INTEGER NOT NULL DEFAULT 1,
  createdAt INTEGER NOT NULL,
  updatedAt INTEGER NOT NULL
);
```

**Example:**
```
examName: "Australian Citizenship Test"
questionCount: 20
durationMinutes: 45
passMark: 75.0
```

**Indexes:**
- `CREATE INDEX idx_exam_config_active ON exam_configurations(isActive)`

---

## 6.2 `exam_attempts`

Tracks each mock exam attempt by the user.

```sql
CREATE TABLE exam_attempts (
  examAttemptId INTEGER PRIMARY KEY AUTOINCREMENT,
  configId INTEGER NOT NULL,
  attemptNumber INTEGER NOT NULL, -- 1st attempt, 2nd attempt, etc.
  selectedQuestions TEXT NOT NULL, -- JSON array of questionIds in exam order
  totalQuestions INTEGER NOT NULL,
  questionsAnswered INTEGER NOT NULL DEFAULT 0,
  currentQuestionIndex INTEGER NOT NULL DEFAULT 0,
  currentQuestionId INTEGER,
  score REAL, -- NULL if not completed
  isPassed BOOLEAN, -- NULL if not completed
  timeTakenSeconds INTEGER, -- NULL if not completed
  startedAt INTEGER NOT NULL,
  submittedAt INTEGER, -- NULL if not completed
  isPremiumTimed BOOLEAN NOT NULL DEFAULT 0,
  remainingTimeSeconds INTEGER, -- For timed exams
  backgroundedAt INTEGER, -- Timestamp when app was backgrounded
  isCompleted BOOLEAN NOT NULL DEFAULT 0,
  FOREIGN KEY (configId) REFERENCES exam_configurations(configId),
  FOREIGN KEY (currentQuestionId) REFERENCES questions(questionId)
);
```

**Format for `selectedQuestions`:**
```json
[5, 12, 3, 45, 22] -- Ordered array of questionIds
```

**Indexes:**
- `CREATE INDEX idx_exam_attempts_configId ON exam_attempts(configId)`
- `CREATE INDEX idx_exam_attempts_isCompleted ON exam_attempts(isCompleted)`
- `CREATE INDEX idx_exam_attempts_isPassed ON exam_attempts(isPassed)`
- `CREATE INDEX idx_exam_attempts_startedAt ON exam_attempts(startedAt DESC)`

---

## 6.3 `exam_attempt_answers`

Stores answers for each question in an exam attempt.

```sql
CREATE TABLE exam_attempt_answers (
  answerId INTEGER PRIMARY KEY AUTOINCREMENT,
  examAttemptId INTEGER NOT NULL,
  questionId INTEGER NOT NULL,
  questionOrder INTEGER NOT NULL, -- Position in exam (1-20)
  selectedOptionId INTEGER, -- NULL if unanswered
  isCorrect BOOLEAN, -- NULL if unanswered
  timeTakenSeconds INTEGER, -- Time spent on this question
  answeredAt INTEGER, -- When the answer was submitted
  FOREIGN KEY (examAttemptId) REFERENCES exam_attempts(examAttemptId) ON DELETE CASCADE,
  FOREIGN KEY (questionId) REFERENCES questions(questionId),
  FOREIGN KEY (selectedOptionId) REFERENCES question_options(optionId)
);
```

**Indexes:**
- `CREATE INDEX idx_exam_answers_examAttemptId ON exam_attempt_answers(examAttemptId)`
- `CREATE INDEX idx_exam_answers_questionId ON exam_attempt_answers(questionId)`
- `CREATE INDEX idx_exam_answers_isCorrect ON exam_attempt_answers(isCorrect)`

---

# 7. Analytics Tables

## 7.1 `user_performance_metrics`

Aggregated performance metrics (recalculated after each session/exam).

```sql
CREATE TABLE user_performance_metrics (
  metricId INTEGER PRIMARY KEY AUTOINCREMENT,
  categoryId INTEGER NOT NULL,
  totalAttempts INTEGER NOT NULL DEFAULT 0,
  correctAnswers INTEGER NOT NULL DEFAULT 0,
  incorrectAnswers INTEGER NOT NULL DEFAULT 0,
  accuracy REAL NOT NULL DEFAULT 0.0, -- correctAnswers / totalAttempts * 100
  easyAttempts INTEGER NOT NULL DEFAULT 0,
  easyCorrect INTEGER NOT NULL DEFAULT 0,
  mediumAttempts INTEGER NOT NULL DEFAULT 0,
  mediumCorrect INTEGER NOT NULL DEFAULT 0,
  hardAttempts INTEGER NOT NULL DEFAULT 0,
  hardCorrect INTEGER NOT NULL DEFAULT 0,
  lastAttemptedAt INTEGER,
  updatedAt INTEGER NOT NULL,
  FOREIGN KEY (categoryId) REFERENCES categories(categoryId) ON DELETE CASCADE
);
```

**Indexes:**
- `CREATE INDEX idx_metrics_categoryId ON user_performance_metrics(categoryId)`
- `CREATE INDEX idx_metrics_accuracy ON user_performance_metrics(accuracy DESC)`

---

## 7.2 `exam_history`

Stores historical exam results for premium users.

```sql
CREATE TABLE exam_history (
  historyId INTEGER PRIMARY KEY AUTOINCREMENT,
  examAttemptId INTEGER NOT NULL UNIQUE,
  configId INTEGER NOT NULL,
  score REAL NOT NULL,
  isPassed BOOLEAN NOT NULL,
  categoryBreakdown TEXT NOT NULL, -- JSON object with category scores
  correctCount INTEGER NOT NULL,
  incorrectCount INTEGER NOT NULL,
  unansweredCount INTEGER NOT NULL,
  timeTakenSeconds INTEGER NOT NULL,
  readinessScore REAL, -- Calculated at time of exam
  attemptNumber INTEGER NOT NULL,
  completedAt INTEGER NOT NULL,
  FOREIGN KEY (examAttemptId) REFERENCES exam_attempts(examAttemptId) ON DELETE CASCADE,
  FOREIGN KEY (configId) REFERENCES exam_configurations(configId)
);
```

**Format for `categoryBreakdown`:**
```json
{
  "1": {"categoryName": "Australian History", "score": 85.0, "correct": 5, "total": 6},
  "3": {"categoryName": "Government Structure", "score": 80.0, "correct": 4, "total": 5}
}
```

**Indexes:**
- `CREATE INDEX idx_history_examAttemptId ON exam_history(examAttemptId)`
- `CREATE INDEX idx_history_completedAt ON exam_history(completedAt DESC)`
- `CREATE INDEX idx_history_isPassed ON exam_history(isPassed)`

---

# 8. Premium & Settings Tables

## 8.1 `premium_entitlements`

Tracks premium purchase status.

```sql
CREATE TABLE premium_entitlements (
  entitlementId INTEGER PRIMARY KEY AUTOINCREMENT,
  purchaseToken TEXT NOT NULL UNIQUE, -- From Apple/Google
  platform TEXT NOT NULL, -- 'ios', 'android'
  purchaseId TEXT NOT NULL,
  purchaseDate INTEGER NOT NULL,
  expiryDate INTEGER, -- NULL for lifetime purchases
  isActive BOOLEAN NOT NULL DEFAULT 1,
  verificationData TEXT, -- Raw verification response (optional for MVP)
  createdAt INTEGER NOT NULL,
  updatedAt INTEGER NOT NULL
);
```

**Indexes:**
- `CREATE INDEX idx_entitlements_isActive ON premium_entitlements(isActive)`
- `CREATE INDEX idx_entitlements_platform ON premium_entitlements(platform)`

---

## 8.2 `app_settings`

Stores application-level settings and configuration.

```sql
CREATE TABLE app_settings (
  settingId INTEGER PRIMARY KEY AUTOINCREMENT,
  settingKey TEXT NOT NULL UNIQUE,
  settingValue TEXT NOT NULL,
  dataType TEXT NOT NULL, -- 'string', 'integer', 'boolean', 'json'
  updatedAt INTEGER NOT NULL
);
```

**Example Settings:**
```
app_version: "1.0.0"
last_content_update: "2026-07-20"
user_preferred_difficulty: "medium"
notification_enabled: true
notification_time: "09:00"
language: "en"
exam_config_version: "1.0"
database_version: "1.0"
```

**Indexes:**
- `CREATE INDEX idx_settings_key ON app_settings(settingKey)`

---

## 8.3 `user_preferences`

Stores user preference settings.

```sql
CREATE TABLE user_preferences (
  preferenceId INTEGER PRIMARY KEY AUTOINCREMENT,
  preferenceKey TEXT NOT NULL UNIQUE,
  preferenceValue TEXT NOT NULL,
  dataType TEXT NOT NULL, -- 'string', 'integer', 'boolean', 'json'
  updatedAt INTEGER NOT NULL
);
```

**Example Preferences:**
```
display_difficulty_badges: true
show_explanations_immediately: true
theme: "light" -- or "dark"
preferred_question_order: "random" -- or "sequential"
auto_mark_for_review: true
show_readiness_score_tip: true
```

**Indexes:**
- `CREATE INDEX idx_preferences_key ON user_preferences(preferenceKey)`

---

# 9. Content Versioning & Migration Tables

## 9.1 `content_versions`

Tracks content versions for future migration support.

```sql
CREATE TABLE content_versions (
  versionId INTEGER PRIMARY KEY AUTOINCREMENT,
  versionNumber TEXT NOT NULL UNIQUE, -- "1.0", "1.1", etc.
  releaseDate INTEGER NOT NULL,
  questionCountAdded INTEGER,
  questionCountRemoved INTEGER,
  questionCountModified INTEGER,
  migrationScript TEXT, -- Path or identifier of migration script
  isApplied BOOLEAN NOT NULL DEFAULT 0,
  appliedAt INTEGER,
  notes TEXT
);
```

**Indexes:**
- `CREATE INDEX idx_versions_isApplied ON content_versions(isApplied)`

---

# 10. Migration & Integrity Views

## 10.1 Statistics View

```sql
CREATE VIEW v_user_statistics AS
SELECT
  (SELECT COUNT(*) FROM user_question_attempts WHERE isCorrect = 1) AS total_correct,
  (SELECT COUNT(*) FROM user_question_attempts) AS total_attempts,
  CASE 
    WHEN (SELECT COUNT(*) FROM user_question_attempts) > 0
    THEN ROUND(
      (SELECT COUNT(*) FROM user_question_attempts WHERE isCorrect = 1) * 100.0 / 
      (SELECT COUNT(*) FROM user_question_attempts), 
      2
    )
    ELSE 0
  END AS overall_accuracy
;
```

---

## 10.2 Active Content View

```sql
CREATE VIEW v_active_questions AS
SELECT 
  q.questionId,
  q.questionText,
  c.name as categoryName,
  q.difficulty,
  COUNT(qo.optionId) as optionCount
FROM questions q
JOIN categories c ON q.categoryId = c.categoryId
LEFT JOIN question_options qo ON q.questionId = qo.questionId
WHERE q.status = 'active' AND c.isActive = 1
GROUP BY q.questionId
;
```

---

# 11. Constraints & Integrity

## Data Integrity Rules

1. **Referential Integrity:** All foreign keys enforced with `ON DELETE CASCADE` where appropriate
2. **Question Validation:** 
   - Each active question must have exactly 4 options
   - Each question must have exactly 1 correct option
   - Each question must have an explanation
   - Each question must have a reference
3. **Option Validation:**
   - Display order must be sequential (1-4)
4. **Exam Validation:**
   - Pass mark must be between 0-100
   - Question count must be > 0
   - Duration must be > 0

---

# 12. Performance Optimization

## Recommended Indexes Summary

All indexes specified above should be created on database initialization.

Critical indexes for query performance:
- `questions(status, categoryId)` - Most common query
- `user_question_attempts(sessionId, attemptedAt)` - Session replay
- `exam_attempts(startedAt DESC)` - Recent exams
- `user_performance_metrics(categoryId, accuracy DESC)` - Analytics

---

# 13. Backup & Export

For future features:

- Export exam history as JSON
- Export performance metrics as CSV
- Backup database on cloud when backend is introduced
- User data export (GDPR compliance) in future

---

# 14. Migration Path

Future releases may introduce:

- User accounts and cloud sync
- Server-side analytics
- Social features
- Additional question banks

Current schema supports these future expansions without major restructuring.

---
