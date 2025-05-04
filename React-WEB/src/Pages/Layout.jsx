import { useContext } from "react";
import { Link, Outlet, useNavigate } from "react-router-dom";
import { AppContext } from "../Context/AppContext";

export default function Layout() {
  const { user, token, setUser, setToken } = useContext(AppContext);
  const navigate = useNavigate()

  async function handleLogout(e) {
    e.preventDefault();

    const res = await fetch("/api/logout", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`, // Corrected from 'header' to 'headers'
        "Content-Type": "application/json", // Add content type if needed
      },
    });

    const data = await res.json();
    console.log(data);

    if (res.ok) {
      setUser(null);
      setToken(null);
      localStorage.removeItem("token");
      navigate("/login"); // Redirect to login page after logout
    } else {
      console.error("Logout failed:", data);
    }
  }

  return (
    <>
      <header>
        <nav>
          <Link to="/">
            Home
          </Link>

          {user ? (
            <div>
              <p >Welcome Back {user.name}</p>
              <form onSubmit={handleLogout}>
                <button >Logout</button>
              </form>
            </div>
          ) : (
            <div>
              <Link to="/register">
                Register
              </Link>
              <Link to="/login">
                Login
              </Link>
              <Link to="/create">
                Create Product
              </Link>
            </div>
          )}
        </nav>
      </header>

      <main>
        <Outlet />
      </main>
    </>
  );
}
