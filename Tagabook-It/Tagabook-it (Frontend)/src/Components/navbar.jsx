import React from 'react';
import { useNavigate } from 'react-router-dom';

//contents: My Orders and Log out button
function Navbar() {
  const navigate = useNavigate();

  const seeOrders = (e) => {
    e.preventDefault();
    navigate('/myOrders');
  };

  const logOut = (e) => {
    e.preventDefault();
    navigate('/logOut');
  };

  return (
    <nav className="bg-green-900 text-white flex justify-between items-center px-6 py-4" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
      <div className="text-3xl font-bold">
        <span className="text-white">TAGA</span>
        <span className="text-[#fc9a01]">BOOK-IT</span>
      </div>
      <div className="space-x-15">
        <button onClick={seeOrders} className="hover:underline">My Orders</button>
        <button onClick={logOut} className="hover:underline">Log out</button>
      </div>
    </nav>
  );
};

export default Navbar;
