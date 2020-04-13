{{- define "milvus.logConfig" -}}
* GLOBAL:
    FORMAT                  =   "%datetime | %level | %logger | %msg"
    FILENAME                =   "{{ .Values.logPath }}/logs/milvus-%datetime{%y-%M-%d-%H:%m}-global.log"
    ENABLED                 =   true
    TO_FILE                 =   true
    TO_STANDARD_OUTPUT      =   false
    SUBSECOND_PRECISION     =   3
    PERFORMANCE_TRACKING    =   false
    MAX_LOG_FILE_SIZE       =   209715200 ## Throw log files away after 200MB
* DEBUG:
    FILENAME                =   "{{ .Values.logPath }}/logs/milvus-%datetime{%y-%M-%d-%H:%m}-debug.log"
    ENABLED                 =   true
* WARNING:
    FILENAME                =   "{{ .Values.logPath }}/logs/milvus-%datetime{%y-%M-%d-%H:%m}-warning.log"
* TRACE:
    FILENAME                =   "{{ .Values.logPath }}/logs/milvus-%datetime{%y-%M-%d-%H:%m}-trace.log"
* VERBOSE:
    FORMAT                  =   "%datetime{%d/%M/%y} | %level-%vlevel | %msg"
    TO_FILE                 =   false
    TO_STANDARD_OUTPUT      =   false
## Error logs
* ERROR:
    ENABLED                 =   true
    FILENAME                =   "{{ .Values.logPath }}/logs/milvus-%datetime{%y-%M-%d-%H:%m}-error.log"
* FATAL:
    ENABLED                 =   true
    FILENAME                =   "{{ .Values.logPath }}/logs/milvus-%datetime{%y-%M-%d-%H:%m}-fatal.log"
{{- end }}
