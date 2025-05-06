import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For CartProvider
import 'dart:convert'; // For jsonEncode/Decode
import 'package:http/http.dart' as http; // For backend calls

// Import your screens and providers
import 'paypal_webview_screen.dart';
import '../providers/cart_provider.dart';

// Define or import your color constants
const Color appGreen = Color(0xFF4CAF50);
const Color lightGreenBackground = Color(0xFFE8F5E9);
const Color lightGreyBorder = Color(0xFFE0E0E0);
const Color appDarkText = Color(0xFF333333);
const Color appLightText = Color(0xFF757575);
const Color appAccentRed = Color(0xFFFF6B6B); // For consistency if used

// --- IMPORTANT: DEFINE THIS ACCURATELY ---
// This should match the one in PaypalWebViewScreen.dart if it's the same base
const String yourBackendBaseUrlForCheckout =
    "http://10.0.2.2:8000"; // For emulator
// For Physical Device testing (replace 192.168.X.X with your computer's local IP)
// const String yourBackendBaseUrlForCheckout = "http://192.168.X.X:8000";

const String YOUR_BACKEND_CAPTURE_ORDER_URL_CHECKOUT =
    "$yourBackendBaseUrlForCheckout/api/paypal/capture-order";
// --- END IMPORTANT DEFINITIONS ---

// --- Models (defined here for simplicity in this example) ---
// It's better to have these in separate files in lib/models/
class DeliveryAddress {
  final String id;
  final String type;
  final String phoneNumber;
  final String addressLine;
  bool isSelected;

  DeliveryAddress({
    required this.id,
    required this.type,
    required this.phoneNumber,
    required this.addressLine,
    this.isSelected = false,
  });
}

enum PaymentMethodType { mastercard, paypal, cashOnDelivery }

class PaymentMethod {
  final PaymentMethodType type;
  final String name;
  final String iconAsset;
  bool isSelected;

  PaymentMethod({
    required this.type,
    required this.name,
    required this.iconAsset,
    this.isSelected = false,
  });
}
// --- End Models ---

