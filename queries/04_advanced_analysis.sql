-- ============================================
-- ADVANCED ANALYSIS QUERIES
-- ============================================

-- Query 1: Player consistency - Players with multiple top finishes
SELECT 
    p.first_name || ' ' || p.last_name AS player_name,
    p.country,
    COUNT(*) AS tournament_appearances,
    COUNT(CASE WHEN dr.finish_position = '1st Place' THEN 1 END) AS championships,
    COUNT(CASE WHEN dr.finish_position IN ('1st Place', 'Runner-Up', 'Top 4') THEN 1 END) AS top_4_finishes,
    STRING_AGG(DISTINCT d.archetype, ', ' ORDER BY d.archetype) AS archetypes_played
FROM deck_results dr
JOIN players p ON dr.player_id = p.player_id
JOIN decks d ON dr.deck_id = d.deck_id
GROUP BY p.player_id, p.first_name, p.last_name, p.country
HAVING COUNT(*) > 1
ORDER BY championships DESC, top_4_finishes DESC;

-- Query 2: Meta shifts - Winning decks by year
WITH yearly_winners AS (
    SELECT 
        EXTRACT(YEAR FROM t.date) AS year,
        d.deck_name,
        d.archetype,
        t.format_era
    FROM deck_results dr
    JOIN tournaments t ON dr.tournament_id = t.tournament_id
    JOIN decks d ON dr.deck_id = d.deck_id
    WHERE dr.finish_position = '1st Place'
)
SELECT 
    year,
    format_era,
    STRING_AGG(deck_name, ', ' ORDER BY deck_name) AS winning_decks,
    STRING_AGG(DISTINCT archetype, ', ' ORDER BY archetype) AS archetypes
FROM yearly_winners
GROUP BY year, format_era
ORDER BY year;

-- Query 3: Card power analysis - Cards in championship decks
SELECT 
    c.card_name,
    c.card_type,
    c.archetype_tag,
    c.is_banned,
    COUNT(DISTINCT dr.result_id) AS championship_deck_appearances
FROM deck_cards dc
JOIN cards c ON dc.card_id = c.card_id
JOIN deck_results dr ON dc.deck_id = dr.deck_id
WHERE dr.finish_position = '1st Place'
GROUP BY c.card_id, c.card_name, c.card_type, c.archetype_tag, c.is_banned
ORDER BY championship_deck_appearances DESC
LIMIT 20;

-- Query 4: Tournament competitiveness - Average finish position by deck
SELECT 
    d.deck_name,
    d.archetype,
    COUNT(*) AS appearances,
    COUNT(CASE WHEN dr.finish_position = '1st Place' THEN 1 END) AS wins,
    COUNT(CASE WHEN dr.finish_position LIKE 'Top 4%' OR dr.finish_position = 'Runner-Up' THEN 1 END) AS top_4,
    COUNT(CASE WHEN dr.finish_position LIKE 'Top 8%' THEN 1 END) AS top_8,
    ROUND(
        COUNT(CASE WHEN dr.finish_position = '1st Place' THEN 1 END) * 100.0 / COUNT(*), 
        2
    ) AS conversion_rate
FROM deck_results dr
JOIN decks d ON dr.deck_id = d.deck_id
GROUP BY d.deck_name, d.archetype
HAVING COUNT(*) >= 3
ORDER BY conversion_rate DESC;

-- Query 5: Cross-era deck analysis - Decks that remained competitive
SELECT 
    d.archetype,
    COUNT(DISTINCT t.format_era) AS eras_active,
    STRING_AGG(DISTINCT t.format_era, ', ' ORDER BY t.format_era) AS active_eras,
    COUNT(*) AS total_appearances,
    COUNT(CASE WHEN dr.finish_position = '1st Place' THEN 1 END) AS championships
FROM deck_results dr
JOIN decks d ON dr.deck_id = d.deck_id
JOIN tournaments t ON dr.tournament_id = t.tournament_id
GROUP BY d.archetype
HAVING COUNT(DISTINCT t.format_era) > 1
ORDER BY eras_active DESC, championships DESC;
