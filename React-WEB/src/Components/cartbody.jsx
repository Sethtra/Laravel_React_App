import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";

function CartBody() {
  const [cart, setCart] = useState(() => {
    const storedCart = localStorage.getItem("cart");
    return storedCart ? JSON.parse(storedCart) : [];
  });
  const navigate = useNavigate();

  // Update cart count in localStorage when cart changes
  useEffect(() => {
    localStorage.setItem("cart", JSON.stringify(cart));
    const totalItems = cart.reduce((total, item) => total + item.quantity, 0);
    localStorage.setItem("cartCount", totalItems); // Update cart count in localStorage
  }, [cart]);

  const handleRemoveFromCart = (productId) => {
    const updatedCart = cart.filter((item) => item.id !== productId);
    setCart(updatedCart);
  };

  const handleQuantityChange = (productId, quantity) => {
    if (quantity < 1) {
      return; // Don't allow quantity less than 1
    }

    const updatedCart = cart.map((item) =>
      item.id === productId ? { ...item, quantity: Number(quantity) } : item
    );
    setCart(updatedCart);
  };

  const calculateTotal = () => {
    return cart.reduce((total, item) => total + item.price * item.quantity, 0);
  };

  // Redirect to checkout page with the cart
  const handleProceedToCheckout = () => {
    localStorage.setItem("cart", JSON.stringify(cart)); // Store cart in localStorage
    navigate("/checkout"); // Navigate to the checkout page
  };

  // Navigate to the shopping page
  const handleContinueShopping = () => {
    navigate("/shop"); // Redirect to the shopping page (or any other page)
  };

  return (
    <div>
      <section className="ftco-section ftco-cart">
        <div className="container">
          <div className="row">
            <div className="col-md-12 ftco-animate">
              <div className="cart-list">
                <table className="table">
                  <thead className="thead-primary">
                    <tr className="text-center">
                      <th>&nbsp;</th>
                      <th>&nbsp;</th>
                      <th>Product</th>
                      <th>Price</th>
                      <th>Quantity</th>
                      <th>Total</th>
                    </tr>
                  </thead>
                  <tbody>
                    {cart.length > 0 ? (
                      cart.map((item) => (
                        <tr className="text-center" key={item.id}>
                          <td className="product-remove">
                            <a
                              href="#"
                              onClick={() => handleRemoveFromCart(item.id)}
                            >
                              <span className="ion-ios-close" />
                            </a>
                          </td>
                          <td className="image-prod">
                            <div
                              className="img"
                              style={{
                                backgroundImage: `url(http://localhost:8000/storage/${item.image})`,
                              }}
                            />
                          </td>
                          <td className="product-name">
                            <h3>{item.name}</h3>
                            <p>{item.description}</p>
                          </td>
                          <td className="price">${item.price}</td>
                          <td className="quantity">
                            <div className="input-group mb-3">
                              <input
                                type="number"
                                name="quantity"
                                className="quantity form-control input-number"
                                value={item.quantity}
                                min={1}
                                max={100}
                                onChange={(e) =>
                                  handleQuantityChange(item.id, e.target.value)
                                }
                              />
                            </div>
                          </td>
                          <td className="total">
                            ${item.price * item.quantity}
                          </td>
                        </tr>
                      ))
                    ) : (
                      <tr>
                        <td colSpan="6">No products in cart.</td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
          <div className="row justify-content-start">
            <div className="col col-lg-5 col-md-6 mt-5 cart-wrap ftco-animate">
              <div className="cart-total mb-3">
                <h3>Cart Totals</h3>
                <p className="d-flex">
                  <span>Subtotal</span>
                  <span>${calculateTotal().toFixed(2)}</span>
                </p>
                <hr />
                <p className="d-flex total-price">
                  <span>Total</span>
                  <span>${calculateTotal().toFixed(2)}</span>
                </p>
              </div>
              <p className="text-center mt-3">
                <button
                  onClick={handleContinueShopping}
                  className="btn btn-primary py-3 px-4"
                >
                  Continue Shopping
                </button>
              </p>
              
              <p className="text-center">
                <button
                  onClick={handleProceedToCheckout}
                  className="btn btn-primary py-3 px-4"
                >
                  Proceed to Checkout
                </button>
              </p>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}

export default CartBody;
