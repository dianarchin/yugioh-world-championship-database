-- ============================================
-- REGIONAL ANALYSIS QUERIES
-- ============================================

-- Query 1: Championships won by region
SELECT 
    p.region,
    COUNT(*) AS championships_won,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM deck_results WHERE finish_position = '1st Place'), 2) AS win_percentage
FROM deck_results dr
JOIN players p ON dr.player_id = p.player_id
WHERE dr.finish_position = '1st Place'
GROUP BY p.region
ORDER BY championships_won DESC;

-- Query 2: Championships won by country
SELECT 
    p.country,
    COUNT(*) AS championships_won,
    STRING_AGG(DISTINCT p.first_name || ' ' || p.last_name, ', ' ORDER BY p.first_name || ' ' || p.last_name) AS champions
FROM deck_results dr
JOIN players p ON dr.player_id = p.player_id
WHERE dr.finish_position = '1st Place'
GROUP BY p.country
ORDER BY championships_won DESC;

-- Query 3: Regional dominance by era
SELECT 
    t.format_era,
    p.region,
    COUNT(*) AS wins
FROM deck_results dr
JOIN tournaments t ON dr.tournament_id = t.tournament_id
JOIN players p ON dr.player_id = p.player_id
WHERE dr.finish_position = '1st Place'
GROUP BY t.format_era, p.region
ORDER BY t.format_era, wins DESC;

-- Query 4: Top 4 finishes by region
SELECT 
    p.region,
    COUNT(CASE WHEN dr.finish_position = '1st Place' THEN 1 END) AS first_place,
    COUNT(CASE WHEN dr.finish_position = 'Runner-Up' THEN 1 END) AS runner_up,
    COUNT(CASE WHEN dr.finish_position LIKE 'Top%' THEN 1 END) AS total_top_finishes
FROM deck_results dr
JOIN players p ON dr.player_id = p.player_id
GROUP BY p.region
ORDER BY first_place DESC, total_top_finishes DESC;