class CheckoutPage extends StatefulWidget {
  static const routeName = '/checkout';

  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final List<DeliveryAddress> _deliveryAddresses = [
    DeliveryAddress(
      id: 'addr1',
      type: 'Home Address',
      phoneNumber: '(309) 071-9396-939',
      addressLine: '1349 Custom Road, Chhatak',
      isSelected: true,
    ),
    DeliveryAddress(
      id: 'addr2',
      type: 'Office Address',
      phoneNumber: '(309) 071-9396-939',
      addressLine: '152 Nobab Road, Sylhet',
    ),
  ];

  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      type: PaymentMethodType.mastercard,
      name: 'Master Card',
      iconAsset: 'assets/icons/mastercard_logo.png',
      isSelected: true,
    ),
    PaymentMethod(
      type: PaymentMethodType.paypal,
      name: 'PayPal',
      iconAsset: 'assets/icons/paypal_logo.png',
    ),
    PaymentMethod(
      type: PaymentMethodType.cashOnDelivery,
      name: 'Cash On Delivery',
      iconAsset: 'assets/icons/cash_logo.png',
    ),
  ];

  String? _selectedAddressId;
  PaymentMethodType? _selectedPaymentMethodType;
  bool _rememberCardDetails = true;
  bool _isProcessingPayment = false; // To show loading indicator

  final _cardNameController = TextEditingController(text: "Ronald Richards");
  final _cardNumberController = TextEditingController(
    text: "3039 8207 **** ****",
  );
  final _expiryDateController = TextEditingController(text: "05/09/2021");
  final _cvvController = TextEditingController(text: "5658");

  @override
  void initState() {
    super.initState();
    if (_deliveryAddresses.isNotEmpty) {
      final defaultSelected = _deliveryAddresses.firstWhere(
        (addr) => addr.isSelected,
        orElse: () => _deliveryAddresses.first,
      );
      _selectedAddressId = defaultSelected.id;
      defaultSelected.isSelected = true; // Ensure it's marked
    }
    if (_paymentMethods.isNotEmpty) {
      final defaultSelectedPM = _paymentMethods.firstWhere(
        (pm) => pm.isSelected,
        orElse: () => _paymentMethods.first,
      );
      _selectedPaymentMethodType = defaultSelectedPM.type;
      defaultSelectedPM.isSelected = true; // Ensure it's marked
    }
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onAddTapped}) {
    /* ... same as before ... */
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appDarkText,
            ),
          ),
          if (onAddTapped != null)
            TextButton(
              onPressed: onAddTapped,
              child: const Text(
                'Add New',
                style: TextStyle(color: appGreen, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(DeliveryAddress address) {
    /* ... same as before ... */
    bool isSelected = address.id == _selectedAddressId;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAddressId = address.id;
          for (var addr in _deliveryAddresses) {
            addr.isSelected = (addr.id == address.id);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? lightGreenBackground : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? appGreen : lightGreyBorder,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? appGreen : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.type,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: appDarkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.phoneNumber,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    address.addressLine,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod paymentMethod) {
    /* ... same as before ... */
    bool isSelected = paymentMethod.type == _selectedPaymentMethodType;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethodType = paymentMethod.type;
          for (var pm in _paymentMethods) {
            pm.isSelected = (pm.type == paymentMethod.type);
          }
        });
      },
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? appGreen : lightGreyBorder,
            width: 1.5,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: appGreen.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ]
                  : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              paymentMethod.iconAsset,
              height: 28,
              width: 45,
              fit: BoxFit.contain,
              errorBuilder:
                  (ctx, err, st) =>
                      const Icon(Icons.payment, size: 28, color: appDarkText),
            ),
            const SizedBox(height: 8),
            Text(
              paymentMethod.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: appDarkText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isHalfWidth = false,
    String? hintText,
  }) {
    /* ... same as before ... */
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _capturePaypalOrderOnBackend(
    String orderId,
    String? payerId,
    String? paymentId,
  ) async {
    if (!mounted) return false;
    setState(() => _isProcessingPayment = true);
    try {
      print(
        "CheckoutPage: Attempting to capture order on backend. OrderID: $orderId",
      );
      final response = await http.post(
        Uri.parse(YOUR_BACKEND_CAPTURE_ORDER_URL_CHECKOUT),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'orderID': orderId}),
      );

      if (!mounted) return false; // Check again after await

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("CheckoutPage: Backend capture response: $responseData");
        return responseData['status'] == 'COMPLETED' ||
            responseData['success'] == true ||
            responseData['message']?.contains('success');
      } else {
        print(
          "CheckoutPage: Backend capture failed: ${response.statusCode} - ${response.body}",
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Server capture failed: ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      print("CheckoutPage: Error calling backend to capture PayPal order: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Network error during capture: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } finally {
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    }
  }

  void _handlePayNow() {
    if (_isProcessingPayment) return; // Prevent multiple taps

    final cart = Provider.of<CartProvider>(context, listen: false);
    final totalAmount = cart.totalAmount;

    if (_selectedPaymentMethodType == PaymentMethodType.paypal) {
      if (totalAmount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cart is empty or total is zero."),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      print("CheckoutPage: Navigating to PayPal WebView. Amount: $totalAmount");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (BuildContext context) => PaypalWebViewScreen(
                totalAmount: totalAmount,
                currency: "USD",
                onSuccess: (orderId, payerId, paymentId) async {
                  print(
                    "CheckoutPage: Flutter received PayPal Success from WebView: OrderID: $orderId",
                  );
                  Navigator.of(context).pop(); // Pop the WebView screen

                  bool captureSuccess = await _capturePaypalOrderOnBackend(
                    orderId,
                    payerId,
                    paymentId,
                  );

                  if (captureSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Payment Successful & Captured!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    cart.clearCart();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  } else {
                    // Error already shown by _capturePaypalOrderOnBackend
                  }
                },
                onError: (error) {
                  print(
                    "CheckoutPage: Flutter received PayPal Error from WebView: $error",
                  );
                  if (Navigator.canPop(context))
                    Navigator.of(
                      context,
                    ).pop(); // Pop the WebView screen if still there
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("PayPal Error: $error"),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                onCancel: () {
                  print(
                    "CheckoutPage: Flutter received PayPal Cancel from WebView.",
                  );
                  if (Navigator.canPop(context))
                    Navigator.of(context).pop(); // Pop the WebView screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("PayPal Payment Cancelled")),
                  );
                },
              ),
        ),
      );
    } else if (_selectedPaymentMethodType == PaymentMethodType.mastercard) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card payment not implemented yet.')),
      );
    } else if (_selectedPaymentMethodType == PaymentMethodType.cashOnDelivery) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed with Cash on Delivery (Backend needed).'),
        ),
      );
      cart.clearCart();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed:
              _isProcessingPayment
                  ? null
                  : () =>
                      Navigator.of(context).pop(), // Disable back if processing
        ),
      ),
      body: Stack(
        // Use Stack to overlay loading indicator
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(
                  'Select delivery address',
                  onAddTapped: () {
                    /* TODO */
                  },
                ),
                ..._deliveryAddresses
                    .map((addr) => _buildAddressCard(addr))
                    .toList(),
                _buildSectionTitle('Select payment system'),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _paymentMethods.length,
                    itemBuilder:
                        (ctx, index) =>
                            _buildPaymentMethodCard(_paymentMethods[index]),
                    separatorBuilder: (ctx, index) => const SizedBox(width: 12),
                  ),
                ),
                const SizedBox(height: 24),
                if (_selectedPaymentMethodType == PaymentMethodType.mastercard)
                  Column(
                    /* ... Card details form ... */
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Card Name', _cardNameController),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Card Number',
                        _cardNumberController,
                        hintText: "XXXX XXXX XXXX XXXX",
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Expiration Date',
                              _expiryDateController,
                              hintText: "MM/YY",
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'CVV',
                              _cvvController,
                              hintText: "XXX",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Remember My Card Details',
                            style: TextStyle(fontSize: 15, color: appDarkText),
                          ),
                          Switch(
                            value: _rememberCardDetails,
                            onChanged: (value) {
                              setState(() {
                                _rememberCardDetails = value;
                              });
                            },
                            activeColor: appGreen,
                          ),
                        ],
                      ),
                    ],
                  ),
                if (_selectedPaymentMethodType == PaymentMethodType.paypal)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text(
                        'You will be redirected to PayPal.',
                        style: TextStyle(fontSize: 16, color: appLightText),
                      ),
                    ),
                  ),
                if (_selectedPaymentMethodType ==
                    PaymentMethodType.cashOnDelivery)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text(
                        'Order will be Cash on Delivery.',
                        style: TextStyle(fontSize: 16, color: appLightText),
                      ),
                    ),
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          if (_isProcessingPayment) // Overlay loading indicator
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: ElevatedButton(
          onPressed:
              _isProcessingPayment
                  ? null
                  : _handlePayNow, // Disable button while processing
          style: ElevatedButton.styleFrom(
            backgroundColor: appGreen,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child:
              _isProcessingPayment
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                  : const Text('Pay Now'),
        ),
      ),
    );
  }
}
