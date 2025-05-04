// src/Pages/EditCategory.jsx
import { useState, useEffect } from "react";
import axios from "axios";
import Sidebar from "./sidebar";
import Header from "./header";
import Scripts from "./Scripts";
import { useNavigate, useParams } from "react-router-dom";

const API_URL = "http://127.0.0.1:8000/api/categories";

export default function EditCategory() {
  const { id } = useParams();
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchCategory = async () => {
      try {
        const response = await axios.get(`${API_URL}/${id}`);
        setName(response.data.name);
        setDescription(response.data.description);
      } catch (error) {
        console.error("Error fetching category", error);
      }
    };

    fetchCategory();
  }, [id]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      await axios.put(`${API_URL}/${id}`, { name, description });
      navigate("/category"); // Redirect to category list after successful update
    } catch (error) {
      console.error("Error editing category", error);
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
        <div className="container-fluid py-2">
          <div className="row">
            <div className="col-12">
              <div className="card my-4">
                <div className="card-header p-0 position-relative mt-n4 mx-3 z-index-2">
                  <div className="bg-gradient-dark shadow-dark border-radius-lg pt-4 pb-3 d-flex justify-content-between align-items-center px-3">
                    <h6 className="text-white text-capitalize">Edit Category</h6>
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
                              {loading ? "Updating..." : "Update Category"}
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
