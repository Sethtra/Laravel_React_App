import React from "react";
import Header from "../../Components/header";
import Nav from "../../Components/nav";
import Banner from "../../Components/banner";
import JavaScript from "../../Components/javascript";
import FreeShipping from "../../Components/freeshipping";
import NewArrival from "../../Components/newarrival";
import Categorie from "../../Components/categoriesection";
import Satisfied from "../../Components/customersatisfied";
import Follow from "../../Components/followus";
import Footer from "../../Components/footer";
import { ToastContainer } from "react-toastify"; // Import ToastContainer here

function Home() {
  return (
    <div>
      <Header />
      <Nav />
      <Banner />
      <FreeShipping />
      <NewArrival />
      <Categorie />
      <Satisfied />
      <Follow />
      <Footer />
      <ToastContainer /> {/* Render ToastContainer globally */}
      <JavaScript />
    </div>
  );
}

export default Home;
