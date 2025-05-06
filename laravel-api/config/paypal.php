<?php
// config/paypal.php
return [
    'mode'    => env('PAYPAL_MODE', 'sandbox'), // Reads the .env variable named PAYPAL_MODE
    'sandbox' => [
        'client_id'         => env('PAYPAL_SANDBOX_CLIENT_ID', ''), // CORRECT: Reads .env variable PAYPAL_SANDBOX_CLIENT_ID
        'client_secret'     => env('PAYPAL_SANDBOX_SECRET', ''),  // CORRECT: Reads .env variable PAYPAL_SANDBOX_SECRET
        'app_id'            => env('PAYPAL_SANDBOX_APP_ID', 'APP-80W284485P519543T'), // It's good practice to make app_id configurable too
    ],
    'live' => [
        'client_id'         => env('PAYPAL_LIVE_CLIENT_ID', ''),
        'client_secret'     => env('PAYPAL_LIVE_SECRET', ''),
        'app_id'            => env('PAYPAL_LIVE_APP_ID', ''),
    ],
    'payment_action' => env('PAYPAL_PAYMENT_ACTION', 'Sale'), // 'Sale', 'Order', or 'Authorization'
    'currency'       => env('PAYPAL_CURRENCY', 'USD'),
    'settings'       => [ // Common settings array for srmklive/paypal
        'mode'                   => env('PAYPAL_MODE', 'sandbox'),
        'http.ConnectionTimeOut' => 30,
        'log.LogEnabled'         => true,
        'log.FileName'           => storage_path() . '/logs/paypal.log',
        'log.LogLevel'           => 'DEBUG', // Or 'INFO', 'ERROR'
    ],
];
