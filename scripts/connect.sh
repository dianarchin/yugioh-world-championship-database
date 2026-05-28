#!/bin/bash
# Script to connect to the PostgreSQL database

docker exec -it yugioh_db psql -U yugioh_user -d yugioh_championships
