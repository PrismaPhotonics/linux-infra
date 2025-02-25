#!/bin/bash

# Enable strict error handling
set -euo pipefail

log() {
    sudo echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" 
}

error_exit() {
    log "ERROR: $1"
    exit 1
}

ensure_directory() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        log "Creating directory: $dir"
        sudo mkdir -p "$dir"
    fi
}

generate_tls_keys() {
    log "Generating TLS keys for RabbitMQ..."

    # Define TLS folder and file paths
    local tls_folder="/home/prisma/config/nginx/tls/"
    local tls_crt_file="${tls_folder}tls.crt"
    local tls_key_file="${tls_folder}tls.key"

    # Ensure the TLS folder exists
    ensure_directory "$tls_folder"

    # Check if the TLS certificate and key already exist
    if [[ -f "$tls_crt_file" && -f "$tls_key_file" ]]; then
        log "Existing TLS keys found. Removing old keys..."
        return 0
    fi

    # Generate new TLS certificate and key
    log "Generating new TLS certificate and key..."
    sudo openssl req -x509 -nodes -days 867 -newkey rsa:2048 -keyout "$tls_key_file" -out "$tls_crt_file" \
        -subj "/CN=local.prismaphotonics.net/O=local.prismaphotonics.net" || error_exit "Failed to generate TLS certificate and key."
    log "TLS certificate and key generated successfully."

    # Set appropriate permissions
    log "Setting permissions for TLS folder and files..."
    sudo chown -R prisma:prisma "$tls_folder" || error_exit "Failed to chown on TLS folder."
    sudo chmod -R 700 "$tls_folder" || error_exit "Failed to set permissions on TLS folder."
    sudo chmod -R 600 "$tls_crt_file" "$tls_key_file" || error_exit "Failed to set permissions on TLS files."

    log "TLS keys generated and configured successfully."
}

create_secrets() {
    create_secret() {
        local type="$1"   # e.g., tls, generic
        local name="$2"
        shift 2
        local args=("$@")

        if kubectl get secret "$name" -n kube-system >/dev/null 2>&1; then
            log "Secret '$name' exists. Deleting..."
            return 0
        fi

        kubectl create secret "$type" "$name" "${args[@]}" \
            || error_exit "Failed to create Secret: $name."
        log "Secret '$name' created successfully."
    }

    create_secret "tls" "tls-secret" \
        --key "/home/prisma/config/nginx/tls/tls.key" \
        --cert "/home/prisma/config/nginx/tls/tls.crt"
        -n "kube-system"

    log "ConfigMaps, Secrets, and Persistent Volumes created successfully."
}

generate_tls_keys
create_secrets