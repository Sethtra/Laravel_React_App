// lib/screens/paypal_webview_screen.dart
import 'dart:collection'; // For UnmodifiableListView
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// --- IMPORTANT: DEFINE THESE ACCURATELY ---
// For Android Emulator testing with backend on localhost:8000
const String yourBackendBaseUrl = "http://10.0.2.2:8000";
// For Physical Device testing (replace 192.168.X.X with your computer's local IP)
// const String yourBackendBaseUrl = "http://192.168.X.X:8000";

const String YOUR_BACKEND_CREATE_ORDER_URL =
    "$yourBackendBaseUrl/api/paypal/create-order";
const String YOUR_BACKEND_CAPTURE_ORDER_URL =
    "$yourBackendBaseUrl/api/paypal/capture-order";

// Your PayPal SANDBOX Client ID
const String PAYPAL_SANDBOX_CLIENT_ID =
    "AVzh1tSTB34dDrw9ptzOd1OX0jP7M9KSDBstfLP_wAhfyviPZOG1L8sg_TS5DaxehUaiqk1Ar0mHTOrS";
// --- END IMPORTANT DEFINITIONS ---

class PaypalWebViewScreen extends StatefulWidget {
  final double totalAmount;
  final String currency;
  final Function(String orderId, String? payerId, String? paymentId) onSuccess;
  final Function(dynamic error) onError;
  final Function() onCancel;

  const PaypalWebViewScreen({
    super.key,
    required this.totalAmount,
    this.currency = "USD",
    required this.onSuccess,
    required this.onError,
    required this.onCancel,
  });

  @override
  State<PaypalWebViewScreen> createState() => _PaypalWebViewScreenState();
}

class _PaypalWebViewScreenState extends State<PaypalWebViewScreen> {
  InAppWebViewController? _webViewController;
  double _progress = 0;
  bool _isLoading = true;

