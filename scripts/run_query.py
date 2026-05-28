#!/usr/bin/env python3
"""
Script to run SQL queries from query files and display results
"""

import psycopg2
import sys
import os
from pathlib import Path

# Database connection parameters
DB_CONFIG = {
    'host': os.getenv('POSTGRES_HOST', 'localhost'),
    'port': os.getenv('POSTGRES_PORT', '5432'),
    'database': os.getenv('POSTGRES_DB', 'yugioh_championships'),
    'user': os.getenv('POSTGRES_USER', 'yugioh_user'),
    'password': os.getenv('POSTGRES_PASSWORD', 'yugioh_pass')
}

def run_query_file(filepath):
    """Run all queries in a SQL file"""
    try:
        # Read the SQL file
        with open(filepath, 'r') as f:
            sql_content = f.read()
        
        # Connect to database
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        print(f"\n🎴 Running queries from: {filepath}")
        print("=" * 80)
        
        # Split by query (simple split on semicolon + newline)
        queries = [q.strip() for q in sql_content.split(';') if q.strip() and not q.strip().startswith('--')]
        
        for idx, query in enumerate(queries, 1):
            # Skip comments and empty queries
            if query.startswith('--') or query.upper().startswith('CREATE') or len(query) < 10:
                continue
                
            print(f"\n📊 Query #{idx}")
            print("-" * 80)
            
            # Extract query comment if exists
            lines = query.split('\n')
            if lines[0].startswith('--'):
                print(f"Description: {lines[0][2:].strip()}")
            
            try:
                cur.execute(query)
                
                # Fetch results if it's a SELECT query
                if query.strip().upper().startswith('SELECT') or query.strip().upper().startswith('WITH'):
                    results = cur.fetchall()
                    colnames = [desc[0] for desc in cur.description]
                    
                    # Print column headers
                    print("\n" + " | ".join(colnames))
                    print("-" * 80)
                    
                    # Print rows
                    for row in results[:20]:  # Limit to first 20 rows
                        print(" | ".join(str(val) for val in row))
                    
                    if len(results) > 20:
                        print(f"\n... and {len(results) - 20} more rows")
                    
                    print(f"\nTotal rows: {len(results)}")
                else:
                    conn.commit()
                    print("✅ Query executed successfully")
                    
            except Exception as e:
                print(f"❌ Error executing query: {e}")
                continue
        
        cur.close()
        conn.close()
        
        print("\n" + "=" * 80)
        print("✨ Finished running queries\n")
        
    except FileNotFoundError:
        print(f"❌ Error: File not found: {filepath}")
    except Exception as e:
        print(f"❌ Error: {e}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python run_query.py <query_file.sql>")
        print("\nAvailable query files:")
        queries_dir = Path("queries")
        if queries_dir.exists():
            for f in sorted(queries_dir.glob("*.sql")):
                print(f"  - {f}")
        sys.exit(1)
    
    query_file = sys.argv[1]
    run_query_file(query_file)

if __name__ == "__main__":
    main()
