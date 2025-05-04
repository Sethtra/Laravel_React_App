import React, { useEffect, useState } from "react";
import Sidebar from "../Components/sidebar";
import Header from "../Components/header";
import Scripts from "../Components/Scripts";
import { Link } from "react-router-dom";
import axios from "axios";

function OrderList() {
  const [billings, setBillings] = useState([]);

  useEffect(() => {
    fetchBillings();
  }, []);

  const fetchBillings = async () => {
    try {
      const response = await axios.get("http://localhost:8000/api/billing");
      setBillings(response.data);
    } catch (error) {
      console.error("Error fetching billing records:", error);
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
                  Orders
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
                    <h6 className="text-white text-capitalize">Order Table</h6>
                  </div>
                </div>
                <div className="card-body px-0 pb-2">
                  <div className="table-responsive p-0">
                    <table className="table align-items-center mb-0">
                      <thead>
                        <tr>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">
                            ID
                          </th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">
                            Tracking ID
                          </th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">
                            Name
                          </th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">
                            Phone
                          </th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">
                            Email
                          </th>
                          <th className="text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">
                            Total Amount
                          </th>
                          <th className="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-10">
                            Actions
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        {billings && billings.length > 0 ? (
                          billings.map((order) => (
                            <tr key={order.id}>
                              <td className="ps-4">
                                <h6 className="mb-0 text-sm">{order.id}</h6>
                              </td>
                              <td>
                                <h6 className="mb-0 text-sm">
                                  {order.order_tracking_id}
                                </h6>
                              </td>
                              <td>
                                <h6 className="mb-0 text-sm ps-3">
                                  {order.first_name} {order.last_name}
                                </h6>
                              </td>
                              <td>
                                <p className="text-xs text-secondary mb-0">
                                  {order.phone}
                                </p>
                              </td>
                              <td>
                                <p className="text-xs text-secondary mb-0">
                                  {order.email}
                                </p>
                              </td>
                              <td>
                                <p className="text-xs text-secondary mb-0">
                                  ${parseFloat(order.total_amount).toFixed(2)}
                                </p>
                              </td>
                              <td className="align-middle text-center">
                                <Link
                                  to={`/orders/view/${order.id}`}
                                  className="btn btn-dark btn-sm me-2"
                                >
                                  View
                                </Link>
                              </td>
                            </tr>
                          ))
                        ) : (
                          <tr>
                            <td
                              colSpan="7"
                              className="text-center text-xs text-secondary"
                            >
                              No orders found.
                            </td>
                          </tr>
                        )}
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

export default OrderList;