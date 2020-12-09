# frozen_string_literal: true

control 'splunkforwarder configuration' do
  title 'should match desired lines'

  describe file('/opt/splunkforwarder/etc/system/local/server.conf') do
    its('type') { should eq :file }
    it { should be_owned_by 'splunk' }
    it { should be_grouped_into 'splunk' }
    its('mode') { should cmp '0600' }
  end

  describe ini('/opt/splunkforwarder/etc/system/local/server.conf') do
    its('httpServer.acceptFrom') { should eq '127.0.0.1' }
  end

  describe port(8089) do
    it { should be_listening }
    its('processes') { should include 'splunkd' }
    its('protocols') { should include 'tcp' }
    its('addresses') { should include '0.0.0.0' }
  end

  describe ini('/opt/splunkforwarder/etc/system/local/inputs.conf') do
    its(['monitor:///var/log/mysql/mysql-slow.log',
         'index']) { should cmp 'database' }
    its(['monitor:///var/log/mysql/mysql-slow.log',
         'sourcetype']) { should cmp 'mysql_slow' }
  end

  describe ini('/opt/splunkforwarder/etc/apps/search/local/inputs.conf') do
    its(['monitor:///var/log/nginx/access.log',
         'index']) { should cmp 'search' }
    its(['monitor:///var/log/nginx/access.log',
         'sourcetype']) { should cmp 'nginx_access_log' }
  end

  # rubocop:disable Metrics/LineLength
  describe parse_config_file('/opt/splunkforwarder/etc/apps/search/local/props.conf',
                             standalone_comments: true) do
    # rubocop:enable Metrics/LineLength
    its('mysql_slow.pulldown_type') { should eq 'true' }
    its('mysql_slow.category') { should cmp 'Database' }
    its('mysql_slow.description') { should cmp 'Mysql Slow Query Logs' }
    its('mysql_slow.BREAK_ONLY_BEFORE') { should cmp '^#\s*User@Host' }
  end

  describe ini('/opt/splunkforwarder/etc/apps/100_testme_splunkcloud/default/outputs.conf') do
    cacert_path = 'etc/apps/100_testme_splunkcloud/default/testme_cacert.pem'
    cert_path = 'etc/apps/100_testme_splunkcloud/default/testme_server.pem'

    its('tcpout.defaultGroup') { should cmp 'splunkcloud' }
    its('tcpout:splunkcloud.compressed') { should cmp 'false' }
    its('tcpout:splunkcloud.server') { should include 'inputs1.testme.splunkcloud.com:9997' }
    its('tcpout:splunkcloud.sslCommonNameToCheck') { should cmp '*.testme.splunkcloud.com' }
    its('tcpout:splunkcloud.sslCertPath') { should include cert_path }
    its('tcpout:splunkcloud.sslRootCAPath') { should include cacert_path }
    its('tcpout:splunkcloud.sslVerifyServerCert') { should cmp 'true' }
  end
end
