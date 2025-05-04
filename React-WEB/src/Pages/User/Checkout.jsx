import React from "react";
import Header from "../../Components/header";
import Pageheader from "../../Components/pageheader";
import JavaScript from "../../Components/javascript";
import Nav from "../../Components/nav";
import CheckoutBody from "../../Components/checkoutbody";
import Follow from "../../Components/followus";
import Footer from "../../Components/footer";
import { ToastContainer } from "react-toastify"; // Import ToastContainer here

function Checkout() {
  return (
    <div>
      <Header />
      <Nav />
      <Pageheader />
      <CheckoutBody />
      <JavaScript />
      <Follow />
      <Footer />
      <ToastContainer /> {/* Render ToastContainer globally */}
    </div>
  );
}

export default Checkout;
