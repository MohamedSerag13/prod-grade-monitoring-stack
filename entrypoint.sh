#!/bin/bash

# =============================================================================
# Production-Grade Monitoring Stack Entrypoint Script
# =============================================================================
# This script substitutes environment variables in configuration files
# before starting the monitoring stack services.

set -e

echo "Starting environment variable substitution..."

# -----------------------------------------------------------------------------
# Function to substitute environment variables in a file
# -----------------------------------------------------------------------------
substitute_env_vars() {
    local file_path="$1"
    local temp_file="${file_path}.tmp"
    
    if [ -f "$file_path" ]; then
        echo "Processing: $file_path"
        envsubst < "$file_path" > "$temp_file"
        mv "$temp_file" "$file_path"
    else
        echo "Warning: File not found: $file_path"
    fi
}

# -----------------------------------------------------------------------------
# Substitute variables in Prometheus configuration
# -----------------------------------------------------------------------------
echo "Processing Prometheus configuration"
substitute_env_vars "prometheus/prometheus.yml"
substitute_env_vars "prometheus/alert.rules.yml"

# -----------------------------------------------------------------------------
# Substitute variables in Alertmanager configuration
# -----------------------------------------------------------------------------
echo "Processing Alertmanager configuration"
substitute_env_vars "alertmanager/config.yml"

# -----------------------------------------------------------------------------
# Substitute variables in Loki configuration
# -----------------------------------------------------------------------------
echo "Processing Loki configuration"
substitute_env_vars "loki/loki-config.yml"

# -----------------------------------------------------------------------------
# Substitute variables in Promtail configuration
# -----------------------------------------------------------------------------
echo "Processing Promtail configuration"
substitute_env_vars "promtail/promtail-config.yaml"

# -----------------------------------------------------------------------------
# Substitute variables in Blackbox configuration
# -----------------------------------------------------------------------------
echo "Processing Blackbox configuration"
substitute_env_vars "blackbox/config.yml"

echo "Environment variable substitution completed!"
echo "Starting monitoring stack..."

# -----------------------------------------------------------------------------
# Start the services using docker-compose
# -----------------------------------------------------------------------------
exec docker-compose up -d 