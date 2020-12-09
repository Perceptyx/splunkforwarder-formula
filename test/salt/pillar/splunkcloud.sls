splunkforwarder:
  # It's recommended to limit to localhost connections in management port 8089
  server:
    httpServer:
      acceptFrom: "127.0.0.1"

  cert_filename: selfsignedcert.pem
  intermediate: False

  splunkcloud:
    # This will be saved to $SPLUNK_HOME/etc/apps/$prefix$instance_splunkcloud
    enabled: True
    instance: testme
    prefix: "100_"
    config:
      local:
        outputs.conf:
          "tcpout:splunkcloud":
            sslPassword: somereallygreatpassword
      default:
        limits.conf:
          thruput:
            maxKBps: 256
        outputs.conf:
          tcpout:
            defaultGroup: splunkcloud
          "tcpout:splunkcloud":
            server:
              - inputs1.testme.splunkcloud.com:9997
              - inputs2.testme.splunkcloud.com:9997
            compressed: "false"
            sslCertPath: '"$SPLUNK_HOME/etc/apps/100_testme_splunkcloud/default/testme_server.pem"'
            sslRootCAPath: '"$SPLUNK_HOME/etc/apps/100_testme_splunkcloud/default/testme_cacert.pem"'
            sslCommonNameToCheck: "*.testme.splunkcloud.com"
            sslVerifyServerCert: "true"
            useClientSSLCompression: "true"
        testme_cacert.pem:
          contents: |
            -----BEGIN CERTIFICATE-----
            MIID2jCCA0MCAg39MA0GCSqGSIb3DQEBBQUAMIGbMQswCQYDVQQGEwJKUDEOMAwG
            A1UECBMFVG9reW8xEDAOBgNVBAcTB0NodW8ta3UxETAPBgNVBAoTCEZyYW5rNERE
            MRgwFgYDVQQLEw9XZWJDZXJ0IFN1cHBvcnQxGDAWBgNVBAMTD0ZyYW5rNEREIFdl
            YiBDQTEjMCEGCSqGSIb3DQEJARYUc3VwcG9ydEBmcmFuazRkZC5jb20wHhcNMTIw
            ODIyMDUyODAwWhcNMTcwODIxMDUyODAwWjBKMQswCQYDVQQGEwJKUDEOMAwGA1UE
            CAwFVG9reW8xETAPBgNVBAoMCEZyYW5rNEREMRgwFgYDVQQDDA93d3cuZXhhbXBs
            ZS5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCwvWITOLeyTbS1
            Q/UacqeILIK16UHLvSymIlbbiT7mpD4SMwB343xpIlXN64fC0Y1ylT6LLeX4St7A
            cJrGIV3AMmJcsDsNzgo577LqtNvnOkLH0GojisFEKQiREX6gOgq9tWSqwaENccTE
            sAXuV6AQ1ST+G16s00iN92hjX9V/V66snRwTsJ/p4WRpLSdAj4272hiM19qIg9zr
            h92e2rQy7E/UShW4gpOrhg2f6fcCBm+aXIga+qxaSLchcDUvPXrpIxTd/OWQ23Qh
            vIEzkGbPlBA8J7Nw9KCyaxbYMBFb1i0lBjwKLjmcoihiI7PVthAOu/B71D2hKcFj
            Kpfv4D1Uam/0VumKwhwuhZVNjLq1BR1FKRJ1CioLG4wCTr0LVgtvvUyhFrS+3PdU
            R0T5HlAQWPMyQDHgCpbOHW0wc0hbuNeO/lS82LjieGNFxKmMBFF9lsN2zsA6Qw32
            Xkb2/EFltXCtpuOwVztdk4MDrnaDXy9zMZuqFHpv5lWTbDVwDdyEQNclYlbAEbDe
            vEQo/rAOZFl94Mu63rAgLiPeZN4IdS/48or5KaQaCOe0DuAb4GWNIQ42cYQ5TsEH
            Wt+FIOAMSpf9hNPjDeu1uff40DOtsiyGeX9NViqKtttaHpvd7rb2zsasbcAGUl+f
            NQJj4qImPSB9ThqZqPTukEcM/NtbeQIDAQABMA0GCSqGSIb3DQEBBQUAA4GBAIAi
            gU3My8kYYniDuKEXSJmbVB+K1upHxWDA8R6KMZGXfbe5BRd8s40cY6JBYL52Tgqd
            l8z5Ek8dC4NNpfpcZc/teT1WqiO2wnpGHjgMDuDL1mxCZNL422jHpiPWkWp3AuDI
            c7tL1QjbfAUHAQYwmHkWgPP+T2wAv0pOt36GgMCM
            -----END CERTIFICATE-----
        testme_server.pem:
          contents: |
            -----BEGIN CERTIFICATE-----
            MIID2jCCA0MCAg39MA0GCSqGSIb3DQEBBQUAMIGbMQswCQYDVQQGEwJKUDEOMAwG
            A1UECBMFVG9reW8xEDAOBgNVBAcTB0NodW8ta3UxETAPBgNVBAoTCEZyYW5rNERE
            MRgwFgYDVQQLEw9XZWJDZXJ0IFN1cHBvcnQxGDAWBgNVBAMTD0ZyYW5rNEREIFdl
            YiBDQTEjMCEGCSqGSIb3DQEJARYUc3VwcG9ydEBmcmFuazRkZC5jb20wHhcNMTIw
            ODIyMDUyODAwWhcNMTcwODIxMDUyODAwWjBKMQswCQYDVQQGEwJKUDEOMAwGA1UE
            CAwFVG9reW8xETAPBgNVBAoMCEZyYW5rNEREMRgwFgYDVQQDDA93d3cuZXhhbXBs
            ZS5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCwvWITOLeyTbS1
            Q/UacqeILIK16UHLvSymIlbbiT7mpD4SMwB343xpIlXN64fC0Y1ylT6LLeX4St7A
            cJrGIV3AMmJcsDsNzgo577LqtNvnOkLH0GojisFEKQiREX6gOgq9tWSqwaENccTE
            sAXuV6AQ1ST+G16s00iN92hjX9V/V66snRwTsJ/p4WRpLSdAj4272hiM19qIg9zr
            h92e2rQy7E/UShW4gpOrhg2f6fcCBm+aXIga+qxaSLchcDUvPXrpIxTd/OWQ23Qh
            vIEzkGbPlBA8J7Nw9KCyaxbYMBFb1i0lBjwKLjmcoihiI7PVthAOu/B71D2hKcFj
            Kpfv4D1Uam/0VumKwhwuhZVNjLq1BR1FKRJ1CioLG4wCTr0LVgtvvUyhFrS+3PdU
            R0T5HlAQWPMyQDHgCpbOHW0wc0hbuNeO/lS82LjieGNFxKmMBFF9lsN2zsA6Qw32
            Xkb2/EFltXCtpuOwVztdk4MDrnaDXy9zMZuqFHpv5lWTbDVwDdyEQNclYlbAEbDe
            vEQo/rAOZFl94Mu63rAgLiPeZN4IdS/48or5KaQaCOe0DuAb4GWNIQ42cYQ5TsEH
            Wt+FIOAMSpf9hNPjDeu1uff40DOtsiyGeX9NViqKtttaHpvd7rb2zsasbcAGUl+f
            NQJj4qImPSB9ThqZqPTukEcM/NtbeQIDAQABMA0GCSqGSIb3DQEBBQUAA4GBAIAi
            gU3My8kYYniDuKEXSJmbVB+K1upHxWDA8R6KMZGXfbe5BRd8s40cY6JBYL52Tgqd
            l8z5Ek8dC4NNpfpcZc/teT1WqiO2wnpGHjgMDuDL1mxCZNL422jHpiPWkWp3AuDI
            c7tL1QjbfAUHAQYwmHkWgPP+T2wAv0pOt36GgMCM
            -----END CERTIFICATE-----
  system:
    inputs:
      monitor:
        mysql-slow-log:
          monitor: /var/log/mysql/mysql-slow.log
          index: database
          sourcetype: mysql_slow
  inputs:
    monitor:
      nginx-access-log:
        monitor: /var/log/nginx/access.log
        index: search
        sourcetype: nginx_access_log
      nginx-error-log:
        monitor: /var/log/nginx/error.log
        index: search
        sourcetype: nginx_error_log
  props:
    mysql_slow:
      pulldown_type: 'true'
      category: 'Database'
      description: 'Mysql Slow Query Logs'
      BREAK_ONLY_BEFORE: '^#\s*User@Host'


