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

  describe port(9998) do
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

  describe ini('/opt/splunkforwarder/etc/system/local/outputs.conf') do
    selfsigned_path = '/opt/splunkforwarder/etc/certs/selfsignedcert.pem'
    cacert_path = '/opt/splunkforwarder/etc/certs/cacert.pem'

    its('tcpout.useACK') { should eq 'true' }
    its('tcpout.defaultGroup') { should eq 'splunkssl' }
    its('tcpout:splunkssl.compressed') { should eq 'true' }
    its('tcpout:splunkssl.server') { should eq '1.2.3.4:9998,1.2.4.5:9998' }
    its('tcpout:splunkssl.sslCertPath') { should eq selfsigned_path }
    its('tcpout:splunkssl.sslRootCAPath') { should eq cacert_path }
    its('tcpout:splunkssl.sslVerifyServerCert') { should eq 'false' }
  end
end
