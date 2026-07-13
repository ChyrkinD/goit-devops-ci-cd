{{- define "django-app.name" -}}
{{- default .Chart.Name .Values.nameOverride -}}
{{- end -}}

{{- define "django-app.fullname" -}}
{{- printf "%s" (include "django-app.name" .) -}}
{{- end -}}
