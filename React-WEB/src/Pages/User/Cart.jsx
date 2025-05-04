import React from 'react'
import Header from "../../Components/header";
import Nav from "../../Components/nav";
import Pageheader from "../../Components/pageheader";
import CartBody from "../../Components/cartbody";
import Footer from "../../Components/footer";
import JavaScript from "../../Components/javascript";



function Cart() {
  return (
    <div>
      <Header />
      <Nav />
      <Pageheader />
      <CartBody />
      <Footer />
      <JavaScript />
    </div>
  );
}

export default Cart