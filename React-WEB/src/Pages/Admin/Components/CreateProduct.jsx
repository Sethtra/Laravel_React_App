import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom"; // ✅ Import useNavigate

function CreateProduct() {
  const navigate = useNavigate(); // ✅ Initialize hook

  const [categories, setCategories] = useState([]);
  const [product, setProduct] = useState({
    name: "",
    sku: "",
    image: null, // Update: image is now a file, not base64
    quantity: "",
    price: "",
    description: "",
    status: "available",
    category: "",
  });

  const [imagePreview, setImagePreview] = useState("");

  useEffect(() => {
    fetchCategories();
  }, []);

  const fetchCategories = async () => {
    try {
      const response = await fetch("http://localhost:8000/api/categories");
      const data = await response.json();
      setCategories(data);
    } catch (error) {
      console.error("Error fetching categories:", error);
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setProduct((prevProduct) => ({
      ...prevProduct,
      [name]: value,
    }));
  };

  const handleImageChange = (e) => {
    const file = e.target.files[0];

    if (file) {
      const validTypes = ["image/jpeg", "image/jpg", "image/png"];
      const maxSize = 2 * 1024 * 1024; // 2MB

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
        setProduct((prevProduct) => ({
          ...prevProduct,
          image: file, // Save the file itself
        }));
        setImagePreview(reader.result); // Preview image
      };

      reader.readAsDataURL(file);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    // Check if all required fields are filled
    if (
      !product.name ||
      !product.sku ||
      !product.category ||
      !product.image ||
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
    formData.append("category", product.category);
    formData.append("image", product.image); // Send the image file directly
    formData.append("quantity", product.quantity);
    formData.append("price", product.price);
    formData.append("description", product.description);
    formData.append("status", product.status);

    try {
      const response = await fetch("http://localhost:8000/api/products", {
        method: "POST",
        body: formData, // Send the form data
      });

      if (response.ok) {
        alert("Product created successfully");
        navigate("/products"); // ✅ Redirect after success
      } else {
        alert("Failed to create product");
      }
    } catch (error) {
      console.error("Error creating product:", error);
      alert("Error creating product");
    }
  };

  return (
    <div className="container">
      <h1>Create New Product</h1>
      <form onSubmit={handleSubmit}>
        {/* Product Name */}
        <div className="form-group">
          <label htmlFor="name">Product Name</label>
          <input
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
            type="file"
            className="form-control"
            accept="image/*"
            onChange={handleImageChange}
            required
          />
          {imagePreview && (
            <div>
              <h5>Preview:</h5>
              <img src={imagePreview} alt="Preview" width="200" />
            </div>
          )}
        </div>

        {/* Quantity */}
        <div className="form-group">
          <label htmlFor="quantity">Quantity</label>
          <input
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
          Submit
        </button>
      </form>
    </div>
  );
}

export default CreateProduct;