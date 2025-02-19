log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Exit with an error message
error_exit() {
    log "ERROR: $1"
    exit 1
}

update_kibana_and_searches() {
    log "Updating Kibana theme and uploading saved searches..."

    # Define the Kibana URL
    local kibana_url="https://10.10.$SUBNET_OCTET.100/kibana"
    log "Kibana URL: $kibana_url"

    log "Uploading Kibana dataview..."
    if curl -X POST "${kibana_url}/api/data_views/data_view" \
        -k \
        -H "Content-Type: application/json" \
        -H "kbn-xsrf: true" \
        -d '{
          "data_view": {
            "title": "logs*",
            "name": "logs"
          }
        }' \
        -u elastic:prisma \
        -m 15; then
        log "Kibana dataview uploaded successfully."
    else
        error_exit "Failed to upload Kibana dataview."
    fi

    # Upload saved searches
    log "Uploading Kibana saved searches..."
    if curl -X POST "${kibana_url}/api/saved_objects/_import?overwrite=true" \
        -k \
        -H "kbn-xsrf: true" \
        -F file=@/home/prisma/UI-deploy/elk/kibana/searches.ndjson \
        -u elastic:prisma \
        -m 15; then
        log "Kibana saved searches uploaded successfully."
    else
        error_exit "Failed to upload Kibana saved searches."
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

update_kibana_and_searches