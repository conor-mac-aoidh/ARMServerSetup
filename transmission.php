<?php

/**
 * transmission.php
 *
 * reads a transmission-daemon settings.json file from stdin,
 * parses it and applies standard arguments to stdout
 */

$settings = json_decode( file_get_contents( "php://stdin" ), true );

$settings[ 'rpc-username' ] = $argv[ 1 ];
$settings[ 'rpc-password' ] = $argv[ 2 ];
$settings[ 'download-dir' ] = $argv[ 3 ];
$settings[ 'rpc-whitelist' ] = '192.168.1.*';

file_put_contents( "/etc/transmission-daemon/settings.json", json_encode( $settings ), true );
