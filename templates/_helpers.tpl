{{/* Expand the name of the app */}}
{{- define "rustcost.name" -}}
{{ .Chart.Name }}
{{- end }}

{{/* Create a default fully qualified app name */}}
{{- define "rustcost.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "rustcost.name" .) | trunc 63 | trimSuffix "-" }}
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
Logging level builder
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

{{/*
RBAC role normalizer
- values.yaml: rbac.role = viewer|developer|admin
*/}}
{{- define "rustcost.rbacRole" -}}
{{- default "viewer" .Values.rbac.role | lower -}}
{{- end }}

{{/*
ServiceAccount name (fixed, based on fullnameOverride)
- Always: <fullname>-<role>-sa
- If fullnameOverride: rustcost  => rustcost-viewer-sa
*/}}
{{- define "rustcost.saName" -}}
{{- printf "%s-%s-sa" (include "rustcost.fullname" .) (include "rustcost.rbacRole" .) -}}
{{- end }}