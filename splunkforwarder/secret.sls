
include:
  - splunkforwarder.forwarder

{% if salt['pillar.get']('splunk:secret', False) %}

/opt/splunkforwarder/etc/auth:
  file.directory:
    - user: splunk
    - group: splunk
    - mode: '0700'
    - makedirs: True

/opt/splunkforwarder/etc/auth/splunk.secret:
  file.managed:
    - user: splunk
    - group: splunk
    - mode: '0400'
    - contents_pillar: splunk:secret
    - require:
      - file: /opt/splunkforwarder/etc/auth
    - require_in:
      - service: splunkforwarder
    - watch_in:
      - service: splunkforwarder

{% endif %}
