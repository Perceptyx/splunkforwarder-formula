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
