<?php
return [
    'client_id' => env('PAYPAL_CLIENT_ID'),
    'secret' => env('PAYPAL_SECRET'),
    'settings' => [
        'mode' => env('PAYPAL_MODE', 'sandbox'), // or 'live' for production
        'http.ConnectionTimeOut' => 30,
        'log.LogEnabled' => true,
        'log.LogFileName' => storage_path('logs/paypal.log'),
        'log.LogLevel' => 'FINE',
    ],
];
