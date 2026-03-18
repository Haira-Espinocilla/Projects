import React, { useState, useEffect } from 'react';
import { FaArrowLeft } from 'react-icons/fa';
import Navbar2 from '../components/navbar2'; 
import { useNavigate } from 'react-router-dom';

function ProductList() {
  const [filter, setFilter] = useState('All');
  const [sortBy, setSortBy] = useState('name');
  const [sortOrder, setSortOrder] = useState('asc');
  const [products, setProducts] = useState([]);
   const [showSuccessModal, setShowSuccessModal] = useState(false); // to show the delete success/error modal
   const [successMessage, setSuccessMessage] = useState('');  // store the success message for the modal
  const navigate = useNavigate();

  useEffect(() => {
    fetchProducts();
  }, []);

   // lock scroll
    useEffect(() => {
      // fetchCartItems();
      document.body.style.overflow = showSuccessModal ? 'hidden' : 'auto';
      return () => { document.body.style.overflow = 'auto'; };
    }, [showSuccessModal]);

  const fetchProducts = async () => {
    try {
      const response = await fetch('http://localhost:3000/getAllProducts');
      const data = await response.json();
      setProducts(data);
    } catch (error) {
      console.error('Error fetching products:', error);
    }
  };

  const handleSort = (criteria) => {
    if (sortBy === criteria) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    } else {
      setSortBy(criteria);
      setSortOrder('asc');
    }
  };

  // Filtering and sorting logic
  const filteredSortedProducts = [...products]
    .filter((p) => {
      if (filter === 'All') return true;
      if (filter === 'Crops') return p.type == 1;
      if (filter === 'Poultry') return p.type == 2;
      return true;
    })
    .sort((a, b) => {
      if (sortBy === 'price' || sortBy === 'qty') {
        return sortOrder === 'asc' ? a[sortBy] - b[sortBy] : b[sortBy] - a[sortBy];
      } else if (sortBy === 'type') {
        return sortOrder === 'asc'
          ? String(a.type).localeCompare(String(b.type))
          : String(b.type).localeCompare(String(a.type));
      } else {
        return sortOrder === 'asc'
          ? a[sortBy].localeCompare(b[sortBy])
          : b[sortBy].localeCompare(a[sortBy]);
      }
    });

  //adds selected product to cart
  const addToCart = async (product) => {
    try {
      const token = localStorage.getItem('token');
      const response = await fetch('http://localhost:3000/addToCart', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
        body: JSON.stringify({
          productID: product.id
        }),
      });
      const data = await response.json();
      setSuccessMessage('Product added to cart');
      console.log(data); // console product added to cart
      setShowSuccessModal(true);
    } catch (error) {
      setSuccessMessage('Error adding cart item');
      console.error('Error adding product to cart:', error);
      setShowSuccessModal(true);
    }
  };

  return (
    <div className="min-h-screen bg-[#efefef] flex flex-col font-sans relative" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
      <div className="fixed top-0 left-0 w-full z-50">
        <Navbar2 pageName="Product Listing" />
        <div className="mt-2 ml-6">
          <button
            onClick={() => navigate(-1)}
            className="w-15 h-15 rounded-full bg-[#154a06] text-white flex items-center justify-center shadow hover:bg-green-800 transition"
            aria-label="Go Back"
          >
            <FaArrowLeft className="text-xl" />
          </button>
        </div>
      </div>
      {/* main content */}
      <div className="mt-[120px] flex-1 overflow-y-auto px-6">
        <div className="max-w-screen-xl mx-auto">
          <div className="flex flex-col items-center gap-4 mb-6">
            {/* filter buttons */}
            <div className="flex gap-4">
              {['All', 'Crops', 'Poultry'].map((label) => (
                <button
                  key={label}
                  className={`px-6 py-2 rounded-full font-semibold transition ${filter === label ? 'bg-green-900 text-white' : 'bg-green-700 text-white hover:bg-green-800'}`}
                  onClick={() => setFilter(label)}
                >
                  {label.toUpperCase()}
                </button>
              ))}
            </div>
            {/* sort buttons */}
            <div className="flex gap-2 items-center">
              <span className="text-green-900 font-semibold">Sort by:</span>
              {['name', 'type', 'price', 'qty'].map((key) => (
                <button
                  key={key}
                  onClick={() => handleSort(key)}
                  className={`px-3 py-1 rounded text-sm font-medium ${
                    sortBy === key ? 'bg-green-800 text-white' : 'bg-green-300 hover:bg-green-400'
                  }`}
                >
                  {key === 'qty' ? 'Quantity' : key.charAt(0).toUpperCase() + key.slice(1)}
                  {sortBy === key ? (sortOrder === 'asc' ? ' ▲' : ' ▼') : ''}
                </button>
              ))}
            </div>
          </div>
        {/* product cards */}
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-6">
            { filteredSortedProducts.map((product) => {
              if (product.qty <= 0) return null; // skip products that are out of stock
              return (
              <div
                key={product.id}
                className="w-full p-4 rounded-2xl shadow-lg bg-[#ffffff] flex flex-col space-y-2"
              >
                {/* images */}
                <img
                  src={product.image}
                  alt={product.name}
                  className="h-40 w-55 object-cover rounded-lg mx-auto"
                /> 
                {/* info */} 
                <h2 className="text-left text-2xl font-extrabold text-[#154a06]">{product.name}</h2>
                <p className="text-left text-[#154a06] whitespace-normal break-words">{product.desc && product.desc.length > 75 ? product.desc.slice(0, 75) + '...' : product.desc}</p>
                <p className="text-left text-sm text-[#154a06]">Available: {product.qty}</p>
                <p className="text-left text-lg font-bold text-[#154a06] mb-3 mt-2">Php {product.price}.00</p>
                
                {/* add to cart */}
                <button
                  className="bg-[#154a06] text-white font-bold py-2 px-4 rounded mt-auto hover:bg-green-800"
                  onClick={() => addToCart(product)}
                >
                  ADD TO CART
                </button>
              </div>
            )})}
          </div>
        </div>
      {/* modal for success/error notif */}
      {showSuccessModal && (
        <div className="fixed inset-0 z-50 bg-black/30 backdrop-blur-sm flex justify-center items-center">
          <div className="bg-white rounded-lg shadow-xl p-8 border-2 border-green-900 max-w-md w-full">
            {/* <h2 className="text-xl font-bold text-green-900 mb-4">Notice</h2> */}
            <p className="text-green-800 mb-6">{successMessage}</p>
            <div className="flex justify-end space-x-4">
              <button onClick={() => setShowSuccessModal(false)} className="px-4 py-2 bg-gray-300 text-gray-800 rounded hover:bg-gray-400">OK</button>
            </div>
          </div>
        </div>
      )}
      </div>
    </div>
  );
}

export default ProductList;
