import React, { useState, useEffect } from "react";
import { useParams } from 'react-router-dom';
import Header from "../../Components/header";
import Pageheader from "../../Components/pageheader";
import JavaScript from "../../Components/javascript";
import Nav from "../../Components/nav";
import ProductDetailBody from "../../Components/productdetailbody";
import Footer from "../../Components/footer";
import { ToastContainer } from "react-toastify"; // Import ToastContainer here


function ProductDetail() {
  const [product, setProduct] = useState(null);
  const { id } = useParams(); // Get the product ID from the URL

  useEffect(() => {
    // Fetch the product details by ID
    fetch(`http://localhost:8000/api/products/${id}`)
      .then((res) => res.json())
      .then((data) => {
        setProduct(data); // Set the fetched product data
      })
      .catch((err) => {
        console.error("Error fetching product details:", err);
      });
  }, [id]);

  if (!product) {
    return <div>Loading...</div>; // Show loading state until the product is fetched
  }

  return (
    <div>
      <Header />
      <JavaScript />
      <Nav />
      <Pageheader />
      <ProductDetailBody product={product} />
      <Footer />
      <ToastContainer /> {/* Render ToastContainer globally */}
    </div>
  );
}

export default ProductDetail;
