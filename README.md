# tls-info

Sample app to print client certificate from warp-tls request handler.

```
# Create self-signed server certificate for localhost.

bash sh.sh cert_server

# Create client certificate with some common name:

bash sh.sh cert_client some_common_name

```

Add the cert_client_some_common_name.pfx to your browser's client
certificates. (In Firefox: Hamburger -> Preferences -> Privacy &
Security -> [scroll down] -> View Certificates.. -> Your Certificates
-> Import...)

Then `stack run` the project and visit the file in incognito mode
(otherwise it will remember the client-cert-to-send choice).
