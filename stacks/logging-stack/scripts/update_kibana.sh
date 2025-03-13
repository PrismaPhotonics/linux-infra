log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Exit with an error message
error_exit() {
    log "ERROR: $1"
    exit 1
}

restart_kibana() {
    log "Restarting deployment kibana..."
    if ! kubectl rollout restart deployment kibana-kibana -n elk; then
        error_exit "Failed to restart deployment kibana"
    fi

    log "Waiting for deployment rollout to complete..."
    if ! kubectl rollout status deployment/kibana-kibana -n elk --timeout=180s; then
        error_exit "Deployment rollout did not complete within 180s"
    fi

    log "Waiting for pod with label release=kibana to be ready..."
    if ! kubectl wait --for=condition=ready pod -l release=kibana -n elk --timeout=180s; then
        error_exit "Pod with label release=kibana failed to become ready within 180s"
    fi

    log "Operation restart completed successfully."
}

update_kibana_and_searches() {
    log "Updating Kibana theme and uploading saved searches..."

    # Define the Kibana URL
    local kibana_url="https://$THREE_FIRST_OCTETS.100/kibana"
    log "Kibana URL: $kibana_url"

    log "Uploading Kibana dataview..."
    if curl -X POST "${kibana_url}/api/data_views/data_view" \
        -k \
        -H "Content-Type: application/json" \
        -H "kbn-xsrf: true" \
        -d '{
          "data_view": {
            "title": "logs*",
            "name": "logs",
            "timeFieldName": "@timestamp"
          }
        }' \
        -u elastic:prisma \
        -m 15; then
        log "Kibana dataview uploaded successfully."
    else
        error_exit "Failed to upload Kibana dataview."
    fi

    # Update Kibana theme to dark mode
    log "Updating Kibana theme to dark mode..."
    if curl -X POST "${kibana_url}/api/kibana/settings" \
        -k \
        -H "kbn-xsrf: true" \
        -H "Content-Type: application/json" \
        -d '{"changes":{"theme:darkMode":true}}' \
        -u elastic:prisma \
        -m 15; then
        log "Kibana theme updated to dark mode successfully."
    else
        error_exit "Failed to update Kibana theme to dark mode."
    fi

    log "Kibana theme and searches updated successfully."
}

restart_kibana
update_kibana_and_searches