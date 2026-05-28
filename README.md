# 🎴 Yu-Gi-Oh! Championship Database

A comprehensive PostgreSQL database analyzing Yu-Gi-Oh! World Championship data from 2004 to 2025. This project demonstrates advanced SQL querying, database design, and data analysis techniques.

## 📊 Project Overview

This database tracks:
- **18 World Championships** spanning 21 years (2004-2025)
- **36 professional players** from 5 continents
- **26 competitive deck archetypes** across 7 game eras
- **72 iconic cards** including banned cards
- **84 tournament results** with detailed placement data
- **142 deck composition records**

## 🎯 Key Features

✨ **Well-Designed Schema**
- Normalized database structure with proper foreign key relationships
- Junction tables for many-to-many relationships
- Indexes optimized for common query patterns

📈 **Comprehensive Analysis**
- Regional dominance patterns
- Deck archetype evolution across eras
- Card usage statistics
- Player performance metrics
- Meta shifts over time

🚀 **Production-Ready Setup**
- Docker Compose for easy deployment
- Automated data loading
- PgAdmin web interface for visual database management
- Python verification scripts

## 🏗️ Database Schema

### Entity Relationship Diagram

```
┌─────────────┐         ┌──────────────┐         ┌─────────┐
│ tournaments │         │ deck_results │         │ players │
├─────────────┤         ├──────────────┤         ├─────────┤
│ tournament_id◄────────┤tournament_id │         │player_id│
│ name        │         │ deck_id      │         │first_name│
│ location    │         │ player_id    ├────────►│last_name│
│ date        │         │ final_record │         │ country │
│ format_era  │         │finish_position│        │ region  │
└─────────────┘         └──────────────┘         └─────────┘
                              │      ▲
                              │      │
                              ▼      │
                        ┌─────────┐  │
                        │  decks  │  │
                        ├─────────┤  │
                        │ deck_id ├──┘
                        │deck_name│
                        │archetype│
                        │  tier   │
                        └────┬────┘
                             │
                             │
                        ┌────▼──────┐
                        │deck_cards │
                        ├───────────┤
                        │ deck_id   │
                        │ card_id   ├──┐
                        │copies_used│  │
                        └───────────┘  │
                                       │
                                  ┌────▼────┐
                                  │  cards  │
                                  ├─────────┤
                                  │ card_id │
                                  │card_name│
                                  │card_type│
                                  │is_banned│
                                  └─────────┘
```

### Tables

1. **tournaments** - World Championship events
2. **players** - Professional Yu-Gi-Oh! players
3. **decks** - Competitive deck archetypes
4. **cards** - Individual Yu-Gi-Oh! cards
5. **deck_results** - Tournament placements (junction: tournaments + decks + players)
6. **deck_cards** - Deck composition (junction: decks + cards)

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- (Optional) Python 3.8+ for verification scripts
- (Optional) PostgreSQL client for command-line access

### Installation

1. **Clone or download this repository**

2. **Run the setup script**
   ```bash
   ./scripts/setup.sh
   ```

   This will:
   - Start PostgreSQL container
   - Start PgAdmin container
   - Automatically load the dataset
   - Verify the database is ready

3. **Access the database**

   **Option A: pgAdmin Web Interface**
   - Open browser to `http://localhost:5050`
   - Login: `admin@yugioh.com` / `admin`
   - Add server connection:
     - Host: `postgres`
     - Port: `5432`
     - Database: `yugioh_championships`
     - Username: `yugioh_user`
     - Password: `yugioh_pass`

   **Option B: Command Line**
   ```bash
   ./scripts/connect.sh
   ```

   **Option C: Your favorite SQL client**
   - Host: `localhost`
   - Port: `5432`
   - Database: `yugioh_championships`
   - Username: `yugioh_user`
   - Password: `yugioh_pass`

4. **Verify the data** (optional)
   ```bash
   python3 scripts/verify_data.py
   ```

## 📚 Sample Queries

The `queries/` directory contains organized SQL files demonstrating various analysis techniques:

### Basic Exploration (`01_basic_exploration.sql`)
- Tournament overview
- World Champions list
- Popular deck archetypes
- Banned cards

### Regional Analysis (`02_regional_analysis.sql`)
- Championships by region and country
- Regional dominance by era
- Top 4 finishes distribution

### Deck Analysis (`03_deck_analysis.sql`)
- Most successful decks
- Deck diversity across eras
- Card usage patterns
- Tier 1 deck performance

