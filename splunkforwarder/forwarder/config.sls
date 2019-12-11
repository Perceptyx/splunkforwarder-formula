{%- set self_cert = salt['pillar.get']('splunk:self_cert_filename', 'selfsignedcert.pem') %}

include:
  - splunkforwarder.certs
  - splunkforwarder.user


/opt/splunkforwarder/etc/apps/search/local:
  file.directory:
    - user: splunk
    - group: splunk
    - mode: '0755'
    - makedirs: True

/opt/splunkforwarder/etc/system/local:
  file.directory:
    - user: splunk
    - group: splunk
    - mode: '0755'
    - makedirs: True

/opt/splunkforwarder/etc/apps/search/local/inputs.conf:
  file.managed:
    - name: /opt/splunkforwarder/etc/apps/search/local/inputs.conf
    - source: salt://splunkforwarder/etc-apps-search/local/inputs.conf
    - template: jinja
    - user: splunk
    - group: splunk
    - mode: '0644'
    - context:
      self_cert: {{ self_cert }}
    - require:
      - pkg: splunkforwarder
      - file: /opt/splunkforwarder/etc/apps/search/local
      - file: /opt/splunkforwarder/etc/certs/{{ self_cert }}
    - require_in:
      - service: splunkforwarder
    - watch_in:
      - service: splunkforwarder

/opt/splunkforwarder/etc/system/local/outputs.conf:
  file.managed:
    - name: /opt/splunkforwarder/etc/system/local/outputs.conf
    - source: salt://splunkforwarder/etc-system-local/outputs.conf
    - template: jinja
    - user: splunk
    - group: splunk
    - mode: '0600'
    - context:
      self_cert: {{ self_cert }}
    - require:
      - pkg: splunkforwarder
      - file: /opt/splunkforwarder/etc/system/local

/opt/splunkforwarder/etc/system/local/user-seed.conf:
  file.managed:
    - name: /opt/splunkforwarder/etc/system/local/user-seed.conf
    - source: salt://splunkforwarder/etc-system-local/user-seed.conf
    - template: jinja
    - user: splunk
    - group: splunk
    - mode: '0600'
    - context:
      self_cert: {{ self_cert }}
    - require:
      - pkg: splunkforwarder
      - file: /opt/splunkforwarder/etc/system/local
      - file: /opt/splunkforwarder/etc/certs/{{ self_cert }}

/opt/splunkforwarder/etc/system/local/server.conf:
  file.managed:
    - name: /opt/splunkforwarder/etc/system/local/server.conf
    - source: salt://splunkforwarder/etc-system-local/server.conf
    - template: jinja
    - user: splunk
    - group: splunk
    - mode: '0600'
    - context:
      self_cert: {{ self_cert }}
    - require:
      - pkg: splunkforwarder
      - file: /opt/splunkforwarder/etc/system/local
    - onchanges_in:
      - service: splunkforwarder
