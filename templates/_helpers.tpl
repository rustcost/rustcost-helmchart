{{/*
Expand the name of the chart.
*/}}
{{- define "rustcost.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "rustcost.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Chart name and version.
*/}}
{{- define "rustcost.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rustcost.labels" -}}
helm.sh/chart: {{ include "rustcost.chart" . }}
app.kubernetes.io/name: {{ include "rustcost.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels (used in Deployment/Service selectors)
*/}}
{{- define "rustcost.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rustcost.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
logging
*/}}
{{- define "rustcost.rustlog" -}}
{{- $base := (.Values.logging.level | default "info") -}}
{{- $mods := list -}}
{{- range $k, $v := .Values.logging.moduleLevels }}
  {{- $mods = append $mods (printf "%s=%s" $k $v) -}}
{{- end -}}
{{- if gt (len $mods) 0 -}}
{{- printf "%s,%s" $base (join "," $mods) -}}
{{- else -}}
{{- $base -}}
{{- end -}}
{{- end -}}