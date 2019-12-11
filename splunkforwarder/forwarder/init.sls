{% from 'splunkforwarder/map.jinja' import splunkforwarder with context %}

include:
{% if salt['pillar.get']('splunkforwarder:package:name', False) %}
  - splunkforwarder.forwarder.package.repo
{% else %}
  - splunkforwarder.forwarder.package.download
{% endif %}
