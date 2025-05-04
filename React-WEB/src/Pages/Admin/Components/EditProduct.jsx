import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import axios from "axios";

function EditProduct() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [categories, setCategories] = useState([]);
  const [product, setProduct] = useState({
    name: "",
    sku: "",
    image: null,
    quantity: "",
    price: "",
    description: "",
    status: "available",
    category: "", // We will store the category name here
  });
  const [imagePreview, setImagePreview] = useState("");

  useEffect(() => {
    fetchProduct();
    fetchCategories();
  }, [id]);

  const fetchProduct = async () => {
    try {
      const response = await axios.get(
        `http://localhost:8000/api/products/${id}`
      );
      setProduct(response.data);
      setImagePreview(`http://localhost:8000/storage/${response.data.image}`);
    } catch (error) {
      console.error("Error fetching product details:", error);
    }
  };

  const fetchCategories = async () => {
    try {
      const response = await axios.get("http://localhost:8000/api/categories");
      setCategories(response.data);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setProduct((prev) => ({ ...prev, [name]: value }));
  };

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      const validTypes = ["image/jpeg", "image/jpg", "image/png"];
      const maxSize = 2 * 1024 * 1024;
      if (!validTypes.includes(file.type)) {
        alert("Only JPG, JPEG, and PNG images are allowed.");
        return;
      }
      if (file.size > maxSize) {
        alert("Image size should be less than 2MB.");
        return;
      }
      const reader = new FileReader();
      reader.onloadend = () => {
        setProduct((prev) => ({ ...prev, image: file }));
        setImagePreview(reader.result);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (
      !product.name ||
      !product.sku ||
      !product.category ||
      !product.quantity ||
      !product.price ||
      !product.description
    ) {
      alert("Please fill in all the fields.");
      return;
    }

    const formData = new FormData();
    formData.append("name", product.name);
    formData.append("sku", product.sku);
    formData.append("category", product.category); // Send category name
    formData.append("quantity", product.quantity);
    formData.append("price", product.price);
    formData.append("description", product.description);
    formData.append("status", product.status);

    // Only append the image if it's updated
    if (product.image) {
      formData.append("image", product.image);
    } else {
      // If no new image is provided, send the existing image URL
      formData.append("image", product.image); // This will send the same image URL (ensure the backend can handle this)
    }

    formData.append("_method", "PUT"); // if your API expects a method override

    try {
      const response = await axios.post(
        `http://localhost:8000/api/products/${id}`,
        formData
      );
      if (response.status === 200) {
        alert("Product updated successfully");
        navigate("/products");
      } else {
        alert("Failed to update product");
      }
    } catch (error) {
      console.error("Error updating product:", error.response);
      alert("Error updating product. Check console for details.");
    }
  };

  return (
    <div className="container">
      <h1>Edit Product</h1>
      <form onSubmit={handleSubmit}>
        {/* Product Name */}
        <div className="form-group">
          <label htmlFor="name">Product Name</label>
          <input
            id="name"
            type="text"
            className="form-control"
            name="name"
            value={product.name}
            onChange={handleInputChange}
            required
          />
        </div>

        {/* SKU */}
        <div className="form-group">
          <label htmlFor="sku">SKU</label>
          <input
            id="sku"
            type="text"
            className="form-control"
            name="sku"
            value={product.sku}
            onChange={handleInputChange}
            required
          />
        </div>

        {/* Category Dropdown */}
        <div className="form-group">
          <label htmlFor="category">Category</label>
          <select
            id="category"
            className="form-control"
            name="category"
            value={product.category}
            onChange={handleInputChange}
            required
          >
            <option value="">-- Select Category --</option>
            {categories.map((cat) => (
              <option key={cat.id} value={cat.name}>
                {cat.name}
              </option>
            ))}
          </select>
        </div>

        {/* Image Upload */}
        <div className="form-group">
          <label htmlFor="image">Image</label>
          <input
            id="image"
            type="file"
            className="form-control"
            accept="image/*"
            onChange={handleImageChange}
          />
          {imagePreview && (
            <div>
              <h5>Image Preview:</h5>
              <img src={imagePreview} alt="Product Preview" width="200" />
            </div>
          )}
        </div>

        {/* Quantity */}
        <div className="form-group">
          <label htmlFor="quantity">Quantity</label>
          <input
            id="quantity"
            type="number"
            className="form-control"
            name="quantity"
            value={product.quantity}
            onChange={handleInputChange}
            required
          />
        </div>

        {/* Price */}
        <div className="form-group">
          <label htmlFor="price">Price</label>
          <input
            id="price"
            type="number"
            className="form-control"
            name="price"
            value={product.price}
            onChange={handleInputChange}
            required
          />
        </div>

        {/* Description */}
        <div className="form-group">
          <label htmlFor="description">Description</label>
          <textarea
            id="description"
            className="form-control"
            name="description"
            value={product.description}
            onChange={handleInputChange}
            required
          />
        </div>

        {/* Status */}
        <div className="form-group">
          <label htmlFor="status">Status</label>
          <select
            id="status"
            className="form-control"
            name="status"
            value={product.status}
            onChange={handleInputChange}
          >
            <option value="available">Available</option>
            <option value="unavailable">Unavailable</option>
          </select>
        </div>

        <button type="submit" className="btn btn-primary">
          Update Product
        </button>
      </form>
    </div>
  );
}

export default EditProduct;