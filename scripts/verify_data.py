#!/usr/bin/env python3
"""
Script to verify the Yu-Gi-Oh! Championship database data
"""

import psycopg2
from psycopg2 import sql
import os

# Database connection parameters
DB_CONFIG = {
    'host': os.getenv('POSTGRES_HOST', 'localhost'),
    'port': os.getenv('POSTGRES_PORT', '5432'),
    'database': os.getenv('POSTGRES_DB', 'yugioh_championships'),
    'user': os.getenv('POSTGRES_USER', 'yugioh_user'),
    'password': os.getenv('POSTGRES_PASSWORD', 'yugioh_pass')
}

def verify_database():
    """Verify database connection and data"""
    try:
        print("🎴 Yu-Gi-Oh! Championship Database Verification")
        print("=" * 50)
        print()
        
        # Connect to database
        print("📡 Connecting to database...")
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        print("✅ Connected successfully!")
        print()
        
        # Verify tables
        tables = ['tournaments', 'players', 'decks', 'cards', 'deck_results', 'deck_cards']
        print("📊 Verifying tables and row counts:")
        print("-" * 50)
        
        for table in tables:
            cur.execute(f"SELECT COUNT(*) FROM {table};")
            count = cur.fetchone()[0]
            print(f"   {table:<20} {count:>5} rows")
        
        print()
        print("🏆 Sample Data:")
        print("-" * 50)
        
        # Show recent world champions
        cur.execute("""
            SELECT 
                t.name,
                t.date,
                p.first_name || ' ' || p.last_name as champion,
                p.country,
                d.deck_name
            FROM deck_results dr
            JOIN tournaments t ON dr.tournament_id = t.tournament_id
            JOIN players p ON dr.player_id = p.player_id
            JOIN decks d ON dr.deck_id = d.deck_id
            WHERE dr.finish_position = '1st Place'
            ORDER BY t.date DESC
            LIMIT 5;
        """)
        
        results = cur.fetchall()
        print("\n   Recent World Champions:")
        for row in results:
            print(f"   • {row[1]}: {row[2]} ({row[3]}) - {row[4]}")
        
        print()
        print("✨ Database verification complete!")
        
        cur.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return False
    
    return True

if __name__ == "__main__":
    verify_database()
