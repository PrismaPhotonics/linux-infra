{{/*
Return the chart name for player.
*/}}
{{- define "player.name" -}}
{{- if .Values.player.nameOverride -}}
  {{- .Values.player.nameOverride | trimSuffix "-" -}}
{{- else -}}
  {{- .Chart.Name | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the fully qualified name for player.
If fullnameOverride is set, use it; otherwise, use nameOverride.
*/}}
{{- define "player.fullname" -}}
{{- if .Values.player.fullnameOverride -}}
  {{- .Values.player.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.player.nameOverride -}}
  {{- .Values.player.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the chart name and version for player.
*/}}
{{- define "player.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | trunc 63 | trimSuffix "-" -}}
{{- end -}}
