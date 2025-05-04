import { createContext, useEffect, useState } from "react";

export const AppContext = createContext();

export default function AppProvider({ children }) {
  const [token, setToken] = useState(localStorage.getItem("token"));
  const [user, setUser] = useState(null);

  // Login function to authenticate the user and get the token
  async function login(email, password) {
    const res = await fetch("/api/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ email, password }), // Send email and password for login
    });
    const data = await res.json();

    if (res.ok) {
      // Store the token in localStorage
      localStorage.setItem("token", data.token);
      setToken(data.token); // Update the token state

      // Fetch user data after successful login
      getUser(data.token);
    } else {
      console.error("Login failed:", data.errors); // Handle failed login
    }
  }

  // Get the user's data using the token
  async function getUser(token) {
    const res = await fetch("/api/user", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`, // Send the token in the Authorization header
        "Content-Type": "application/json",
      },
      credentials: "include", // Important for Sanctum
    });
    const data = await res.json();

    if (res.ok) {
      setUser(data); // Set the user state with the fetched user data
    } else {
      console.error("Error fetching user:", data); // Handle error fetching user data
    }
  }

  useEffect(() => {
    if (token) {
      getUser(token); // Fetch user if token exists
    }
  }, [token]);

  return (
    <AppContext.Provider value={{ token, setToken, user, setUser, login }}>
      {children}
    </AppContext.Provider>
  );
}