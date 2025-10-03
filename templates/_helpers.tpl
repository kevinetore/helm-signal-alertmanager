{{- define "alertmanager-signal.name" -}}
alertmanager-signal
{{- end -}}

{{- define "alertmanager-signal.fullname" -}}
{{ include "alertmanager-signal.name" . }}
{{- end -}}