### Advanced Analysis (`04_advanced_analysis.sql`)
- Player consistency metrics
- Meta shifts over time
- Card power analysis
- Tournament competitiveness

### Optimization Examples (`05_optimization_examples.sql`)
- Index creation strategies
- Subquery vs JOIN optimization
- Common Table Expressions (CTEs)
- Window functions
- Materialized views

## 🔍 Example Queries

### World Champions by Era
```sql
SELECT
    p.first_name || ' ' || p.last_name AS champion,
    p.country,
    t.name AS tournament,
    t.format_era,
    d.deck_name
FROM deck_results dr
JOIN tournaments t ON dr.tournament_id = t.tournament_id
JOIN players p ON dr.player_id = p.player_id
JOIN decks d ON dr.deck_id = d.deck_id
WHERE dr.finish_position = '1st Place'
ORDER BY t.date;
```

### Regional Dominance
```sql
SELECT
    p.region,
    COUNT(*) AS championships_won,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM deck_results WHERE finish_position = '1st Place'), 2) AS win_percentage
FROM deck_results dr
JOIN players p ON dr.player_id = p.player_id
WHERE dr.finish_position = '1st Place'
GROUP BY p.region
ORDER BY championships_won DESC;
```

### Most Used Cards
```sql
SELECT
    c.card_name,
    c.card_type,
    COUNT(DISTINCT dc.deck_id) AS decks_using,
    SUM(dc.copies_used) AS total_copies
FROM deck_cards dc
JOIN cards c ON dc.card_id = c.card_id
GROUP BY c.card_name, c.card_type
ORDER BY decks_using DESC
LIMIT 10;
```

## 📁 Project Structure

```
yugioh-championship-database/
├── data/
│   └── yugioh_dataset.sql          # Complete dataset with schema + data
├── queries/
│   ├── 01_basic_exploration.sql    # Basic queries
│   ├── 02_regional_analysis.sql    # Regional insights
│   ├── 03_deck_analysis.sql        # Deck performance
│   ├── 04_advanced_analysis.sql    # Complex analysis
│   └── 05_optimization_examples.sql # Performance optimization
├── scripts/
│   ├── setup.sh                    # Automated setup
│   ├── connect.sh                  # Database connection helper
│   └── verify_data.py              # Data verification script
├── docs/
│   └── QUERIES.md                  # Query documentation
├── docker-compose.yml              # Docker configuration
├── .env.example                    # Environment variables template
├── .gitignore                      # Git ignore rules
└── README.md                       # This file
```

## 🎓 Learning Highlights

This project demonstrates:

- **Database Design**: Normalized schema with proper relationships
- **SQL Proficiency**: Complex JOINs, CTEs, window functions, aggregations
- **Performance Optimization**: Indexes, query optimization, materialized views
- **Data Analysis**: Regional trends, meta analysis, player statistics
- **DevOps**: Docker containerization, automated setup scripts
- **Documentation**: Clear README, well-commented SQL queries

## 📊 Key Insights

From analyzing the data:

1. **Asian Dominance**: Asia has won 67% of World Championships
2. **Meta Evolution**: Each era has distinct dominant archetypes
3. **Mystical Space Typhoon**: Most played card across all eras
4. **Regional Diversity**: 11+ countries represented in Top 4 finishes
5. **Deck Innovation**: Average of 3.7 unique archetypes per era

## 🛠️ Technologies Used

- **PostgreSQL 16** - Relational database
- **Docker & Docker Compose** - Containerization
- **pgAdmin 4** - Database management interface
- **Python 3** - Data verification scripts
- **Bash** - Automation scripts
- **Tableau** - Data visualization [view here for the completed dashboard](https://public.tableau.com/app/profile/diana.chin4010/viz/YuGiOhWorldChampionshipStats/Yu-Gi-OhWorldChampionshipDashboard)

## 🔮 Future Enhancements

Potential additions to this project:

- [ ] Web dashboard with visualizations (Flask/Django + Chart.js)
- [ ] Jupyter notebook with data analysis
- [ ] REST API for database access
- [ ] Additional datasets (regional tournaments, ban list history)
- [ ] Machine learning predictions for meta trends
- [ ] GraphQL endpoint

## 📝 License

This project is for educational and portfolio purposes.
Yu-Gi-Oh! is a trademark of Konami Digital Entertainment.

## 🤝 Contributing

Feel free to fork this project and add your own queries or analysis!

## 📧 Contact

Created as a portfolio project to demonstrate SQL and database design skills.

---

**⭐ If you found this project helpful, please give it a star!**

