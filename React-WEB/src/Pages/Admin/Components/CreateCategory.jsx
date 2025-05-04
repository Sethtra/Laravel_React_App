import { useState } from "react";
import axios from "axios";
import Header from "./header";
import Sidebar from "./sidebar";
import Scripts from "./Scripts";
import { useNavigate } from "react-router-dom";

const API_URL = "http://127.0.0.1:8000/api/categories";

export default function CreateCategory() {
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      await axios.post(API_URL, { name, description });
      navigate("/category"); // Redirect to category list after successful creation
    } catch (error) {
      console.error("Error creating category", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <Header />
      <Sidebar />
      <Scripts />

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
                  </div>
                </div>
                <div className="card-body px-0 pb-2">
                  <div className="table-responsive p-3">
                    <table className="table table-sm align-items-center mb-0 w-100">
                      <thead>
                        <tr>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Name</th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Description</th>
                          <th className="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        {/* FORM ROW */}
                        <tr>
                          <td>
                            <input
                              type="text"
                              className="form-control ps-3 border border-dark"
                              placeholder="Category Name"
                              value={name}
                              onChange={(e) => setName(e.target.value)}
                              required
                            />
                          </td>
                          <td>
                            <input
                              type="text"
                              className="form-control ps-4 border border-dark"
                              placeholder="Description"
                              value={description}
                              onChange={(e) => setDescription(e.target.value)}
                            />
                          </td>
                          <td className="align-middle text-center pt-3">
                            <button
                              onClick={handleSubmit}
                              className="btn btn-dark btn-sm"
                              disabled={loading}
                            >
                              {loading ? "Creating..." : "Create"}
                            </button>
                          </td>
                        </tr>
                        {/* END FORM ROW */}
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
