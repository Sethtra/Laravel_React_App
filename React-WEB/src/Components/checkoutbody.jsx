import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { PayPalScriptProvider, PayPalButtons } from "@paypal/react-paypal-js";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

function CheckoutBody() {
  const [cart, setCart] = useState([]);
  const [paymentMethod, setPaymentMethod] = useState("");
  const [formFields, setFormFields] = useState({
    firstName: "",
    lastName: "",
    country: "",
    streetAddress: "",
    townCity: "",
    postcodeZip: "",
    phone: "",
    email: "",
  });
  const [isFormValid, setIsFormValid] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    // Load cart from local storage (if exists)
    const storedCart = localStorage.getItem("cart");
    if (storedCart) {
      setCart(JSON.parse(storedCart));
    }
  }, []);

  // Calculate total cost based on cart items
  const calculateTotal = () => {
    return cart.reduce((total, item) => total + item.price * item.quantity, 0);
  };

  // Track changes to the payment method radio buttons
  const handlePaymentMethodChange = (event) => {
    setPaymentMethod(event.target.value);
  };

  // Track changes to the billing form fields
  const handleFormChange = (event) => {
    const { name, value } = event.target;
    setFormFields((prevState) => ({
      ...prevState,
      [name]: value,
    }));
  };

  // Clear the cart and redirect to home
  const handleClearCartAndRedirect = () => {
    localStorage.removeItem("cart");
    localStorage.removeItem("cartCount");
    setCart([]);
    navigate("/");
  };

  // Send billing data to backend API
  const sendBillingDataToBackend = async (paymentMethodValue) => {
    const billingData = {
      first_name: formFields.firstName, // Keys match Laravel's validation
      last_name: formFields.lastName,
      country: formFields.country,
      street_address: formFields.streetAddress,
      town_city: formFields.townCity,
      postcode_zip: formFields.postcodeZip,
      phone: formFields.phone,
      email: formFields.email,
      payment_method: paymentMethodValue,
      total_amount: parseFloat(calculateTotal().toFixed(2)),
    };

    try {
      const response = await fetch("http://localhost:8000/api/billing", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(billingData),
      });

      if (response.ok) {
        const result = await response.json();
        // Show only ONE success toast with the tracking ID
        toast.success(
          `Order placed successfully! Tracking ID: ${result.order_tracking_id}`,
          {
            position: "top-right",
            autoClose: 6000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "light",
            // Once the toast disappears, redirect the user
            onClose: () => {
              handleClearCartAndRedirect();
            },
          }
        );
      } else {
        throw new Error("Failed to store billing data.");
      }
    } catch (error) {
      toast.error(`Error: ${error.message}`, {
        position: "top-right",
        autoClose: 6000,
        hideProgressBar: false,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
        progress: undefined,
        theme: "light",
      });
      console.error("Error:", error);
    }
  };

  // Called by PayPal once payment is successful
  const handlePaymentSuccess = () => {
    // Instead of showing a second toast, we directly call the backend
    // which itself triggers a toast on success (with the tracking ID).
    sendBillingDataToBackend(paymentMethod);
  };

  // Handle payment errors / cancellations
  const handlePaymentError = (message) => {
    toast.error(message, {
      position: "top-right",
      autoClose: 6000,
      hideProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
      draggable: true,
      progress: undefined,
      theme: "light",
    });
  };

  // Validate the form fields
  const validateForm = () => {
    const isValid =
      formFields.firstName &&
      formFields.lastName &&
      formFields.country &&
      formFields.streetAddress &&
      formFields.townCity &&
      formFields.postcodeZip &&
      formFields.phone &&
      formFields.email;
    setIsFormValid(isValid);
  };

  // Run validation whenever the form changes
  useEffect(() => {
    validateForm();
  }, [formFields]);

  return (
    <div>
      <section className="ftco-section">
        <div className="container">
          <div className="row justify-content-center">
            <div className="col-xl-10 ftco-animate">
              <form className="billing-form">
                <h3 className="mb-4 billing-heading">Billing Details</h3>
                <div className="row align-items-end">
                  {/* First Name */}
                  <div className="col-md-6">
                    <div className="form-group">
                      <label htmlFor="firstname">First Name</label>
                      <input
                        type="text"
                        className="form-control"
                        placeholder="First Name"
                        name="firstName"
                        value={formFields.firstName}
                        onChange={handleFormChange}
                        required
                      />
                    </div>
                  </div>
                  {/* Last Name */}
                  <div className="col-md-6">
                    <div className="form-group">
                      <label htmlFor="lastname">Last Name</label>
                      <input
                        type="text"
                        className="form-control"
                        placeholder="Last Name"
                        name="lastName"
                        value={formFields.lastName}
                        onChange={handleFormChange}
                        required
                      />
                    </div>
                  </div>
                  <div className="w-100" />
                  {/* Country */}
                  <div className="col-md-12">
                    <div className="form-group">
                      <label htmlFor="country">State / Country</label>
                      <select
                        name="country"
                        className="form-control"
                        value={formFields.country}
                        onChange={handleFormChange}
                        required
                      >
                        <option value="">Select Country</option>
                        <option value="France">France</option>
                        <option value="Italy">Italy</option>
                        <option value="Philippines">Philippines</option>
                        <option value="South Korea">South Korea</option>
                        <option value="Hongkong">Hongkong</option>
                        <option value="Japan">Japan</option>
                      </select>
                    </div>
                  </div>
                  <div className="w-100" />
                  {/* Street Address */}
                  <div className="col-md-6">
                    <div className="form-group">
                      <label htmlFor="streetaddress">Street Address</label>
                      <input
                        type="text"
                        className="form-control"
                        placeholder="House number and street name"
                        name="streetAddress"
                        value={formFields.streetAddress}
                        onChange={handleFormChange}
                        required
                      />
                    </div>
                  </div>
                  {/* Apartment (optional) */}
                  <div className="col-md-6">
                    <div className="form-group">
                      <input
                        type="text"
                        className="form-control"
                        placeholder="Apartment, suite, unit etc: (optional)"
                        name="apartment"
                        onChange={handleFormChange}
                      />
                    </div>
                  </div>
                  <div className="w-100" />
                  {/* Town / City */}
                  <div className="col-md-6">
                    <div className="form-group">
                      <label htmlFor="towncity">Town / City</label>
                      <input
                        type="text"
                        className="form-control"
                        placeholder="City"
                        name="townCity"
                        value={formFields.townCity}
                        onChange={handleFormChange}
                        required
                      />
                    </div>
                  </div>
                  {/* Postcode / ZIP */}
                  <div className="col-md-6">
                    <div className="form-group">
                      <label htmlFor="postcodezip">Postcode / ZIP *</label>
                      <input
                        type="text"
                        className="form-control"
                        placeholder="Postcode"
                        name="postcodeZip"
                        value={formFields.postcodeZip}
                        onChange={handleFormChange}
                        required
                      />
                    </div>
                  </div>
                  <div className="w-100" />
                  {/* Phone */}
                  <div className="col-md-6">
                    <div className="form-group">
                      <label htmlFor="phone">Phone</label>
                      <input
                        type="text"
                        className="form-control"
                        placeholder="Phone number"
                        name="phone"
                        value={formFields.phone}
                        onChange={handleFormChange}
                        required
                      />
                    </div>
                  </div>
                  {/* Email */}
                  <div className="col-md-6">
                    <div className="form-group">
                      <label htmlFor="emailaddress">Email Address</label>
                      <input
                        type="email"
                        className="form-control"
                        placeholder="Email Address"
                        name="email"
                        value={formFields.email}
                        onChange={handleFormChange}
                        required
                      />
                    </div>
                  </div>
                  <div className="w-100" />
                </div>
              </form>

              <div className="row mt-5 pt-3 d-flex">
                <div className="col-md-6 d-flex">
                  <div className="cart-detail cart-total bg-light p-3 p-md-4">
                    <h3 className="billing-heading mb-4">Cart Total</h3>
                    <p className="d-flex">
                      <span>Subtotal</span>
                      <span>${calculateTotal().toFixed(2)}</span>
                    </p>
                    <p className="d-flex">
                      <span>Delivery</span>
                      <span>$0.00</span>
                    </p>
                    <p className="d-flex">
                      <span>Discount</span>
                      <span>$3.00</span>
                    </p>
                    <hr />
                    <p className="d-flex total-price">
                      <span>Total</span>
                      <span>${calculateTotal().toFixed(2)}</span>
                    </p>
                  </div>
                </div>

                <div className="col-md-6">
                  <div className="cart-detail bg-light p-3 p-md-4">
                    <h3 className="billing-heading mb-4">Payment Method</h3>

                    <div className="form-group">
                      <div className="col-md-12">
                        <div className="radio">
                          <label>
                            <input
                              type="radio"
                              name="optradio"
                              value="bank-transfer"
                              checked={paymentMethod === "bank-transfer"}
                              onChange={handlePaymentMethodChange}
                            />{" "}
                            Direct Bank Transfer
                          </label>
                        </div>
                      </div>
                    </div>

                    <div className="form-group">
                      <div className="col-md-12">
                        <div className="radio">
                          <label>
                            <input
                              type="radio"
                              name="optradio"
                              value="check-payment"
                              checked={paymentMethod === "check-payment"}
                              onChange={handlePaymentMethodChange}
                            />{" "}
                            Check Payment
                          </label>
                        </div>
                      </div>
                    </div>

                    <div className="form-group">
                      <div className="col-md-12">
                        <div className="radio">
                          <label>
                            <input
                              type="radio"
                              name="optradio"
                              value="paypal"
                              checked={paymentMethod === "paypal"}
                              onChange={handlePaymentMethodChange}
                            />{" "}
                            PayPal
                          </label>
                        </div>
                      </div>
                    </div>

                    {paymentMethod === "paypal" && (
                      <div className="mt-4">
                        <PayPalScriptProvider
                          options={{
                            "client-id":
                              "AZ72ppbVWqS2u5d36GAfyE1kG0HDzkWKPgiuThkCCO6llbkm8K2vUfsuTpODwlz3OFyC8P7o4fmf6Xpg",
                          }}
                        >
                          <PayPalButtons
                            style={{ layout: "vertical" }}
                            createOrder={(data, actions) => {
                              return actions.order.create({
                                purchase_units: [
                                  {
                                    amount: {
                                      value: calculateTotal().toFixed(2),
                                    },
                                  },
                                ],
                              });
                            }}
                            onApprove={(data, actions) => {
                              return actions.order.capture().then(() => {
                                // We directly call our backend on success
                                handlePaymentSuccess();
                              });
                            }}
                            onError={(err) => {
                              console.error("Error during payment:", err);
                              handlePaymentError(
                                "Payment Failed! Please try again later."
                              );
                            }}
                            onCancel={(data) => {
                              console.log("Payment cancelled:", data);
                              handlePaymentError("Payment was cancelled.");
                            }}
                          />
                        </PayPalScriptProvider>
                      </div>
                    )}

                    {paymentMethod !== "paypal" && (
                      <p className="text-center">
                        <button
                          className="btn btn-primary py-3 px-4"
                          onClick={() => {
                            // For non-PayPal methods, we still want to
                            // store billing data, then redirect
                            sendBillingDataToBackend(paymentMethod);
                          }}
                          disabled={!isFormValid}
                        >
                          Place an order
                        </button>
                      </p>
                    )}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}

export default CheckoutBody;