{%- set self_cert = salt['pillar.get']('splunk:self_cert_filename', 'selfsignedcert.pem') %}

include:
  - splunkforwarder.forwarder

/opt/splunkforwarder/etc/apps/search/metadata:
  file.directory:
    - user: splunk
    - group: splunk
    - mode: '0755'
    - makedirs: True

/opt/splunkforwarder/etc/apps/search/metadata/local.metadata:
  file.managed:
    - name: /opt/splunkforwarder/etc/apps/search/metadata/local.metadata
    - source: salt://splunkforwarder/etc-apps-search/metadata/local.metadata
    - template: jinja
    - user: splunk
    - group: splunk
    - mode: '0600'
    - require:
      - pkg: splunkforwarder
      - file: /opt/splunkforwarder/etc/apps/search/metadata
    - require_in:
      - service: splunkforwarder
    - watch_in:
      - service: splunkforwarder
