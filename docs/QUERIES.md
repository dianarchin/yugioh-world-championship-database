# 📚 Query Documentation

Detailed documentation for all SQL queries in this project.

## Table of Contents

1. [Basic Exploration](#basic-exploration)
2. [Regional Analysis](#regional-analysis)
3. [Deck Analysis](#deck-analysis)
4. [Advanced Analysis](#advanced-analysis)
5. [Optimization Examples](#optimization-examples)

---

## Basic Exploration

### Query 1: Tournament Overview
**File**: `queries/01_basic_exploration.sql`

**Purpose**: Get a complete list of all World Championship tournaments.

**Key Techniques**:
- Simple SELECT with ORDER BY
- Date sorting for chronological view

**Use Case**: Understanding the dataset scope and tournament timeline.

---

### Query 2: World Champions
**File**: `queries/01_basic_exploration.sql`

**Purpose**: List all World Champions with their winning decks.

**Key Techniques**:
- Multi-table JOINs (4 tables)
- String concatenation for player names
- Filtering with WHERE clause

**Business Value**: Historical record of championship winners and their strategies.

---

### Query 3: Popular Deck Archetypes
**File**: `queries/01_basic_exploration.sql`

**Purpose**: Identify the most frequently played deck archetypes and their success rate.

**Key Techniques**:
- GROUP BY aggregation
- Conditional counting with CASE WHEN
- Dual metrics (plays vs wins)

**Insights**: Shows which archetypes are most popular and most successful.

---

## Regional Analysis

### Query 1: Championships by Region
**File**: `queries/02_regional_analysis.sql`

**Purpose**: Analyze championship distribution across world regions.

**Key Techniques**:
- Aggregate functions (COUNT)
- Percentage calculations
- Subquery for total calculation
- ROUND for decimal precision

**Business Value**: Reveals geographic dominance patterns in competitive play.

**Expected Results**: Asia typically dominates with 60%+ win rate.

---

### Query 2: Championships by Country
**File**: `queries/02_regional_analysis.sql`

**Purpose**: Detailed country-level championship analysis.

**Key Techniques**:
- STRING_AGG for list aggregation
- DISTINCT to avoid duplicates
- Custom ordering within aggregation

**Insights**: Shows which countries produce the most champions (Japan, USA lead).

---

### Query 3: Regional Dominance by Era
**File**: `queries/02_regional_analysis.sql`

**Purpose**: Track how regional dominance shifted across game eras.

**Key Techniques**:
- Multi-column GROUP BY
- Era-based partitioning
- Historical trend analysis

**Business Value**: Identifies meta shifts and regional competitive trends over time.

---

## Deck Analysis

### Query 1: Deck Win Rates
**File**: `queries/03_deck_analysis.sql`

**Purpose**: Calculate success rates for each competitive deck.

**Key Techniques**:
- Conditional aggregation
- Win rate calculation (wins/total plays)
- HAVING clause for filtering
- ROUND for percentage formatting

**Insights**: Identifies which decks have highest conversion rates to championships.

---

### Query 2: Deck Diversity by Era
**File**: `queries/03_deck_analysis.sql`

**Purpose**: Measure meta diversity across different game eras.

**Key Techniques**:
- COUNT DISTINCT for unique values
- Custom CASE ordering for chronological sort
- Era-based grouping

**Business Value**: Shows whether the competitive meta is diverse or centralized.

---

### Query 3: Most Used Cards
**File**: `queries/03_deck_analysis.sql`

**Purpose**: Identify staple cards used across many decks.

**Key Techniques**:
- Multi-metric aggregation (decks using, total copies)
- Dual sorting criteria
- LIMIT for top results

**Expected Results**: Generic staples like "Mystical Space Typhoon" rank highest.

---

## Advanced Analysis

### Query 1: Player Consistency
**File**: `queries/04_advanced_analysis.sql`

**Purpose**: Identify players with sustained competitive success.

**Key Techniques**:
- Multiple conditional aggregations
- STRING_AGG for deck variety
- Complex HAVING filters
- Multi-column sorting

**Business Value**: Highlights elite players who consistently perform well.

---

### Query 2: Meta Shifts Over Time
**File**: `queries/04_advanced_analysis.sql`

**Purpose**: Visualize how winning strategies evolved year by year.

**Key Techniques**:
- Common Table Expression (CTE)
- EXTRACT for date parsing
- String aggregation for summary
- Temporal analysis

**Insights**: Shows clear meta shifts between eras (e.g., Chaos → Synchro → Xyz).

---

### Query 3: Championship Card Analysis
**File**: `queries/04_advanced_analysis.sql`

**Purpose**: Identify cards that appear most in winning decks.

**Key Techniques**:
- Three-table JOIN
- Position-based filtering
- Distinct counting
- Ban status tracking

**Business Value**: Reveals which cards correlate with tournament success.

---

## Optimization Examples

### Index Strategy
**File**: `queries/05_optimization_examples.sql`

**Purpose**: Demonstrate proper index creation for common access patterns.

**Techniques**:
- Foreign key indexes
- Filter condition indexes
- Date-based indexes

**Impact**: 10-100x query speed improvement on large datasets.

---

### Subquery vs JOIN
**File**: `queries/05_optimization_examples.sql`

**Purpose**: Compare performance of different query patterns.

**Key Learning**: 
- Subqueries: Easier to read, can be slower
- JOINs with GROUP BY: More complex, typically faster

**Recommendation**: Use EXPLAIN ANALYZE to measure actual performance.

---

### Common Table Expressions (CTEs)
**File**: `queries/05_optimization_examples.sql`

**Purpose**: Improve query readability and maintainability.

**Benefits**:
- Break complex queries into logical steps
- Reuse intermediate results
- Better debugging and testing

---

### Window Functions
**File**: `queries/05_optimization_examples.sql`

**Purpose**: Perform ranking and partitioned analysis.

**Key Techniques**:
- RANK() and DENSE_RANK()
- PARTITION BY for grouped ranking
- ORDER BY within windows

**Use Case**: Rank decks within their era while maintaining all rows.

---

### Materialized Views
**File**: `queries/05_optimization_examples.sql`

**Purpose**: Cache expensive query results for frequently accessed data.

**Benefits**:
- Instant query response (pre-computed)
- Reduced server load
- Must be refreshed when data changes

**Best For**: Reports, dashboards, read-heavy applications.

---

## Query Performance Tips

1. **Use EXPLAIN ANALYZE**: Always measure before optimizing
2. **Index Foreign Keys**: Essential for JOIN performance
3. **Limit Result Sets**: Use LIMIT when appropriate
4. **Avoid SELECT ***: Specify only needed columns
5. **Use Appropriate Data Types**: Impacts storage and comparison speed
6. **Consider Materialized Views**: For complex, frequently-run queries

## Common Patterns

### Conditional Counting
```sql
COUNT(CASE WHEN condition THEN 1 END) AS metric_name
```

### Percentage Calculation
```sql
ROUND(COUNT(*) * 100.0 / total, 2) AS percentage
```

### String Aggregation
```sql
STRING_AGG(column_name, ', ' ORDER BY column_name) AS list
```

### Window Ranking
```sql
RANK() OVER (PARTITION BY category ORDER BY value DESC) AS rank
```
