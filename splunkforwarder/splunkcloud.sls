{% set splunkcloud = salt['pillar.get']('splunkforwarder:splunkcloud', {}) %}

/opt/splunkforwarder/etc/apps/{{ splunkcloud.prefix }}{{ splunkcloud.instance }}_splunkcloud:
  file.directory:
    - user: splunk
    - group: splunk
    - mode: '0755'
    - makedirs: True
    - require:
      - user: splunk_user

{% for dirname in splunkcloud.config %}
{% for filename in splunkcloud.config[dirname] %}
/opt/splunkforwarder/etc/apps/{{ splunkcloud.prefix }}{{ splunkcloud.instance }}_splunkcloud/{{ dirname }}/{{ filename }}:
  file.managed:
    - user: splunk
    - group: splunk
    - mode: '0640'
    - makedirs: True
    - contents: |
        {%- if 'contents' in splunkcloud.config[dirname][filename] %}
        {{ splunkcloud.config[dirname][filename].contents | indent(8) }}
        {%- else %}
        # WARNING: This file is managed using salt. DO NOT EDIT.
        {% for groupname in splunkcloud.config[dirname][filename] %}
        {{ "[" ~ groupname ~ "]" | indent(8) }}
        {% for name, value in splunkcloud.config[dirname][filename][groupname].items() %}
        {%- if value is string or value is number -%}
        {%- set data = value -%}
        {%- else -%}
        {%- set data = value | join(',') -%}
        {%- endif -%}
        {%- set line = name ~ ' = ' ~ data -%}
        {{ line | indent(8) }}
        {% endfor %}
        {% endfor %}
        {%- endif %}
    - require:
      - file: /opt/splunkforwarder/etc/apps/{{ splunkcloud.prefix }}{{ splunkcloud.instance }}_splunkcloud

{% endfor %}
{% endfor %}
