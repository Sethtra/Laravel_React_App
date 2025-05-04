import React from "react";
import { toast } from "react-toastify"; // Import toast
import "react-toastify/dist/ReactToastify.css"; // Import toast styles

function ProductDetailBody({ product }) {
  const baseImageUrl = "http://localhost:8000/storage/";

  // Handle "Add to Cart" functionality
  const handleAddToCart = () => {
    const storedCart = JSON.parse(localStorage.getItem("cart")) || [];
    const existingProductIndex = storedCart.findIndex(
      (item) => item.id === product.id
    );

    if (existingProductIndex > -1) {
      // If product already in cart, increase quantity
      storedCart[existingProductIndex].quantity += 1;
    } else {
      // Otherwise, add new product to cart
      storedCart.push({ ...product, quantity: 1 });
    }

    // Update cart in localStorage
    localStorage.setItem("cart", JSON.stringify(storedCart));

    // Update cart item count in localStorage
    const totalItems = storedCart.reduce(
      (total, item) => total + item.quantity,
      0
    ); // Total quantity of items
    localStorage.setItem("cartCount", totalItems); // Update cart count

    // Show toast notification for successful add to cart
    toast.success(`${product.name} has been added to your cart.`, {
      position: "top-right",
      autoClose: 3000,
      hideProgressBar: false,
      closeOnClick: false,
      pauseOnHover: true,
      draggable: true,
      progress: undefined,
      theme: "light",
    });
  };

  return (
    <div>
      <section className="ftco-section">
        <div className="container">
          <div className="row">
            {/* Product Image */}
            <div className="col-lg-6 mb-5 ftco-animate">
              <a
                href={`${baseImageUrl}${product.image}`}
                className="image-popup prod-img-bg"
              >
                <img
                  src={`${baseImageUrl}${product.image}`}
                  className="img-fluid"
                  alt={product.name}
                />
              </a>
            </div>

            {/* Product Details */}
            <div className="col-lg-6 product-details pl-md-5 ftco-animate">
              <h3>{product.name}</h3>
              <div className="rating d-flex">
                <p className="text-left mr-4">
                  <a href="#" className="mr-2">
                    {product.rating || "No ratings"}{" "}
                  </a>
                  {Array(5)
                    .fill()
                    .map((_, i) => (
                      <a href="#" key={i}>
                        <span className="ion-ios-star-outline" />
                      </a>
                    ))}
                </p>
                <p className="text-left mr-4">
                  <a href="#" className="mr-2" style={{ color: "#000" }}>
                    {product.rating_count}{" "}
                    <span style={{ color: "#bbb" }}>Ratings</span>
                  </a>
                </p>
                <p className="text-left">
                  <a href="#" className="mr-2" style={{ color: "#000" }}>
                    {product.sold_count}{" "}
                    <span style={{ color: "#bbb" }}>Sold</span>
                  </a>
                </p>
              </div>
              <p className="price">
                <span>${product.price}</span>
              </p>
              <p>{product.description}</p>

              {/* Size and Quantity */}
              <div className="row mt-4">
                <div className="col-md-6">
                  <div className="form-group d-flex">
                    <div className="select-wrap">
                      <div className="icon">
                        <span className="ion-ios-arrow-down" />
                      </div>
                      <select name="size" className="form-control">
                        <option value="small">Small</option>
                        <option value="medium">Medium</option>
                        <option value="large">Large</option>
                        <option value="extra_large">Extra Large</option>
                      </select>
                    </div>
                  </div>
                </div>
                <div className="w-100" />
                <div className="input-group col-md-6 d-flex mb-3">
                  <span className="input-group-btn mr-2">
                    <button
                      type="button"
                      className="quantity-left-minus btn"
                      data-type="minus"
                      data-field=""
                    >
                      <i className="ion-ios-remove" />
                    </button>
                  </span>
                  <input
                    type="text"
                    id="quantity"
                    name="quantity"
                    className="quantity form-control input-number"
                    defaultValue={1}
                    min={1}
                    max={product.quantity} // Dynamic max quantity
                  />
                  <span className="input-group-btn ml-2">
                    <button
                      type="button"
                      className="quantity-right-plus btn"
                      data-type="plus"
                      data-field=""
                    >
                      <i className="ion-ios-add" />
                    </button>
                  </span>
                </div>
                <div className="w-100" />
                <div className="col-md-12">
                  <p style={{ color: "#000" }}>
                    {product.quantity} piece{product.quantity > 1 ? "s" : ""}{" "}
                    available
                  </p>
                </div>
              </div>

              {/* Add to Cart and Buy Now buttons */}
              <p>
                <a
                  href="#"
                  onClick={handleAddToCart} // Handle Add to Cart
                  className="btn btn-black py-3 px-5 mr-2"
                >
                  Add to Cart
                </a>
                <a href="cart.html" className="btn btn-primary py-3 px-5">
                  Buy Now
                </a>
              </p>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}

export default ProductDetailBody;
