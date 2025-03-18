{{/*
Return the chart name for focus-server.
*/}}
{{- define "focus-server.name" -}}
{{- if .Values.focusServer.nameOverride -}}
  {{- .Values.focusServer.nameOverride | trimSuffix "-" -}}
{{- else -}}
  {{- .Chart.Name | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the fully qualified name for focus-server.
If fullnameOverride is set, use it; otherwise, use nameOverride.
*/}}
{{- define "focus-server.fullname" -}}
{{- if .Values.focusServer.fullnameOverride -}}
  {{- .Values.focusServer.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.focusServer.nameOverride -}}
  {{- .Values.focusServer.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the chart name and version for focus-server.
*/}}
{{- define "focus-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | trunc 63 | trimSuffix "-" -}}
{{- end -}}
