{% from 'splunkforwarder/map.jinja' import splunkforwarder with context %}

include:
  - splunkforwarder.certs
  - splunkforwarder.user
  - splunkforwarder.forwarder.config

get-splunkforwarder-package:
  file.managed:
    - name: /usr/local/src/{{ splunkforwarder.package_filename }}
    - source: {{ splunkforwarder.download_base_url }}{{ splunkforwarder.package_filename }}
    - source_hash: {{ splunkforwarder.source_hash }}
    - makedirs: True

{%- if grains['os_family'] == 'Suse' %}
get-gpg-signed-rpm-splunk:
  file.managed:
    - name: /tmp/splunk.pub
    - source: https://docs.splunk.com/images/6/6b/SplunkPGPKey.pub
    - source_hash: sha256=94a3e69d65858252bafba26eba8014d6ddd793bb6fdaf52b902188618b9d356b

rpm-install-key-splunk:
  cmd.run:
    - name: rpm --import /tmp/splunk.pub
    - require:
      - file: /tmp/splunk.pub
{%- endif %}

{%- if grains['os_family'] == 'Debian' %}
is-splunkforwarder-package-outdated:
  cmd.run:
    - cwd: /usr/local/src
    - stateful: True
    - names:
      - new=$(dpkg-deb --showformat='${Package} ${Version}\n' -W {{ splunkforwarder.package_filename }});
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
      - splunkforwarder: /usr/local/src/{{ splunkforwarder.package_filename }}
    - require:
      - user: splunk_user
      - file: get-splunkforwarder-package
  {%- if grains['os_family'] == 'Suse' %}
      - rpm-install-key-splunk
  {% endif %}
    - require_in:
      - service: splunkforwarder
    - force: True
  {% if grains['os'] == 'FreeBSD' %}
  cmd.run:
    - name: |
        /opt/splunkforwarder/bin/splunk enable boot-start --accept-license --no-prompt --answer-yes
        ln -s /etc/rc.d/splunk /etc/rc.d/splunkforwarder
    - unless: test -f /etc/rc.d/splunk && test -h /etc/rc.d/splunkforwarder
    - require_in:
      - service: splunkforwarder
  {% else %}
  {# Use sysvinit script or systemd based on the following check #}
  {%- if salt['cmd.retcode']('command -v systemctl 2>&1 /dev/null', python_shell=True) == 1 %}
  file.managed:
    - name: /etc/init.d/splunkforwarder
    - source: salt://splunkforwarder/init.d/splunkforwarder.sh
    - template: jinja
    - mode: '0755'
    - require_in:
      - service: splunkforwarder
  {% else %}
  file.managed:
    - name: /etc/systemd/system/splunkforwarder.service
    - source: salt://splunkforwarder/init.d/splunkforwarder.service
    - template: jinja
    - mode: '0644'
    - require_in:
      - service: splunkforwarder
  {% endif %}
  {% endif %}
  {%- if grains['os_family'] == 'Debian' %}
  cmd.watch:
    - cwd: /usr/local/src/
    - name: dpkg -i {{ splunkforwarder.package_filename }}
    - watch:
      - cmd: is-splunkforwarder-package-outdated
    - require_in:
      - service: splunkforwarder
  {% endif %}
  service.running:
    - name: splunkforwarder
    - enable: True
    - restart: True
    - watch:
      - file: /opt/splunkforwarder/etc/system/local/outputs.conf
