import React from 'react';
import { FaShoppingCart } from 'react-icons/fa';
import { useNavigate } from 'react-router-dom';

// contents: shopping cart icon, dashboard, my orders, and log out button
function Navbar2( { pageName }) {
  const navigate = useNavigate();

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
    navigate('/logOut');
  };

  const shoppingCart = (e) => {
    e.preventDefault();
    navigate('/shoppingCart');
  };

  return (
    <nav className="bg-green-900 text-white flex justify-between items-center px-6 py-4" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
      <div className="text-3xl font-bold">
        <span className="text-white">TAGA</span>
        <span className="text-[#fc9a01]">BOOK-IT</span>
        <span className="text-white"> | {pageName}</span>
      </div>
      <div className="flex items-center gap-8">
        <button onClick={shoppingCart} className="hover:underline flex items-center">
          <FaShoppingCart className="text-white text-2xl" />
        </button>
        <button onClick={seeDashboard} className="hover:underline">Dashboard</button>
        <button onClick={seeOrders} className="hover:underline">My Orders</button>
        <button onClick={logOut} className="hover:underline">Log out</button>
      </div>
    </nav>
  );
}

export default Navbar2;
