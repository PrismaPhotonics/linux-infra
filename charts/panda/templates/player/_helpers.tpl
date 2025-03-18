{{/*
Return the chart name for segy-recorder.
*/}}
{{- define "segy-recorder.name" -}}
{{- if .Values.segyRecorder.nameOverride -}}
  {{- .Values.segyRecorder.nameOverride | trimSuffix "-" -}}
{{- else -}}
  {{- .Chart.Name | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the fully qualified name for segy-recorder.
If fullnameOverride is set, use it; otherwise, use nameOverride.
*/}}
{{- define "segy-recorder.fullname" -}}
{{- if .Values.segyRecorder.fullnameOverride -}}
  {{- .Values.segyRecorder.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.segyRecorder.nameOverride -}}
  {{- .Values.segyRecorder.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the chart name and version for segy-recorder.
*/}}
{{- define "segy-recorder.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | trunc 63 | trimSuffix "-" -}}
{{- end -}}
