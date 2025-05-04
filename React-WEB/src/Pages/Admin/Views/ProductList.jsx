import React, { useEffect, useState } from "react";
import Sidebar from "../Components/sidebar";
import Header from "../Components/header";
import Scripts from "../Components/Scripts";
import { Link } from "react-router-dom";
import axios from "axios";

function ProductList() {
  const [products, setProducts] = useState([]);

  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    try {
      const response = await axios.get("http://localhost:8000/api/products");
      setProducts(response.data);
    } catch (error) {
      console.error("Error fetching products:", error);
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm("Are you sure you want to delete this product?")) {
      try {
        await axios.delete(`http://localhost:8000/api/products/${id}`);
        fetchProducts();
      } catch (error) {
        console.error("Error deleting product:", error);
      }
    }
  };

  const truncateText = (text, wordLimit) => {
    const words = text.split(" ");
    if (words.length > wordLimit) {
      return words.slice(0, wordLimit).join(" ") + "...";
    }
    return text;
  };

  return (
    <>
      <Header />
      <Scripts />
      <Sidebar />
      <main className="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
        <nav
          className="navbar navbar-main navbar-expand-lg px-0 mx-3 shadow-none border-radius-xl"
          id="navbarBlur"
          data-scroll="true"
        >
          <div className="container-fluid py-1 px-3">
            <nav aria-label="breadcrumb">
              <ol className="breadcrumb bg-transparent mb-0 pb-0 pt-1 px-0 me-sm-6 me-5">
                <li className="breadcrumb-item text-sm">
                  <a className="opacity-5 text-dark" href="javascript:;">
                    Pages
                  </a>
                </li>
                <li
                  className="breadcrumb-item text-sm text-dark active"
                  aria-current="page"
                >
                  Dashboard
                </li>
              </ol>
            </nav>
          </div>
        </nav>

        <div className="container-fluid py-2">
          <div className="row">
            <div className="col-12">
              <div className="card my-4">
                <div className="card-header p-0 position-relative mt-n4 mx-3 z-index-2">
                  <div className="bg-gradient-dark shadow-dark border-radius-lg pt-4 pb-3 d-flex justify-content-between align-items-center px-3">
                    <h6 className="text-white text-capitalize">
                      Product Table
                    </h6>
                    <Link
                      to="/products/create"
                      className="btn btn-light text-black text-capitalize"
                    >
                      New Product
                    </Link>
                  </div>
                </div>
                <div className="card-body px-0 pb-2">
                  <div className="table-responsive p-0">
                    <table className="table align-items-center mb-0">
                      <thead>
                        <tr>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">
                            N.o
                          </th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">
                            Image
                          </th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">
                            Name
                          </th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10 ps-2">
                            Category
                          </th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10 ps-2">
                            Description
                          </th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10 ps-4">
                            Price
                          </th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10 ps-2">
                            Status
                          </th>
                          <th className="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">
                            Actions
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        {products.map((product, index) => (
                          <tr key={product.id}>
                            <td className="ps-4">
                              <h6 className="mb-0 text-sm">{index + 1}</h6>
                            </td>
                            <td>
                              {/* Display the product image */}
                              {product.image ? (
                                <img
                                  src={`http://localhost:8000/storage/${product.image}`}
                                  alt={product.name}
                                  width="50"
                                  height="50"
                                />
                              ) : (
                                <span className="text-secondary text-xs">
                                  No image
                                </span>
                              )}
                            </td>
                            <td>
                              <h6 className="mb-0 text-sm ps-3">
                                {truncateText(product.name, 5)}{" "}
                                {/* Truncate Name */}
                              </h6>
                            </td>
                            <td>
                              <p className="text-xs text-secondary mb-0 truncate-text-category">
                                {truncateText(product.category, 3)}{" "}
                                {/* Truncate Category */}
                              </p>
                            </td>
                            <td>
                              <p className="text-xs text-secondary mb-0 truncate-description">
                                {truncateText(product.description, 10)}{" "}
                                {/* Truncate Description */}
                              </p>
                            </td>
                            <td>
                              <p className="text-xs text-secondary mb-0">
                                ${product.price}
                              </p>
                            </td>
                            <td>
                              <p className="text-xs text-secondary mb-0">
                                {product.status === "available"
                                  ? "Available"
                                  : "Unavailable"}
                              </p>
                            </td>
                            <td className="align-middle text-center">
                              <Link
                                to={`/products/edit/${product.id}`}
                                className="btn btn-dark btn-sm me-2"
                              >
                                Edit
                              </Link>
                              <button
                                onClick={() => handleDelete(product.id)}
                                className="btn btn-dark btn-sm"
                              >
                                Delete
                              </button>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </>
  );
}

export default ProductList;