{{/*
Return the chart name.
*/}}
{{- define "tileserver-gl.name" -}}
{{- default .Chart.Name .Values.nameOverride | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the fully qualified name, e.g. "release-tileserver-gl".
*/}}
{{- define "tileserver-gl.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if .Values.fullnameOverride -}}
  {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the chart name and version, e.g. "tileserver-gl-0.1.0".
*/}}
{{- define "tileserver-gl.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | trunc 63 | trimSuffix "-" -}}
{{- end -}}