  String get _paypalHtml => """
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
      <title>PayPal Checkout</title>
      <script src="https://www.paypal.com/sdk/js?client-id=$PAYPAL_SANDBOX_CLIENT_ID&currency=${widget.currency}&disable-funding=card,credit&commit=true"></script>
      <style>
          body { display: flex; flex-direction: column; justify-content: center; align-items: center; height: 100vh; margin: 0; background-color: #fff; font-family: sans-serif; }
          #paypal-button-container { width: 90%; max-width: 400px; text-align: center; }
          .loader-container { display: flex; justify-content: center; align-items: center; height: 100%; width: 100%; position: absolute; top: 0; left: 0; background-color: rgba(255,255,255,0.8); z-index: 10; }
          .loader { border: 6px solid #f3f3f3; border-top: 6px solid #3498db; border-radius: 50%; width: 50px; height: 50px; animation: spin 1s linear infinite; }
          @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
          #messages { margin-top: 20px; color: #555; }
      </style>
  </head>
  <body>
      <div id="loader-container" class="loader-container" style="display: none;"><div class="loader"></div></div>
      <div id="messages">Loading PayPal...</div>
      <div id="paypal-button-container"></div>
      <script>
          function showLoader(show) {
              document.getElementById('loader-container').style.display = show ? 'flex' : 'none';
              document.getElementById('paypal-button-container').style.display = show ? 'none' : 'block';
              document.getElementById('messages').innerText = show ? 'Processing...' : '';
          }

          paypal.Buttons({
              createOrder: function(data, actions) {
                  showLoader(true);
                  document.getElementById('messages').innerText = 'Contacting server to create order...';
                  return fetch('$YOUR_BACKEND_CREATE_ORDER_URL', {
                      method: 'POST',
                      headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                      body: JSON.stringify({
                          amount: '${widget.totalAmount.toStringAsFixed(2)}', // Ensure string format for amount
                          currency: '${widget.currency}',
                      })
                  })
                  .then(res => {
                      if (!res.ok) {
                          return res.json().then(errText => { throw new Error(JSON.stringify(errText.errors || errText.message || errText)); });
                      }
                      return res.json();
                  })
                  .then(orderData => {
                      if (orderData && orderData.id) {
                          console.log('Order created by backend:', orderData.id);
                          document.getElementById('messages').innerText = 'Order created. Redirecting to PayPal...';
                          // showLoader(false); // PayPal SDK handles its own loader from here
                          return orderData.id;
                      } else {
                          throw new Error('Backend did not return a valid order ID.');
                      }
                  })
                  .catch(err => {
                      console.error('Error creating order with backend:', err);
                      showLoader(false);
                      document.getElementById('messages').innerText = 'Error: ' + (err.message || 'Could not create order.');
                      if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
                          window.flutter_inappwebview.callHandler('paypalOnError', err.message || 'Failed to create order with backend.');
                      }
                      return null; // Must return null or reject promise to stop PayPal flow
                  });
              },
              onApprove: function(data, actions) {
                  showLoader(true);
                  document.getElementById('messages').innerText = 'Payment approved. Finalizing...';
                  console.log('Payment approved by user:', data);
                  if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
                      window.flutter_inappwebview.callHandler('paypalOnSuccess', data.orderID, data.payerID, data.paymentID);
                  }
              },
              onError: function(err) {
                  console.error('PayPal SDK onError:', err);
                  showLoader(false);
                  document.getElementById('messages').innerText = 'Error: ' + (err.message || 'An error occurred with PayPal.');
                  if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
                      window.flutter_inappwebview.callHandler('paypalOnError', err.message || 'An error occurred with PayPal.');
                  }
              },
              onCancel: function(data) {
                  console.log('Payment cancelled by user:', data);
                  if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
                      window.flutter_inappwebview.callHandler('paypalOnCancel', data.orderID);
                  }
              }
          }).render('#paypal-button-container')
          .then(() => {
              showLoader(false);
              document.getElementById('messages').innerText = 'Please complete your payment.';
              console.log('PayPal Buttons rendered.');
          })
          .catch(err => {
              console.error('Error rendering PayPal buttons:', err);
              showLoader(false);
              document.getElementById('messages').innerText = 'Error: Could not load PayPal buttons.';
              if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
                  window.flutter_inappwebview.callHandler('paypalOnError', 'Failed to render PayPal buttons.');
              }
          });
      </script>
  </body>
  </html>
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Payment"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.onCancel();
          },
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialData: InAppWebViewInitialData(data: _paypalHtml),
            initialUserScripts: UnmodifiableListView<UserScript>([]),
            onWebViewCreated: (controller) {
              _webViewController = controller;

              controller.addJavaScriptHandler(
                handlerName: 'paypalOnSuccess',
                callback: (args) {
                  print("Flutter JSHandler paypalOnSuccess: $args");
                  if (args.isNotEmpty && args[0] != null) {
                    widget.onSuccess(
                      args[0],
                      args.length > 1 ? args[1] : null,
                      args.length > 2 ? args[2] : null,
                    );
                  } else {
                    widget.onError("Invalid success data from PayPal.");
                  }
                },
              );

              controller.addJavaScriptHandler(
                handlerName: 'paypalOnError',
                callback: (args) {
                  print("Flutter JSHandler paypalOnError: $args");
                  widget.onError(
                    args.isNotEmpty ? args[0] : "Unknown PayPal WebView error.",
                  );
                },
              );

              controller.addJavaScriptHandler(
                handlerName: 'paypalOnCancel',
                callback: (args) {
                  print("Flutter JSHandler paypalOnCancel: $args");
                  widget.onCancel();
                },
              );
            },
            onLoadStart: (controller, url) {
              print("WebView onLoadStart: $url");
              setState(() {
                _isLoading = true;
                _progress = 0;
              });
            },
            onLoadStop: (controller, url) async {
              print("WebView onLoadStop: $url");
              setState(() {
                _isLoading = false;
              });
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
            onReceivedError: (controller, request, error) {
              print(
                "WebView onReceivedError: ${request.url}, code: ${error.type}, message: ${error.description}",
              );
              setState(() {
                _isLoading = false;
              });
              widget.onError(
                "WebView Error: ${error.description} (URL: ${request.url})",
              );
            },
            onConsoleMessage: (controller, consoleMessage) {
              print(
                "JS Console: [${consoleMessage.messageLevel}] ${consoleMessage.message}",
              );
            },
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (_progress < 1.0 &&
              _progress > 0.0 &&
              !_isLoading) // Show progress bar only during initial load phase
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(value: _progress),
            ),
        ],
      ),
    );
  }
}
