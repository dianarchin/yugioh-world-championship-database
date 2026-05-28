-- ============================================
-- DECK ANALYSIS QUERIES
-- ============================================

-- Query 1: Most successful decks (win rate)
SELECT 
    d.deck_name,
    d.archetype,
    d.format_era,
    COUNT(*) AS times_played,
    COUNT(CASE WHEN dr.finish_position = '1st Place' THEN 1 END) AS championships,
    ROUND(COUNT(CASE WHEN dr.finish_position = '1st Place' THEN 1 END) * 100.0 / COUNT(*), 2) AS win_rate
FROM deck_results dr
JOIN decks d ON dr.deck_id = d.deck_id
GROUP BY d.deck_name, d.archetype, d.format_era
HAVING COUNT(*) >= 2  -- Only decks played at least twice
ORDER BY win_rate DESC, championships DESC;

-- Query 2: Deck diversity by era
SELECT 
    t.format_era,
    COUNT(DISTINCT d.archetype) AS unique_archetypes,
    COUNT(DISTINCT d.deck_id) AS unique_decks
FROM deck_results dr
JOIN tournaments t ON dr.tournament_id = t.tournament_id
JOIN decks d ON dr.deck_id = d.deck_id
GROUP BY t.format_era
ORDER BY 
    CASE t.format_era
        WHEN 'Classic Era' THEN 1
        WHEN 'GX Era' THEN 2
        WHEN '5Ds Era' THEN 3
        WHEN 'Zexal Era' THEN 4
        WHEN 'Arc-V Era' THEN 5
        WHEN 'VRAINS Era' THEN 6
        WHEN 'Rush Era' THEN 7
    END;

-- Query 3: Deck composition - Most used cards
SELECT 
    c.card_name,
    c.card_type,
    c.archetype_tag,
    COUNT(DISTINCT dc.deck_id) AS decks_using,
    SUM(dc.copies_used) AS total_copies
FROM deck_cards dc
JOIN cards c ON dc.card_id = c.card_id
GROUP BY c.card_name, c.card_type, c.archetype_tag
ORDER BY decks_using DESC, total_copies DESC
LIMIT 20;

-- Query 4: Average deck composition by card type
SELECT 
    c.card_type,
    COUNT(*) AS total_cards,
    ROUND(AVG(dc.copies_used), 2) AS avg_copies_per_deck,
    COUNT(DISTINCT dc.deck_id) AS decks_using
FROM deck_cards dc
JOIN cards c ON dc.card_id = c.card_id
GROUP BY c.card_type
ORDER BY total_cards DESC;

-- Query 5: Tier 1 decks performance
SELECT 
    d.deck_name,
    d.format_era,
    COUNT(CASE WHEN dr.finish_position = '1st Place' THEN 1 END) AS wins,
    COUNT(CASE WHEN dr.finish_position = 'Runner-Up' THEN 1 END) AS runner_ups,
    COUNT(*) AS total_appearances
FROM deck_results dr
JOIN decks d ON dr.deck_id = d.deck_id
WHERE d.tier = 'Tier 1'
GROUP BY d.deck_name, d.format_era
ORDER BY wins DESC, total_appearances DESC;
