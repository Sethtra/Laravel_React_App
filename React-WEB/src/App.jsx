import './App.css'
import { BrowserRouter as Router, Routes, Route } from "react-router-dom"; // Ensure BrowserRouter is imported
import Register from './Pages/Auth/Register';
import Login from './Pages/Auth/Login';
import { useContext } from 'react';
import { AppContext } from './Context/AppContext';
import Home from "./Pages/User/Home";
import Shop from "./Pages/User/Shops";
import Cart from "./Pages/User/Cart";
import ProductDetail from "./Pages/User/ProductDetail";
import Checkout from "./Pages/User/Checkout";
import Dashboard from './Pages/Admin/Dashboard';
import Categorie from './Pages/Admin/Views/Categorie';
import CreateCategory from './Pages/Admin/Components/CreateCategory';
import EditCategory from './Pages/Admin/Components/EditCategory';
import ProductList from './Pages/Admin/Views/ProductList';
import EditProduct from './Pages/Admin/Components/EditProduct';
import CreateProduct from './Pages/Admin/Components/CreateProduct';
import OrderLists from "./Pages/Admin/Views/OrderList";
import ViewOrder from './Pages/Admin/Components/View_Order';




export default function App() {
  const { user } = useContext(AppContext);

  return (
    <Router>
      <Routes>
        <Route>
          <Route path="/" element={<Home />} />
          <Route path="/shop" element={<Shop />} />
          <Route path="/cart" element={<Cart />} />

          <Route path="/product" element={<ProductDetail />} />
          <Route path="/product/:id" element={<ProductDetail />} />

          <Route path="/checkout" element={<Checkout />} />
          <Route path="/register" element={user ? <Home /> : <Register />} />
          <Route path="/login" element={user ? <Home /> : <Login />} />

          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/category" element={<Categorie />} />
          <Route path="/category/create" element={<CreateCategory />} />
          <Route path="/category/edit/:id" element={<EditCategory />} />

          <Route path="/products" element={<ProductList />} />
          <Route path="/products/create" element={<CreateProduct />} />
          <Route path="/products/edit/:id" element={<EditProduct />} />

          <Route path="/orders" element={<OrderLists />} />
          <Route path="/orders/view/:id" element={<ViewOrder />} />
        </Route>
      </Routes>
    </Router>
  );
}
