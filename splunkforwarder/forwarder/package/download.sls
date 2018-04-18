{%- set download_base_url = pillar['splunkforwarder']['download_base_url'] %}
{%- set package_filename = pillar['splunkforwarder']['package_filename'] %}
{%- set source_hash = pillar['splunkforwarder']['source_hash'] %}

include:
  - splunkforwarder.certs
  - splunkforwarder.user
  - splunkforwarder.forwarder.config

get-splunkforwarder-package:
  file.managed:
    - name: /usr/local/src/{{ package_filename }}
    - source: {{ download_base_url }}{{ package_filename }}
    - source_hash: {{ source_hash }}
    - makedirs: True

{%- if grains['os_family'] == 'Debian' %}
is-splunkforwarder-package-outdated:
  cmd.run:
    - cwd: /usr/local/src
    - stateful: True
    - names:
      - new=$(dpkg-deb --showformat='${Package} ${Version}\n' -W {{ package_filename }});
        old=$(dpkg-query --showformat='${Package} ${Version}\n' -W splunkforwarder);
        if test "$new" != "$old";
          then echo; echo "changed=true comment='new($new) vs old($old)'";
          else echo; echo "changed=false";
        fi;
    - require:
      - pkg: splunkforwarder
{% endif %}

splunkforwarder:
  pkg.installed:
    - sources:
      - splunkforwarder: /usr/local/src/{{ package_filename }}
    - require:
      - user: splunk_user
      - file: get-splunkforwarder-package
    - require_in:
      - service: splunkforwarder
  {%- if grains['os_family'] == 'Debian' %}
  {# Use sysvinit script or systemd based on the following check #}
  {%- if salt['cmd.retcode']('command -v systemctl 2>&1 /dev/null', python_shell=True) == 1 %}
  file.managed:
    - name: /etc/init.d/splunkforwarder
    - source: salt://splunkforwarder/init.d/splunkforwarder.sh
    - template: jinja
    - mode: 755
    - require_in:
      - service: splunkforwarder
  {% else %}
  file.managed:
    - name: /etc/systemd/system/splunkforwarder.service
    - source: salt://splunkforwarder/init.d/splunkforwarder.service
    - template: jinja
    - mode: 644
    - require_in:
      - service: splunkforwarder
  {% endif %}
  cmd.watch:
    - cwd: /usr/local/src/
    - name: dpkg -i {{ package_filename }}
    - watch:
      - cmd: is-splunkforwarder-package-outdated
    - require_in:
      - service: splunkforwarder
  {% elif grains['os'] == 'FreeBSD' %}
  cmd.run:
    - name: |
        /opt/splunkforwarder/bin/splunk enable boot-start --accept-license --no-prompt --answer-yes
        ln -s /etc/rc.d/splunk /etc/rc.d/splunkforwarder
    - unless: test -f /etc/rc.d/splunk && test -h /etc/rc.d/splunkforwarder
    - require_in:
      - service: splunkforwarder
  {% endif %}
  service.running:
    - name: splunkforwarder
    - enable: True
    - restart: True
    - watch:
      - file: /opt/splunkforwarder/etc/system/local/outputs.conf
