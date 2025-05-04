import React from "react";
import { NavLink } from "react-router-dom"; // Use NavLink for active state

function Sidebar() {
  return (
    <>
      <aside
        className="sidenav navbar navbar-vertical navbar-expand-xs border-radius-lg fixed-start ms-2 bg-white my-2"
        id="sidenav-main"
      >
        <div className="sidenav-header">
          <i
            className="fas fa-times p-3 cursor-pointer text-dark opacity-5 position-absolute end-0 top-0 d-none d-xl-none"
            aria-hidden="true"
            id="iconSidenav"
          />
          <a
            className="navbar-brand px-4 py-3 m-0"
            href="https://demos.creative-tim.com/material-dashboard/pages/dashboard"
            target="_blank"
          >
            <img
              src="/assets/img/logo-ct-dark.png"
              className="navbar-brand-img"
              width={26}
              height={26}
              alt="main_logo"
            />
            <span className="ms-1 text-sm text-dark">Creative Tim</span>
          </a>
        </div>
        <hr className="horizontal dark mt-0 mb-2" />
        <div
          className="collapse navbar-collapse w-auto"
          id="sidenav-collapse-main"
        >
          <ul className="navbar-nav">
            <li className="nav-item">
              <NavLink
                to="/dashboard" // Use NavLink for active state
                className={({ isActive }) =>
                  isActive
                    ? "nav-link active text-white bg-dark" // Active link styles
                    : "nav-link text-dark"
                }
              >
                <i className="material-symbols-rounded opacity-5">dashboard</i>
                <span className="nav-link-text ms-1">Dashboard</span>
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                to="/category"
                className={({ isActive }) =>
                  isActive
                    ? "nav-link active text-white bg-dark" // Active link styles
                    : "nav-link text-dark"
                }
              >
                <i className="material-symbols-rounded opacity-5">table_view</i>
                <span className="nav-link-text ms-1">Categorie</span>
              </NavLink>
            </li>

            <li className="nav-item">
              <NavLink
                to="/products"
                className={({ isActive }) =>
                  isActive
                    ? "nav-link active text-white bg-dark" // Active link styles
                    : "nav-link text-dark"
                }
              >
                <i className="material-symbols-rounded opacity-5">
                  receipt_long
                </i>
                <span className="nav-link-text ms-1">Products</span>
              </NavLink>
            </li>

            <li className="nav-item">
              <NavLink
                to="/orders"
                className={({ isActive }) =>
                  isActive
                    ? "nav-link active text-white bg-dark" // Active link styles
                    : "nav-link text-dark"
                }
              >
                <i className="material-symbols-rounded opacity-5">view_in_ar</i>
                <span className="nav-link-text ms-1">Order List</span>
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                to="/rtl"
                className={({ isActive }) =>
                  isActive
                    ? "nav-link active text-white bg-dark" // Active link styles
                    : "nav-link text-dark"
                }
              >
                <i className="material-symbols-rounded opacity-5">
                  format_textdirection_r_to_l
                </i>
                <span className="nav-link-text ms-1">RTL</span>
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                to="/notifications"
                className={({ isActive }) =>
                  isActive
                    ? "nav-link active text-white bg-dark" // Active link styles
                    : "nav-link text-dark"
                }
              >
                <i className="material-symbols-rounded opacity-5">
                  notifications
                </i>
                <span className="nav-link-text ms-1">Notifications</span>
              </NavLink>
            </li>
            <li className="nav-item mt-3">
              <h6 className="ps-4 ms-2 text-uppercase text-xs text-dark font-weight-bolder opacity-5">
                Account pages
              </h6>
            </li>
            <li className="nav-item">
              <NavLink
                to="/profile"
                className={({ isActive }) =>
                  isActive
                    ? "nav-link active text-white bg-dark" // Active link styles
                    : "nav-link text-dark"
                }
              >
                <i className="material-symbols-rounded opacity-5">person</i>
                <span className="nav-link-text ms-1">Profile</span>
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                to="/sign-in"
                className={({ isActive }) =>
                  isActive
                    ? "nav-link active text-white bg-dark" // Active link styles
                    : "nav-link text-dark"
                }
              >
                <i className="material-symbols-rounded opacity-5">login</i>
                <span className="nav-link-text ms-1">Sign In</span>
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                to="/sign-up"
                className={({ isActive }) =>
                  isActive
                    ? "nav-link active text-white bg-dark" // Active link styles
                    : "nav-link text-dark"
                }
              >
                <i className="material-symbols-rounded opacity-5">assignment</i>
                <span className="nav-link-text ms-1">Sign Up</span>
              </NavLink>
            </li>
          </ul>
        </div>
      </aside>
    </>
  );
}

export default Sidebar;