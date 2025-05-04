import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { toast } from "react-toastify"; // Import toast
import "react-toastify/dist/ReactToastify.css"; // Import toast styles

function ShopBody() {
  const [products, setProducts] = useState([]);
  const [categoryFilter, setCategoryFilter] = useState("");
  const [priceRange, setPriceRange] = useState([0, 10000]);
  const baseImageUrl = "http://localhost:8000/storage/";

  // Fetch products on component mount
  useEffect(() => {
    fetch("http://localhost:8000/api/products")
      .then((res) => res.json())
      .then((data) => {
        const filteredProducts = data.filter(
          (product) =>
            (categoryFilter ? product.category === categoryFilter : true) &&
            product.price >= priceRange[0] &&
            product.price <= priceRange[1]
        );
        setProducts(filteredProducts);
      })
      .catch((err) => console.error("Error fetching products:", err));
  }, [categoryFilter, priceRange]);

  // Handle "Add to Cart" functionality
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
          <div className="row">
            {/* Sidebar for filters */}
            <div className="col-md-4 col-lg-2">
              <div className="sidebar">
                {/* Categories Filter */}
                <div className="sidebar-box-2">
                  <h2 className="heading">Categories</h2>
                  <div className="fancy-collapse-panel">
                    <div
                      className="panel-group"
                      id="accordion"
                      role="tablist"
                      aria-multiselectable="true"
                    >
                      <div className="panel panel-default">
                        <div
                          className="panel-heading"
                          role="tab"
                          id="headingOne"
                        >
                          <h4 className="panel-title">
                            <a
                              data-toggle="collapse"
                              data-parent="#accordion"
                              href="#collapseOne"
                              aria-expanded="true"
                              aria-controls="collapseOne"
                              onClick={() => setCategoryFilter("Men's Shoes")}
                            >
                              Men's Shoes
                            </a>
                          </h4>
                        </div>
                        <div
                          id="collapseOne"
                          className="panel-collapse collapse"
                          role="tabpanel"
                          aria-labelledby="headingOne"
                        >
                          <div className="panel-body">
                            <ul>
                              <li>
                                <a
                                  href="#"
                                  onClick={() => setCategoryFilter("Sport")}
                                >
                                  Sport
                                </a>
                              </li>
                              <li>
                                <a
                                  href="#"
                                  onClick={() => setCategoryFilter("Casual")}
                                >
                                  Casual
                                </a>
                              </li>
                              <li>
                                <a
                                  href="#"
                                  onClick={() => setCategoryFilter("Running")}
                                >
                                  Running
                                </a>
                              </li>
                              <li>
                                <a
                                  href="#"
                                  onClick={() => setCategoryFilter("Jordan")}
                                >
                                  Jordan
                                </a>
                              </li>
                            </ul>
                          </div>
                        </div>
                      </div>
                      {/* More Categories */}
                      {/* Add similar sections for Women's Shoes, Accessories, etc. */}
                    </div>
                  </div>
                </div>

                {/* Price Range Filter */}
                <div className="sidebar-box-2">
                  <h2 className="heading">Price Range</h2>
                  <form method="post" className="colorlib-form-2">
                    <div className="row">
                      <div className="col-md-12">
                        <div className="form-group">
                          <label htmlFor="guests">Price from:</label>
                          <div className="form-field">
                            <i className="icon icon-arrow-down3" />
                            <select
                              name="people"
                              id="people"
                              className="form-control"
                              value={priceRange[0]}
                              onChange={(e) =>
                                setPriceRange([
                                  Math.max(0, e.target.value),
                                  priceRange[1],
                                ])
                              }
                            >
                              <option value="1">1</option>
                              <option value="200">200</option>
                              <option value="300">300</option>
                              <option value="400">400</option>
                              <option value="1000">1000</option>
                            </select>
                          </div>
                        </div>
                      </div>
                      <div className="col-md-12">
                        <div className="form-group">
                          <label htmlFor="guests">Price to:</label>
                          <div className="form-field">
                            <i className="icon icon-arrow-down3" />
                            <select
                              name="people"
                              id="people"
                              className="form-control"
                              value={priceRange[1]}
                              onChange={(e) =>
                                setPriceRange([
                                  priceRange[0],
                                  Math.min(10000, e.target.value),
                                ])
                              }
                            >
                              <option value="2000">2000</option>
                              <option value="4000">4000</option>
                              <option value="6000">6000</option>
                              <option value="8000">8000</option>
                              <option value="10000">10000</option>
                            </select>
                          </div>
                        </div>
                      </div>
                    </div>
                  </form>
                </div>
              </div>
            </div>

            {/* Product List */}
            <div className="col-md-8 col-lg-10">
              <div className="row">
                {products.length > 0 ? (
                  products.map((product) => (
                    <div
                      key={product.id}
                      className="col-sm-12 col-md-6 col-lg-4 d-flex"
                    >
                      <div className="product d-flex flex-column">
                        <Link
                          to={`/product/${product.id}`}
                          className="img-prod"
                        >
                          <img
                            className="img-fluid"
                            src={`${baseImageUrl}${product.image}`}
                            alt={product.name}
                          />
                          {product.status === "unavailable" && (
                            <span className="status">Unavailable</span>
                          )}
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
                              onClick={() => handleAddToCart(product)}
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

              {/* Pagination */}
              <div className="row mt-5">
                <div className="col text-center">
                  <div className="block-27">
                    <ul>
                      <li>
                        <a href="#">&lt;</a>
                      </li>
                      <li className="active">
                        <a href="#">1</a>
                      </li>
                      <li>
                        <a href="#">2</a>
                      </li>
                      <li>
                        <a href="#">3</a>
                      </li>
                      <li>
                        <a href="#">4</a>
                      </li>
                      <li>
                        <a href="#">5</a>
                      </li>
                      <li>
                        <a href="#">&gt;</a>
                      </li>
                    </ul>
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

export default ShopBody;