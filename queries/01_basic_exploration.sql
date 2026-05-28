-- ============================================
-- BASIC EXPLORATION QUERIES
-- ============================================

-- Query 1: Overview of all tournaments
SELECT 
    tournament_id,
    name,
    location,
    date,
    format_era,
    total_participants
FROM tournaments
ORDER BY date DESC;

-- Query 2: All World Champions
SELECT 
    p.first_name || ' ' || p.last_name AS champion,
    p.country,
    p.region,
    t.name AS tournament,
    t.date,
    d.deck_name
FROM deck_results dr
JOIN tournaments t ON dr.tournament_id = t.tournament_id
JOIN players p ON dr.player_id = p.player_id
JOIN decks d ON dr.deck_id = d.deck_id
WHERE dr.finish_position = '1st Place'
ORDER BY t.date;

-- Query 3: Most popular deck archetypes
SELECT 
    d.archetype,
    COUNT(*) AS times_played,
    COUNT(CASE WHEN dr.finish_position = '1st Place' THEN 1 END) AS championships_won
FROM deck_results dr
JOIN decks d ON dr.deck_id = d.deck_id
GROUP BY d.archetype
ORDER BY times_played DESC;

-- Query 4: Banned cards in the dataset
SELECT 
    card_name,
    card_type,
    attribute,
    archetype_tag
FROM cards
WHERE is_banned = TRUE
ORDER BY card_name;

-- Query 5: Tournament participation over time
SELECT 
    EXTRACT(YEAR FROM date) AS year,
    format_era,
    COUNT(*) AS num_tournaments,
    AVG(total_participants) AS avg_participants
FROM tournaments
GROUP BY EXTRACT(YEAR FROM date), format_era
ORDER BY year;
