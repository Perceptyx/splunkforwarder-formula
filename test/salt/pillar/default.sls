splunkforwarder:
  # It's recommended to limit to localhost connections in management port 8089
  server:
    httpServer:
      acceptFrom: "127.0.0.1"

  cert_filename: selfsignedcert.pem
  intermediate: True
  forward_servers:
    - 1.2.3.4:9998
    - 1.2.4.5:9998
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
