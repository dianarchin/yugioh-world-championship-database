-- ============================================
-- QUERY OPTIMIZATION EXAMPLES
-- ============================================

-- This file demonstrates query optimization techniques
-- Run EXPLAIN ANALYZE before each query to see performance

-- ============================================
-- Example 1: Using indexes effectively
-- ============================================

-- Create indexes to improve query performance
CREATE INDEX IF NOT EXISTS idx_deck_results_tournament ON deck_results(tournament_id);
CREATE INDEX IF NOT EXISTS idx_deck_results_deck ON deck_results(deck_id);
CREATE INDEX IF NOT EXISTS idx_deck_results_player ON deck_results(player_id);
CREATE INDEX IF NOT EXISTS idx_deck_results_position ON deck_results(finish_position);
CREATE INDEX IF NOT EXISTS idx_deck_cards_deck ON deck_cards(deck_id);
CREATE INDEX IF NOT EXISTS idx_deck_cards_card ON deck_cards(card_id);
CREATE INDEX IF NOT EXISTS idx_tournaments_date ON tournaments(date);
CREATE INDEX IF NOT EXISTS idx_tournaments_era ON tournaments(format_era);
CREATE INDEX IF NOT EXISTS idx_decks_archetype ON decks(archetype);
CREATE INDEX IF NOT EXISTS idx_cards_banned ON cards(is_banned);

-- ============================================
-- Example 2: Subquery vs JOIN optimization
-- ============================================

-- SLOWER: Using subquery
-- EXPLAIN ANALYZE
SELECT 
    d.deck_name,
    (SELECT COUNT(*) 
     FROM deck_results dr 
     WHERE dr.deck_id = d.deck_id AND dr.finish_position = '1st Place') AS wins
FROM decks d;

-- FASTER: Using JOIN and GROUP BY
-- EXPLAIN ANALYZE
SELECT 
    d.deck_name,
    COUNT(CASE WHEN dr.finish_position = '1st Place' THEN 1 END) AS wins
FROM decks d
LEFT JOIN deck_results dr ON d.deck_id = dr.deck_id
GROUP BY d.deck_id, d.deck_name;

-- ============================================
-- Example 3: CTE for readability and optimization
-- ============================================

-- Using CTE for complex analysis
WITH champion_decks AS (
    SELECT 
        dr.deck_id,
        COUNT(*) AS championship_count
    FROM deck_results dr
    WHERE dr.finish_position = '1st Place'
    GROUP BY dr.deck_id
),
deck_composition AS (
    SELECT 
        dc.deck_id,
        COUNT(DISTINCT dc.card_id) AS unique_cards,
        SUM(dc.copies_used) AS total_cards
    FROM deck_cards dc
    GROUP BY dc.deck_id
)
SELECT 
    d.deck_name,
    d.archetype,
    COALESCE(cd.championship_count, 0) AS championships,
    comp.unique_cards,
    comp.total_cards
FROM decks d
LEFT JOIN champion_decks cd ON d.deck_id = cd.deck_id
LEFT JOIN deck_composition comp ON d.deck_id = comp.deck_id
ORDER BY championships DESC;

-- ============================================
-- Example 4: Window functions for rankings
-- ============================================

-- Rank decks by era
SELECT 
    d.deck_name,
    d.format_era,
    COUNT(*) AS appearances,
    RANK() OVER (PARTITION BY d.format_era ORDER BY COUNT(*) DESC) AS era_rank,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS overall_rank
FROM deck_results dr
JOIN decks d ON dr.deck_id = dr.deck_id
GROUP BY d.deck_id, d.deck_name, d.format_era
ORDER BY d.format_era, era_rank;

-- ============================================
-- Example 5: Materialized view for common queries
-- ============================================

-- Create a materialized view for frequently accessed data
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_tournament_summary AS
SELECT 
    t.tournament_id,
    t.name,
    t.date,
    t.format_era,
    t.location,
    COUNT(DISTINCT dr.player_id) AS participating_players,
    COUNT(DISTINCT dr.deck_id) AS unique_decks,
    STRING_AGG(DISTINCT d.archetype, ', ' ORDER BY d.archetype) AS archetypes_present
FROM tournaments t
LEFT JOIN deck_results dr ON t.tournament_id = dr.tournament_id
LEFT JOIN decks d ON dr.deck_id = d.deck_id
GROUP BY t.tournament_id, t.name, t.date, t.format_era, t.location;

-- Refresh the materialized view when data changes
-- REFRESH MATERIALIZED VIEW mv_tournament_summary;

-- Query the materialized view
SELECT * FROM mv_tournament_summary ORDER BY date DESC;
