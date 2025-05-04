import React from "react";
import { useLocation } from "react-router-dom";

function PageHeader() {
  const location = useLocation(); // Get current location

  // Set the title based on the path
  let pageTitle = "";
  if (location.pathname === "/cart") {
    pageTitle = "Cart";
  } else if (location.pathname.startsWith("/productdetail")) {
    pageTitle = "Product Detail";
  } else if (location.pathname === "/checkout") {
    pageTitle = "Checkout";
  } else {
    pageTitle = "Shop";
  }

  return (
    <div
      className="hero-wrap hero-bread"
      style={{ backgroundImage: 'url("/assets/images/bg_6.jpg")' }}
    >
      <div className="container">
        <div className="row no-gutters slider-text align-items-center justify-content-center">
          <div className="col-md-9 ftco-animate text-center">
            <p className="breadcrumbs">
              <span className="mr-2">
                <a href="/">Home</a>
              </span>{" "}
              <span>{pageTitle}</span> {/* Dynamic page title */}
            </p>
            <h1 className="mb-0 bread">{pageTitle}</h1>{" "}
            {/* Dynamic page title */}
          </div>
        </div>
      </div>
    </div>
  );
}

export default PageHeader;
