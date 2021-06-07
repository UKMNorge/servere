<?php

/**
 * Tar i mot opdateringer fra github
 * 
 * Plasseres som /home/[cpanel_konto_navn]/public_html/githook/index.php
 * 
 * I tillegg må du legge inn /home/[cpanel_konto_navn]/private_shell/github-pull.sh
 */

error_reporting(E_ALL);

define('HOMEDIR', dirname(__FILE__,3),'/');

set_error_handler("warning_handler", E_WARNING);

function warning_handler($errno, $errstr) {
    if(!headers_sent()) {
        header("HTTP/1.0 500 Internal server error");
    }
    echo $errstr . "\r\n" ;
}

// CHECK FOR PAYLOAD
if(!isset($_POST['payload'])) {
	header("HTTP/1.0 400 Missing payload");
	die('No payload');
}

$payload = json_decode( $_POST['payload'] );
$repo = $payload->repository->name;

// CHECK PAYLOAD REPO NAME
if(empty($repo)) {
    header("HTTP/1.0 400 Invalid payload");
	die('Invalid payload');
}

// TEST CALLABLE
if(!is_callable('shell_exec')) {
    warning_handler(0,'Cannot run shell');
    die(); // without message, because warning_handler outputs
}

// EXECUTE
$exec = HOMEDIR . "private_shell/github-pull.sh ". HOMEDIR . "public_html/ 2>&1";
$output = shell_exec($exec);

// OUTPUT
if(empty($output)) {
    error_log('GITHUB: '. $exec);
    warning_handler(0,'Empty shell output - error fetching repo');
    die(); // without message, because warning_handler outputs
} else {
    echo 'EXEC GIT FETCH AND RESET: '. "\r\n";
    echo($output);
}
