{{/*
Return the chart name.
*/}}
{{- define "focus-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the fully qualified name, e.g. "release-focus-server".
*/}}
{{- define "focus-server.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if .Values.fullnameOverride -}}
  {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the chart name and version, e.g. "focus-server-0.1.0".
*/}}
{{- define "focus-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | trunc 63 | trimSuffix "-" -}}
{{- end -}}
