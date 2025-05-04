import React from "react";
import { ToastContainer } from "react-toastify"; // Import ToastContainer here
import Header from "../../Components/header";
import Pageheader from "../../Components/pageheader";
import JavaScript from "../../Components/javascript";
import Nav from "../../Components/nav";
import ShopBody from "../../Components/shopbody";
import Follow from "../../Components/followus";
import Footer from "../../Components/footer";

function Shop() {
  return (
    <div>
      <Header />
      <Nav />
      <Pageheader />
      <ShopBody />
      <JavaScript />
      <Follow />
      <Footer />
      <ToastContainer /> {/* Add ToastContainer globally */}
    </div>
  );
}

export default Shop;
