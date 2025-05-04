import React, { useEffect, useState } from "react";
import Sidebar from "../Components/sidebar";
import Header from "../Components/header";
import Scripts from "../Components/Scripts";
import { Link } from "react-router-dom";
import axios from "axios";

function Categorie() {
  const [categories, setCategories] = useState([]);

  useEffect(() => {
    fetchCategories();
  }, []);

  const fetchCategories = async () => {
    try {
      const response = await axios.get("http://localhost:8000/api/categories");
      setCategories(response.data);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm("Are you sure you want to delete this category?")) {
      try {
        await axios.delete(`http://localhost:8000/api/categories/${id}`);
        fetchCategories();
      } catch (error) {
        console.error("Error deleting category:", error);
      }
    }
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
            <div
              className="collapse navbar-collapse mt-sm-0 mt-2 me-md-0 me-sm-4"
              id="navbar"
            >
              <div className="ms-md-auto pe-md-3 d-flex align-items-center">
                <div className="input-group input-group-outline">
                  <label className="form-label">Type here...</label>
                  <input type="text" className="form-control" />
                </div>
              </div>
              <ul className="navbar-nav d-flex align-items-center  justify-content-end">
                <li className="nav-item d-xl-none ps-3 d-flex align-items-center">
                  <a
                    href="javascript:;"
                    className="nav-link text-body p-0"
                    id="iconNavbarSidenav"
                  >
                    <div className="sidenav-toggler-inner">
                      <i className="sidenav-toggler-line" />
                      <i className="sidenav-toggler-line" />
                      <i className="sidenav-toggler-line" />
                    </div>
                  </a>
                </li>
                <li className="nav-item px-3 d-flex align-items-center">
                  <a href="javascript:;" className="nav-link text-body p-0">
                    <i className="material-symbols-rounded fixed-plugin-button-nav">
                      settings
                    </i>
                  </a>
                </li>
                <li className="nav-item dropdown pe-3 d-flex align-items-center">
                  <a
                    href="javascript:;"
                    className="nav-link text-body p-0"
                    id="dropdownMenuButton"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                  >
                    <i className="material-symbols-rounded">notifications</i>
                  </a>
                </li>
                <li className="nav-item d-flex align-items-center">
                  <a
                    href="/"
                    className="nav-link text-body font-weight-bold px-0"
                  >
                    <i className="material-symbols-rounded">account_circle</i>
                  </a>
                </li>
              </ul>
            </div>
          </div>
        </nav>

        <div className="container-fluid py-2">
          <div className="row">
            <div className="col-12">
              <div className="card my-4">
                <div className="card-header p-0 position-relative mt-n4 mx-3 z-index-2">
                  <div className="bg-gradient-dark shadow-dark border-radius-lg pt-4 pb-3 d-flex justify-content-between align-items-center px-3">
                    <h6 className="text-white text-capitalize">Category Table</h6>
                    <Link to="/category/create" className="btn btn-light text-black text-capitalize">New Category</Link>
                  </div>
                </div>
                <div className="card-body px-0 pb-2">
                  <div className="table-responsive p-0">
                    <table className="table align-items-center mb-0">
                      <thead>
                        <tr>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">N.o</th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">Name</th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10 ps-2">Description</th>
                          <th className="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        {categories.map((category, index) => (
                          <tr key={category.id}>
                            <td className="ps-4">
                              <h6 className="mb-0 text-sm">{index + 1}</h6>
                            </td>
                            <td>
                              <h6 className="mb-0 text-sm ps-3">{category.name}</h6>
                            </td>
                            <td>
                              <p className="text-xs text-secondary mb-0">{category.description}</p>
                            </td>
                            <td className="align-middle text-center">
                              <Link to={`/category/edit/${category.id}`} className="btn btn-dark btn-sm me-2">Edit</Link>
                              <button onClick={() => handleDelete(category.id)} className="btn btn-dark btn-sm">Delete</button>
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

export default Categorie;
