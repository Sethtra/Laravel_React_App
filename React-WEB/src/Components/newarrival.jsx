import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { toast } from "react-toastify"; // Import toast
import "react-toastify/dist/ReactToastify.css"; // Import toast styles

function NewArrival() {
  const [products, setProducts] = useState([]);
  const baseImageUrl = "http://localhost:8000/storage/";

  useEffect(() => {
    fetch("http://localhost:8000/api/products")
      .then((res) => res.json())
      .then((data) => {
        setProducts(data.slice(0, 8)); // Limit to 8 products
      })
      .catch((err) => console.error("Error fetching products:", err));
  }, []);

  const handleAddToCart = (product) => {
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
      <section className="ftco-section bg-light">
        <div className="container">
          <div className="row justify-content-center mb-3 pb-3">
            <div className="col-md-12 heading-section text-center">
              <h2 className="mb-4">New Shoes Arrival</h2>
              <p>
                Far far away, behind the word mountains, far from the countries
                Vokalia and Consonantia
              </p>
            </div>
          </div>
        </div>
        <div className="container">
          <div className="row">
            {products.length > 0 ? (
              products.map((product) => (
                <div
                  key={product.id}
                  className="col-sm-12 col-md-6 col-lg-3 d-flex"
                >
                  <div className="product d-flex flex-column">
                    <Link to={`/product/${product.id}`} className="img-prod">
                      <img
                        className="img-fluid"
                        src={`${baseImageUrl}${product.image}`}
                        alt={product.name}
                      />
                      <div className="overlay" />
                    </Link>
                    <div className="text py-3 pb-4 px-3">
                      <div className="d-flex">
                        <div className="cat">
                          <span>{product.category}</span>
                        </div>
                        <div className="rating">
                          <p className="text-right mb-0">
                            {Array(5)
                              .fill()
                              .map((_, i) => (
                                <a href="#" key={i}>
                                  <span className="ion-ios-star-outline" />
                                </a>
                              ))}
                          </p>
                        </div>
                      </div>
                      <h3>
                        <Link to={`/product/${product.id}`}>
                          {product.name}
                        </Link>
                      </h3>
                      <div className="pricing">
                        <p className="price">
                          <span>${product.price}</span>
                        </p>
                      </div>
                      <p className="bottom-area d-flex px-3">
                        <a
                          href="#"
                          onClick={() => handleAddToCart(product)} // Add to Cart functionality
                          className="add-to-cart text-center py-2 mr-1"
                        >
                          <span>
                            Add to cart <i className="ion-ios-add ml-1" />
                          </span>
                        </a>
                        <Link
                          to={`/product/${product.id}`}
                          className="buy-now text-center py-2"
                        >
                          Buy now
                          <span>
                            <i className="ion-ios-cart ml-1" />
                          </span>
                        </Link>
                      </p>
                    </div>
                  </div>
                </div>
              ))
            ) : (
              <div>No products available.</div>
            )}
          </div>
        </div>
      </section>
    </div>
  );
}

export default NewArrival;