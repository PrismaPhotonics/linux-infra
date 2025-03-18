{{/*
Return the chart name.
*/}}
{{- define "segy-recorder.name" -}}
{{- default .Chart.Name .Values.segyRecorder.nameOverride | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the fully qualified name, e.g. "release-segy-recorder".
*/}}
{{- define "segy-recorder.fullname" -}}
{{- $name := default .Chart.Name .Values.segyRecorder.nameOverride -}}
{{- if .Values.segyRecorder.fullnameOverride -}}
  {{- .Values.segyRecorder.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the chart name and version, e.g. "segy-recorder-0.1.0".
*/}}
{{- define "segy-recorder.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | trunc 63 | trimSuffix "-" -}}
{{- end -}}
