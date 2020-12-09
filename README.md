splunkforwarder Salt Formula
========================

Install the [Splunk Universal Forwarder](http://www.splunk.com/download/universalforwarder)
to forward your logs to Splunk.

See the full [Salt Formulas installation and usage instructions](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html)


## Available states

- [splunkforwarder](#splunkforwarder)
- [splunkforwarder.certs](#splunkforwarder-certs)
- [splunkforwarder.forwarder](#splunkforwarder-forwarder)
- [splunkforwarder.intermediate-forwarder](#splunkforwarder-intermediate-forwarder)
- [splunkforwarder.secret](#splunkforwarder-secret)


### splunkforwarder

Install Splunk Universal Forwarder and all its dependencies, then start the service.

If you configured [splunkforwarder:intermediate](#splunkforwarderintermediate) = True,
this includes the
[splunkforwarder.intermediate-forwarder](#splunkforwarder-intermediate-forwarder)
recipe.

### splunkforwarder.certs

Install SSL certificates.

### splunkforwarder.forwarder

Install Splunk Unversal Forwarder and start the service.

### splunkforwarder.intermediate-forwarder

Configure Splunk Universal Forwarder to be an intermediate forwarder.
E.g. it accepts forwarded logs from other servers and forwards them further upstream.

### splunkforwarder.secret

Install shared Splunk secret.


Configuration
=============

## Splunk Forwarder Required Pillar Items

### splunkforwarder:version

What version of Splunk Universal Forwarder are you installing?

Example:

```yaml
splunkforwarder:
  version: 6.2.0
```

### splunkforwarder:package_filename

The name of the package you are installing.

Example:

```yaml
splunkforwarder:
  package_filename: splunkforwarder-6.2.0-237341-linux-2.6-amd64.deb
```

### splunkforwarder:source_hash

The checksum of the file you're installing.

Example:

```yaml
splunkforwarder:
  source_hash: sha256=xxxxxx
```

### splunkforwarder:download_base_url

**This URL must contain a trailing slash.**

Splunk does not make their packages available for public download.  You must login to your Splunk account,
download the package you want, and put it on your own HTTP/FTP/S3/whatever server for your machines to
access.

This is the base URL where you put the images.

Example:

```yaml
splunkforwarder:
  download_base_url: http://your.domain.com/downloads/
```

### splunkforwarder:forward_servers (List)

This is a list of servers to forward to.  Splunk will treat these like a round-robin and will forward
to all of the servers in the list.  If/when one goes down the others will get the traffic.

Example:

```yaml
splunkforwarder:
  forward_servers:
    - 1.2.3.4:9998
    - 1.2.4.5:9998
```

*NOTE*: Mutually exclusive with `splunkcloud`

At least 1 server is required, presumably you can configure as many as you like.

## SplunkCloud

If you want to use splunkcloud as the destinatio host, there is a whole dict for configuring similar to what you'll get from the `.spl` package from your splunkcloud instance.

### splunkforwarder:splunkcloud (Dict)

This is the dict used for configuring splunkcloud.

### splunkforwarder:splunkcloud:enabled (Bool)

Set to `True` to enable splunkcloud.

### splunkforwarder:splunkcloud:instance (str)

Your instance name.

Example:
```yaml
splunkforwarder:
  splunkcloud:
    instance: myinstance
```

### splunkforwarder:splunkcloud:config (Dict)

This is where we hold the configuration for the instance. Required items are the certificates, the `sslPassword`, and servers.
Keys are: first, the directory where to store the config, then the filename. Lastly, the contents. If you want to store certificates, just use the `contents` as you normally do.
If you want to add the configuration as ini file, first key is the section name, and afterwards just add the list with key/value pairs representing the content in that section.

Example:
```yaml
splunkforwarder:
  splunkcloud:
    config:
      local:
        outputs.conf:
          "tcpout:splunkcloud":
            # this is the password that would decrypt the private key in the certificate
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
            compressed: '"false"'
            sslCertPath: '"$SPLUNK_HOME/etc/apps/100_testme_splunkcloud/default/testme_server.pem"'
            sslRootCAPath: '"$SPLUNK_HOME/etc/apps/100_testme_splunkcloud/default/testme_cacert.pem"'
            sslCommonNameToCheck: "*.testme.splunkcloud.com"
            sslVerifyServerCert: '"true"'
            useClientSSLCompression: '"true"'
        testme_cacert.pem:
          contents: |
            -----BEGIN CERTIFICATE-----
            ...
        testme_server.pem:
          contents: |
            -----BEGIN CERTIFICATE-----
            ...
```

### splunkforwarder:inputs:monitor (Dict)

This is a dictionary containing all of the files you want to monitor.  The name of the dictionary
is not used other than to guarantee uniqueness of each entry (a Salt constraint).

There is 1 required entry in each, `monitor` which is used in Splunk's `inputs.conf` monitor stanza.
Here again this should be unique and it can contain any characters that Splunk will accept as a
monitoring stanza.

Monitors can be added also to the *system* local inputs.conf by using the same syntax but using
the `splunkforwarder:system:inputs:monitor` dict.

Any additional entries are added directly to the `[monitor]` stanza in Splunk.

Example:

```yaml
splunkforwarder:
  inputs:
    monitor:
      nginx-error-log:
        monitor: /var/log/nginx/error.log
        index: search
        sourcetype: nginx_error_log
```

Resulting Splunk `inputs.conf` stanza:

```INI
[monitor:///var/log/nginx/error.log]
index = search
sourcetype = nginx_error_log
```

### splunkforwarder:props (Dict)

This is a dictionary containing additional properties. Each sublevel will create a new section,
and every property will be added to that section.

Example:

```yaml
splunkforwarder:
  props:
    mysql_slow:
      pulldown_type: 'true'
      category: 'Database'
      description: 'Mysql Slow Query Logs'
      BREAK_ONLY_BEFORE: '^#\s*User@Host'

```

Resulting Splunk `props.conf` stanza:

```INI
[mysql_slow]
pulldown_type = true
category = Database
description = Mysql Slow Query Logs
BREAK_ONLY_BEFORE = ^#\s*User@Host
```


### splunkforwarder:server (Dict)

This is a dictionary containing configuration for the server. Each level below `server` will be a config section in the `server.conf` file:

```yaml
splunkforwarder:
  server:
    httpServer:
      acceptFrom: "127.0.0.1"
```

Resulting Splunk `server.conf` stanza:

```INI
[httpServer]
acceptFrom = "127.0.0.1"
```

## Splunk Forwarder Optional Pillar Items

### splunkforwarder:intermediate

Default = False

Set it to True if you want this machine to accept incoming
connections from other Splunk forwarders to be forwarded on upstream.


## Splunk Required Pillar Items

### splunk:secret

This is a shared secret across all your splunk forwarders.  It allows for the
password encryption to yield the same result across your servers, so you can
store your password encrypted in your pillar.

### splunk:password:inputs.conf

Your Splunk password.  If you know the encrypted version, use it.

If you don't know the encrypted version, put it in plain text.  See the section
[figuring out your encrypted passwords](#figuring-out-your-encrypted-passwords)
below to see how to determine what your encrypted password is.

### splunk:password:outputs.conf

Your Splunk password.  If you know the encrypted version, use it.

If you don't know the encrypted version, put it in plain text.  See the section
[figuring out your encrypted passwords](#figuring-out-your-encrypted-passwords)
below to see how to determine what your encrypted password is.

### splunk:certs (Dict)

Each of the SSL certificates you need to install.

Example:

```yaml
splunk:
  certs:
    cacert.pem:
      content: |
        -----BEGIN CERTIFICATE-----
        xxxxxxYourCertificateHerexxxxxx
        -----END CERTIFICATE-----
    selfsignedcert.pem:
      content: |
        -----BEGIN CERTIFICATE-----
        xxxxxxYourCertificateHerexxxxxx
        -----END CERTIFICATE-----
```

Note that you don't have to use a `selfsignedcert.pem`, you can use a real cert
if you have one.  In that case you must configure
[splunk:self_cert_filename](splunkself_cert_filename) to match the name of the
cert you added here in lieu of selfsignedcert.pem.


## Splunk Optional Pillar Items

### splunk:self_cert_filename

Default = `selfsignedcert.pem`

Name of the SSL cert used by the current machine to talk to other machines.
If you have real certs, replace this with the name of your cert.

NOTE: The cert named here MUST exist in splunk:certs:{{name}}:content so
we can install that cert on the Splunk server.  Either that, or you must
manually install it into `/opt/splunkforwarder/etc/certs/{{name}}` before
you try installing `splunkforwarder`.


## Figuring out your encrypted passwords

The trickiest part of the configuration is dealing with the encrypted passwords.
Splunk doesn't publicize its salt method so it's not possible to know what the
encrypted passwords will be without letting Splunk do the encryption itself.

Thus it's a 3 step process:

1) Enter plain text passwords in your pillars for `splunk:password:inputs.conf`
and for `splunk:password:outputs.conf`

2) `salt-call state.sls splunkforwarder`

3) On the system you just installed Splunk onto, inspect these files:

- `/opt/splunkforwarder/etc/system/local/inputs.conf`
  - copy the encrypted value of `password` into the `splunk:password:inputs.conf` pillar
- `/opt/splunkforwarder/etc/system/local/outputs.conf`
  - copy the encrypted value of `sslPassword` into the `splunk:password:outputs.conf` pillar

Now you have the encrypted value stored in your pillar instead of the plain
text.  For this to work, the same `splunk:secret` must be shared across all machines
using these encrypted passwords.

Note: The same exact password will have 2 different encrypted values, one for
inputs.conf and one for outputs.conf.  Presumably the name of the file that it
gets written to is part of the encryption.
