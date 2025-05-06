<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log; // <<<< ENSURE THIS LINE USES BACKSLASHES
use Srmklive\PayPal\Services\PayPal as PayPalClient;

class PaypalController extends Controller
{
    public function createOrder(Request $request)
    {
        $validatedData = $request->validate([
            'amount' => 'required|numeric|min:0.01',
            'currency' => 'required|string|size:3',
        ]);

        $amountValue = $validatedData['amount'];
        $currencyCode = strtoupper($validatedData['currency']);

        $provider = new PayPalClient;

        try {
            $tokenData = $provider->getAccessToken();
            Log::info('PayPal Access Token Request Attempted. Response:', (array)$tokenData);

            if (!isset($tokenData['access_token']) || empty($tokenData['access_token'])) {
                Log::error('Failed to obtain PayPal Access Token.', ['token_response' => $tokenData]);
                return response()->json(['error' => 'Failed to authenticate with PayPal. Could not obtain access token.'], 500);
            }

            $orderData = [
                "intent" => "CAPTURE",
                "purchase_units" => [
                    [
                        "amount" => [
                            "currency_code" => $currencyCode,
                            "value" => $amountValue
                        ],
                    ]
                ],
            ];

            Log::info('Attempting to create PayPal order with data:', $orderData);
            $order = $provider->createOrder($orderData);
            Log::info('PayPal createOrder API response:', (array)$order);

            if (isset($order['id']) && $order['id'] != null) {
                return response()->json(['id' => $order['id']]);
            } else {
                $errorMessage = 'Failed to create PayPal order. No ID returned by PayPal.';
                if (isset($order['message'])) {
                    $errorMessage = $order['message'];
                } elseif (isset($order['error']['message'])) {
                    $errorMessage = $order['error']['message'];
                } elseif (!empty($order['details']) && isset($order['details'][0]['description'])) {
                    $errorMessage = $order['details'][0]['description'];
                }
                Log::error('PayPal Create Order Error: ' . $errorMessage, ['paypal_response' => $order]);
                return response()->json(['error' => $errorMessage, 'details' => $order], 500);
            }
        } catch (\Throwable $e) {
            Log::error('PayPal Create Order Exception: ' . $e->getMessage(), [
                'exception_message' => $e->getMessage(),
                'exception_trace' => $e->getTraceAsString(),
                'request_data' => $request->all()
            ]);
            return response()->json(['error' => 'Server error while creating PayPal order: ' . $e->getMessage()], 500);
        }
    }

    public function captureOrder(Request $request)
    {
        $validatedData = $request->validate([
            'orderID' => 'required|string',
        ]);

        $orderID = $validatedData['orderID'];
        $provider = new PayPalClient;

        try {
            $tokenData = $provider->getAccessToken();
            Log::info('PayPal Access Token for Capture Attempted. Response:', (array)$tokenData);

            if (!isset($tokenData['access_token']) || empty($tokenData['access_token'])) {
                Log::error('Failed to obtain PayPal Access Token for capture.', ['token_response' => $tokenData]);
                return response()->json(['error' => 'Failed to authenticate with PayPal for capture.'], 500);
            }

            Log::info('Attempting to capture PayPal order:', ['orderID' => $orderID]);
            $result = $provider->capturePaymentOrder($orderID);
            Log::info('PayPal capturePaymentOrder API response:', (array)$result);

            if (isset($result['status']) && $result['status'] == 'COMPLETED') {
                return response()->json([
                    'status' => 'COMPLETED',
                    'message' => 'Payment captured successfully!',
                    'paypal_capture_id' => $result['id'] ?? ($result['purchase_units'][0]['payments']['captures'][0]['id'] ?? null),
                    'details' => $result
                ]);
            } else {
                $errorMessage = 'Failed to capture PayPal payment.';
                if (isset($result['message'])) {
                    $errorMessage = $result['message'];
                } elseif (isset($result['error']['message'])) {
                    $errorMessage = $result['error']['message'];
                } elseif (!empty($result['details']) && isset($result['details'][0]['description'])) {
                    $errorMessage = $result['details'][0]['description'];
                }
                Log::error('PayPal Capture Order Error: ' . $errorMessage, ['paypal_response' => $result]);
                $statusCode = isset($result['name']) && $result['name'] == 'UNPROCESSABLE_ENTITY' ? 422 : (isset($result['statusCode']) ? $result['statusCode'] : 400);
                return response()->json(['error' => $errorMessage, 'details' => $result], $statusCode);
            }
        } catch (\Throwable $e) {
            Log::error('PayPal Capture Order Exception: ' . $e->getMessage(), [
                'exception_message' => $e->getMessage(),
                'exception_trace' => $e->getTraceAsString(),
                'orderID' => $orderID
            ]);
            return response()->json(['error' => 'Server error while capturing PayPal payment: ' . $e->getMessage()], 500);
        }
    }
}
