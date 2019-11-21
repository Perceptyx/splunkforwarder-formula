
include:
  - splunkforwarder.user

/opt/splunkforwarder/etc:
  file.directory:
    - user: splunk
    - group: splunk
    - mode: '0755'
    - makedirs: True
    - require:
      - user: splunk

/opt/splunkforwarder/etc/certs:
  file.directory:
    - user: splunk
    - group: splunk
    - mode: '0500'
    - makedirs: True
    - require:
      - file: /opt/splunkforwarder/etc

{% if salt['pillar.get']('splunk:certs') is mapping %}

{% for filename, config in salt['pillar.get']('splunk:certs', {}).items() %}

/opt/splunkforwarder/etc/certs/{{ filename }}:
  file.managed:
    - user: splunk
    - group: splunk
    - mode: {{ config.get('mode', 400) }}
    - contents_pillar: splunk:certs:{{ filename }}:content
    - require:
      - file: /opt/splunkforwarder/etc/certs
      - user: splunk
    - require_in:
      - service: splunkforwarder
    - watch_in:
      - service: splunkforwarder

{% endfor %}

{% endif %}
