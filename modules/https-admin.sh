#!/bin/bash
# https-admin.sh - ServerSetup Module
# 
# adds admin console accessed via https
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>
#

#HD=$(ask "HD" "/dev/sda1")


# install lighttpd
apt-get install lighttpd php5-cgi

# create key
HOST=$(ask "Domain Name OR IP Address" "[panda-server.eu]")
mkdir -p /etc/lighttpd/ssl/$HOST
pushd /etc/lighttpd/ssl/$HOST
openssl genrsa -des3 -out $HOST.key 1024
openssl req -new -key $HOST.key -out $HOST.csr
openssl x509 -req -days 365 -in $HOST.csr -signkey $HOST.key -out $HOST.crt
cat $HOST.key $HOST.crt > $HOST.pem
chmod 0600 $HOST.pem 
popd

# open https port
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# add to lighttpd.conf
echo "
server.modules = (                                                                                                                                                                                   
        "mod_access",
        "mod_alias",
        "mod_compress",
        "mod_redirect",
        "mod_fastcgi",
        "mod_rewrite",
        "mod_proxy"
)
 
server.document-root        = "/var/www"
server.upload-dirs          = ( "/var/cache/lighttpd/uploads" )
server.errorlog             = "/var/log/lighttpd/error.log"
server.pid-file             = "/var/run/lighttpd.pid"
server.username             = "www-data"
server.groupname            = "www-data"
 
index-file.names            = ( "index.php", "index.html",
                                "index.htm", "default.htm",
                               " index.lighttpd.html" )
 
fastcgi.server = ( ".php" => ((  
                     "bin-path" => "/usr/bin/php5-cgi",
                     "socket" => "/tmp/php.socket" 
                 ))) 
 
url.access-deny             = ( "~", ".inc" )
 
static-file.exclude-extensions = ( ".php", ".pl", ".fcgi" )
 
## Use ipv6 if available
#include_shell "/usr/share/lighttpd/use-ipv6.pl"
 
dir-listing.encoding        = "utf-8"
server.dir-listing          = "enable"
 
compress.cache-dir          = "/var/cache/lighttpd/compress/"
compress.filetype           = ( "application/x-javascript", "text/css", "text/html", "text/plain" )
 
include_shell "/usr/share/lighttpd/create-mime.assign.pl"
include_shell "/usr/share/lighttpd/include-conf-enabled.pl"

# setup https, and proxy for transmission etc 
\$SERVER["socket"] == "$HOST:443" {
        ssl.engine = "enable"
        ssl.pemfile = "/etc/lighttpd/ssl/$HOST/$HOST.pem"
        ssl.ca-file = "/etc/lighttpd/ssl/$HOST/$HOST.crt"
        server.name = "$HOST"
        server.document-root = "/var/www/$HOST"
        server.errorlog = "/var/log/lighttpd/$HOST/serror.log"
        accesslog.filename = "/var/log/lighttpd/$HOST/saccess.log"
}
 
 
# transmission proxy
$HTTP["host"] == "transmission.$HOST:443" {
        proxy.server = ("" => (("host"=>"127.0.0.1","port"=>9091)))
}
" > /etc/lighttpd/lighttpd.conf
# setup www, log dirs
mkdir -p /var/log/lighttpd/$HOST/
chmod -R 777 /var/log/lighttpd
mkdir -p /var/www/$HOST/

# start lighttpd
service lighttpd restart