splunk:
  secret: changeme
  password:
    outputs.conf: changeme
    inputs.conf: changeme
  self_cert_filename: selfsignedcert.pem
  certs:
    cacert.pem:
      content: |
        -----BEGIN CERTIFICATE-----
        MIIEWTCCA0GgAwIBAgIUCPnxZ0bYO9ssyFF35kcFyuxT+XwwDQYJKoZIhvcNAQEL
        BQAwgbsxCzAJBgNVBAYTAi0tMRIwEAYDVQQIDAlTb21lU3RhdGUxETAPBgNVBAcM
        CFNvbWVDaXR5MRkwFwYDVQQKDBBTb21lT3JnYW5pemF0aW9uMR8wHQYDVQQLDBZT
        b21lT3JnYW5pemF0aW9uYWxVbml0MR4wHAYDVQQDDBVsb2NhbGhvc3QubG9jYWxk
        b21haW4xKTAnBgkqhkiG9w0BCQEWGnJvb3RAbG9jYWxob3N0LmxvY2FsZG9tYWlu
        MB4XDTE5MTEyMDE0MTcyMFoXDTIwMTExOTE0MTcyMFowgbsxCzAJBgNVBAYTAi0t
        MRIwEAYDVQQIDAlTb21lU3RhdGUxETAPBgNVBAcMCFNvbWVDaXR5MRkwFwYDVQQK
        DBBTb21lT3JnYW5pemF0aW9uMR8wHQYDVQQLDBZTb21lT3JnYW5pemF0aW9uYWxV
        bml0MR4wHAYDVQQDDBVsb2NhbGhvc3QubG9jYWxkb21haW4xKTAnBgkqhkiG9w0B
        CQEWGnJvb3RAbG9jYWxob3N0LmxvY2FsZG9tYWluMIIBIjANBgkqhkiG9w0BAQEF
        AAOCAQ8AMIIBCgKCAQEApmTOXOl1h5+eYDevztgvhfo+aZx5feyPw4AWfmibnIY0
        Mw2Z9mA6xLcJZofqMl6p4Rr8VNoIPC8P4u2P1NCot3wOvmRyMu3132ZiscBVQ0fH
        2HopLi9jO7eiuQZOywKQxfUD4LsHSjQ8S746L8YAAOn3ZhToixS5W79EmsbQZ/0J
        PjkCtkr2NgQrYWuOqEkHtNfbp+6rvcag9mwqg3QdcFOcOrv+Hb8qfFddff5GXR7R
        ZvPSMqGxaw00r2xrk/RX8yJnzFf+JUZCP0G8wSv7slTOc+9dYQrX+HJYFhp2wUrx
        Lf3XBy0SCCHM2IR0niakYSVCcexgbxqJgxjrQvwB+QIDAQABo1MwUTAdBgNVHQ4E
        FgQUzQv8bNvKwmLvyTOl7WRYfb+sgj0wHwYDVR0jBBgwFoAUzQv8bNvKwmLvyTOl
        7WRYfb+sgj0wDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAhp/H
        mGvDdRNK9V/mBKEVFezzQ5BUWwrSllHUt0zlkl5JD1eRwEA4HCdfHYr6WkAu55Qx
        z7ywEKLQvqUKTm16mKn41v6JCW1lzNbOaLbfuzi6oUonah8bgjIIgYeTpe5rPnvZ
        NaT3L2cbL6RPxsSAJTXVNbOOhbcYly5KN9LUuZfcN7wduVDN4ucPq+65LNz9afub
        pwtqNpT++1kYWz8P6jThLV2K/TbIDV+VYwK5cug/ZZZKA1+rBTNP+rEO2f0m4K9v
        IxYHKT9+UfcVSUDRevE78BCoKlJe78iBVqx0ZMxjGHjqS2HpJA2+P4g83N2MyF+8
        1IBrfgw/Rn4cBhMBrA==
        -----END CERTIFICATE-----
    selfsignedcert.pem:
      content: |
        -----BEGIN CERTIFICATE-----
        MIIEWTCCA0GgAwIBAgIUCPnxZ0bYO9ssyFF35kcFyuxT+XwwDQYJKoZIhvcNAQEL
        BQAwgbsxCzAJBgNVBAYTAi0tMRIwEAYDVQQIDAlTb21lU3RhdGUxETAPBgNVBAcM
        CFNvbWVDaXR5MRkwFwYDVQQKDBBTb21lT3JnYW5pemF0aW9uMR8wHQYDVQQLDBZT
        b21lT3JnYW5pemF0aW9uYWxVbml0MR4wHAYDVQQDDBVsb2NhbGhvc3QubG9jYWxk
        b21haW4xKTAnBgkqhkiG9w0BCQEWGnJvb3RAbG9jYWxob3N0LmxvY2FsZG9tYWlu
        MB4XDTE5MTEyMDE0MTcyMFoXDTIwMTExOTE0MTcyMFowgbsxCzAJBgNVBAYTAi0t
        MRIwEAYDVQQIDAlTb21lU3RhdGUxETAPBgNVBAcMCFNvbWVDaXR5MRkwFwYDVQQK
        DBBTb21lT3JnYW5pemF0aW9uMR8wHQYDVQQLDBZTb21lT3JnYW5pemF0aW9uYWxV
        bml0MR4wHAYDVQQDDBVsb2NhbGhvc3QubG9jYWxkb21haW4xKTAnBgkqhkiG9w0B
        CQEWGnJvb3RAbG9jYWxob3N0LmxvY2FsZG9tYWluMIIBIjANBgkqhkiG9w0BAQEF
        AAOCAQ8AMIIBCgKCAQEApmTOXOl1h5+eYDevztgvhfo+aZx5feyPw4AWfmibnIY0
        Mw2Z9mA6xLcJZofqMl6p4Rr8VNoIPC8P4u2P1NCot3wOvmRyMu3132ZiscBVQ0fH
        2HopLi9jO7eiuQZOywKQxfUD4LsHSjQ8S746L8YAAOn3ZhToixS5W79EmsbQZ/0J
        PjkCtkr2NgQrYWuOqEkHtNfbp+6rvcag9mwqg3QdcFOcOrv+Hb8qfFddff5GXR7R
        ZvPSMqGxaw00r2xrk/RX8yJnzFf+JUZCP0G8wSv7slTOc+9dYQrX+HJYFhp2wUrx
        Lf3XBy0SCCHM2IR0niakYSVCcexgbxqJgxjrQvwB+QIDAQABo1MwUTAdBgNVHQ4E
        FgQUzQv8bNvKwmLvyTOl7WRYfb+sgj0wHwYDVR0jBBgwFoAUzQv8bNvKwmLvyTOl
        7WRYfb+sgj0wDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAhp/H
        mGvDdRNK9V/mBKEVFezzQ5BUWwrSllHUt0zlkl5JD1eRwEA4HCdfHYr6WkAu55Qx
        z7ywEKLQvqUKTm16mKn41v6JCW1lzNbOaLbfuzi6oUonah8bgjIIgYeTpe5rPnvZ
        NaT3L2cbL6RPxsSAJTXVNbOOhbcYly5KN9LUuZfcN7wduVDN4ucPq+65LNz9afub
        pwtqNpT++1kYWz8P6jThLV2K/TbIDV+VYwK5cug/ZZZKA1+rBTNP+rEO2f0m4K9v
        IxYHKT9+UfcVSUDRevE78BCoKlJe78iBVqx0ZMxjGHjqS2HpJA2+P4g83N2MyF+8
        1IBrfgw/Rn4cBhMBrA==
        -----END CERTIFICATE-----
