import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
//removed shopping cart icon

function Navbar3({ pageName }) {
  const [loggedInUser, setLoggedInUser] = useState([]);
    const navigate = useNavigate();
  
    useEffect(() => {
      const fetchUserData = async () => {
        const token = localStorage.getItem('token');
        if (token) {
          try {
          const res = await fetch('http://localhost:3000/getUser', {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          },
        });
        
        if (res.ok) {
          const data = await res.json();
          setLoggedInUser(data);
        } else {
          console.error('Failed to fetch user data: ', res.status, res.statusText);
          localStorage.removeItem('token');
          setLoggedInUser([]);
        } 
      } catch (error) {
          console.error("error fetching user data", error);
          localStorage.removeItem('token');
          setLoggedInUser([]);
          
        }
      }
    };
  
    fetchUserData();
    }, []);

  const seeOrders = (e) => {
    e.preventDefault();
    navigate('/myOrders');
  };

  const seeDashboard = (e) => {
    e.preventDefault();
    navigate('/dashboard');
  };

  const logOut = (e) => {
    e.preventDefault();
    localStorage.removeItem('token');
    navigate('/login');
  };

  return (
    <nav className="bg-green-900 text-white flex justify-between items-center px-6 py-4" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
      <div className="text-3xl font-bold">
        <span className="text-white">TAGA</span>
        <span className="text-[#fc9a01]">BOOK-IT</span>
        <span className="text-white"> | {pageName}</span>
      </div>
      <div className="flex items-center gap-8">
        <span className="text-white text-lg font-medium">Hello, {loggedInUser.username || loggedInUser.firstName || 'User'}!</span>
        <button onClick={seeDashboard} className="hover:underline">Dashboard</button>
        <button onClick={seeOrders} className="hover:underline">My Orders</button>
        <button onClick={logOut} className="hover:underline">Log out</button>
      </div>
    </nav>
  );
}

export default Navbar3;
