import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import axios from "axios";
import Header from "../Components/header";
import Sidebar from "../Components/sidebar";
import Scripts from "../Components/Scripts";

function ViewOrder() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [billing, setBilling] = useState(null);
  const [isEditing, setIsEditing] = useState(false);
  const [formFields, setFormFields] = useState({});

  useEffect(() => {
    fetchBilling();
  }, [id]);

  const fetchBilling = async () => {
    try {
      const response = await axios.get(
        `http://localhost:8000/api/billing/${id}`
      );
      setBilling(response.data);
      setFormFields(response.data); // Pre-fill edit form
    } catch (error) {
      console.error("Error fetching billing:", error);
    }
  };

  const handleFormChange = (e) => {
    setFormFields({
      ...formFields,
      [e.target.name]: e.target.value,
    });
  };

  const handleUpdate = async () => {
    try {
      await axios.put(`http://localhost:8000/api/billing/${id}`, formFields);
      setBilling(formFields);
      setIsEditing(false);
    } catch (error) {
      console.error("Error updating billing:", error);
    }
  };

  if (!billing) return <div>Loading...</div>;

  return (
    <>
      <Header />
      <Scripts />
      <Sidebar />

      <main className="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
        <div className="container-fluid py-4">
          <div className="row">
            <div className="col-12">
              <div className="card my-4">
                {/* Header with Back and Edit */}
                <div className="card-header p-0 position-relative mt-n4 mx-3 z-index-2">
                  <div className="bg-gradient-dark shadow-dark border-radius-lg pt-4 pb-3 px-4 d-flex justify-content-between align-items-center">
                    <h6 className="text-white mb-0">Order Details</h6>
                    <div className="d-flex justify-content-between">
                      <button
                        className="btn btn-light btn-sm"
                        onClick={() => navigate("/orders")}
                      >
                        {isEditing ? "Cancel" : "Back to Order"}
                      </button>

                      {/* Add space between the two buttons */}
                      <button
                        className="btn btn-light btn-sm ms-3"
                        onClick={() => setIsEditing(!isEditing)}
                      >
                        {isEditing ? "Cancel" : "Edit"}
                      </button>
                    </div>
                  </div>
                </div>

                {/* Content Body */}
                <div className="card-body">
                  {!isEditing ? (
                    <div className="row">
                      {/* Non-editable details with borders and padding */}
                      <div className="col-md-6 mb-3">
                        <label className="form-label fw-bold">
                          Tracking ID
                        </label>
                        <div className="border p-2 rounded">
                          {billing.order_tracking_id}
                        </div>
                      </div>
                      <div className="col-md-6 mb-3">
                        <label className="form-label fw-bold">Name</label>
                        <div className="border p-2 rounded">
                          {billing.first_name} {billing.last_name}
                        </div>
                      </div>
                      <div className="col-md-6 mb-3">
                        <label className="form-label fw-bold">Phone</label>
                        <div className="border p-2 rounded">
                          {billing.phone}
                        </div>
                      </div>
                      <div className="col-md-6 mb-3">
                        <label className="form-label fw-bold">Email</label>
                        <div className="border p-2 rounded">
                          {billing.email}
                        </div>
                      </div>
                      <div className="col-md-6 mb-3">
                        <label className="form-label fw-bold">
                          Total Amount
                        </label>
                        <div className="border p-2 rounded">
                          ${billing.total_amount}
                        </div>
                      </div>
                      <div className="col-md-6 mb-3">
                        <label className="form-label fw-bold">Country</label>
                        <div className="border p-2 rounded">
                          {billing.country}
                        </div>
                      </div>
                      <div className="col-md-6 mb-3">
                        <label className="form-label fw-bold">
                          Street Address
                        </label>
                        <div className="border p-2 rounded">
                          {billing.street_address}
                        </div>
                      </div>
                      <div className="col-md-6 mb-3">
                        <label className="form-label fw-bold">City</label>
                        <div className="border p-2 rounded">
                          {billing.town_city}
                        </div>
                      </div>
                      <div className="col-md-6 mb-3">
                        <label className="form-label fw-bold">Postcode</label>
                        <div className="border p-2 rounded">
                          {billing.postcode_zip}
                        </div>
                      </div>
                    </div>
                  ) : (
                    <div className="row">
                      {/* Editable fields with matching styling */}
                      {[
                        { label: "First Name", name: "first_name" },
                        { label: "Last Name", name: "last_name" },
                        { label: "Phone", name: "phone" },
                        { label: "Email", name: "email" },
                        { label: "Country", name: "country" },
                        { label: "Street Address", name: "street_address" },
                        { label: "City", name: "town_city" },
                        { label: "Postcode", name: "postcode_zip" },
                      ].map((field) => (
                        <div className="col-md-6 mb-4" key={field.name}>
                          <label className="form-label fw-bold">
                            {field.label}
                          </label>
                          <input
                            type="text"
                            className="form-control border p-2 rounded"
                            name={field.name}
                            value={formFields[field.name] || ""}
                            onChange={handleFormChange}
                            placeholder={`Enter ${field.label}`}
                          />
                        </div>
                      ))}
                      <div className="col-12 d-flex justify-content-end mt-4">
                        <button
                          className="btn btn-primary mt-3 px-4 py-2 shadow-lg border-0 rounded"
                          onClick={handleUpdate}
                        >
                          Save Changes
                        </button>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </>
  );
}

export default ViewOrder;
