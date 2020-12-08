{% from 'splunkforwarder/map.jinja' import splunkforwarder with context %}

include:
{% if salt['pillar.get']('splunkforwarder:intermediate', False) %}
  - splunkforwarder.intermediate-forwarder
{% endif %}
{% if salt['pillar.get']('splunkforwarder:splunkcloud:enabled', False) %}
  - splunkforwarder.splunkcloud
{% endif %}
  - splunkforwarder.forwarder
  - splunkforwarder.certs
  - splunkforwarder.secret
  - splunkforwarder.user
