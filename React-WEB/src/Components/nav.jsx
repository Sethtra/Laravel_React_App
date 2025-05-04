import React, { useContext, useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { AppContext } from "../Context/AppContext"; // Assuming you have a context for user

function Nav() {
  const { user, token, setUser, setToken } = useContext(AppContext); // Accessing user from context
  const navigate = useNavigate();
  const [cartItemCount, setCartItemCount] = useState(0); // State to track cart items

  // Get cart item count from localStorage when the component mounts
  useEffect(() => {
    const cartCount = localStorage.getItem("cartCount");
    if (cartCount) {
      setCartItemCount(Number(cartCount)); // Initialize cart count on page load
    }

    // Listen for changes to localStorage for real-time cart updates
    const handleStorageChange = () => {
      const updatedCartCount = localStorage.getItem("cartCount");
      setCartItemCount(updatedCartCount ? Number(updatedCartCount) : 0);
    };

    window.addEventListener("storage", handleStorageChange);
    return () => window.removeEventListener("storage", handleStorageChange);
  }, []); // Empty dependency array ensures this effect runs only once on mount

  // Handle logout
  async function handleLogout(e) {
    e.preventDefault();

    if (token) {
      const res = await fetch("/api/logout", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${token}`, // Sending the token to logout
          "Content-Type": "application/json", // Add content type if needed
        },
      });

      const data = await res.json();
      if (res.ok) {
        setUser(null);
        setToken(null);
        localStorage.removeItem("token");
        navigate("/"); // Redirect to login page after logout
      } else {
        console.error("Logout failed:", data);
      }
    } else {
      setUser(null);
      setToken(null);
      localStorage.removeItem("token");
      navigate("/"); // Redirect to login page
    }
  }

  return (
    <div>
      <div className="py-1 bg-black">
        <div className="container">
          <div className="row no-gutters d-flex align-items-start align-items-center px-md-0">
            <div className="col-lg-12 d-block">
              <div className="row d-flex">
                <div className="col-md pr-4 d-flex topper align-items-center">
                  <div className="icon mr-2 d-flex justify-content-center align-items-center">
                    <span className="icon-phone2" />
                  </div>
                  <span className="text">+ 1235 2355 98</span>
                </div>
                <div className="col-md pr-4 d-flex topper align-items-center">
                  <div className="icon mr-2 d-flex justify-content-center align-items-center">
                    <span className="icon-paper-plane" />
                  </div>
                  <span className="text">youremail@email.com</span>
                </div>
                <div className="col-md-5 pr-4 d-flex topper align-items-center text-lg-right">
                  <span className="text">
                    3-5 Business days delivery &amp; Free Returns
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <nav
        className="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light"
        id="ftco-navbar"
      >
        <div className="container">
          <a className="navbar-brand" href="index.html">
            Minishop
          </a>
          <button
            className="navbar-toggler"
            type="button"
            data-toggle="collapse"
            data-target="#ftco-nav"
            aria-controls="ftco-nav"
            aria-expanded="false"
            aria-label="Toggle navigation"
          >
            <span className="oi oi-menu" /> Menu
          </button>
          <div className="collapse navbar-collapse" id="ftco-nav">
            <ul className="navbar-nav ml-auto">
              <li className="nav-item active">
                <a href="/" className="nav-link">
                  Home
                </a>
              </li>
              <li className="nav-item dropdown">
                <a
                  className="nav-link dropdown-toggle"
                  href="#"
                  id="dropdown04"
                  data-toggle="dropdown"
                  aria-haspopup="true"
                  aria-expanded="false"
                >
                  Catalog
                </a>
                <div className="dropdown-menu" aria-labelledby="dropdown04">
                  <Link to="/shop" className="dropdown-item">
                    Shop
                  </Link>
                  <Link to="/productdetail" className="dropdown-item">
                    Single Product
                  </Link>
                  <Link to="/cart" className="dropdown-item">
                    Cart
                  </Link>
                  <Link to="/checkout" className="dropdown-item">
                    Checkout
                  </Link>
                </div>
              </li>
              <li className="nav-item">
                <Link to="/contact" className="nav-link">
                  Contact
                </Link>
              </li>

              <li className="nav-item cta cta-colored">
                <a href="/cart" className="nav-link">
                  <span className="icon-shopping_cart" />[{cartItemCount}]{" "}
                  {/* Display the real-time cart item count */}
                </a>
              </li>

              <li className="nav-item dropdown">
                <a
                  className="nav-link dropdown-toggle flex items-center space-x-2"
                  href="#"
                  id="dropdownUser"
                  data-toggle="dropdown"
                  aria-haspopup="true"
                  aria-expanded="false"
                >
                  <span className="icon-user" />
                  {user ? `Hello, ${user.name}` : "User"}
                </a>

                <div className="dropdown-menu" aria-labelledby="dropdownUser">
                  {!user ? (
                    <>
                      <Link to="/register" className="dropdown-item">
                        Register
                      </Link>
                      <Link to="/login" className="dropdown-item">
                        Login
                      </Link>
                    </>
                  ) : (
                    <div>
                      {/* Logout form if the user is logged in */}
                      <form onSubmit={handleLogout}>
                        <button type="submit" className="dropdown-item">
                          Logout
                        </button>
                      </form>
                    </div>
                  )}
                </div>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    </div>
  );
}

export default Nav;