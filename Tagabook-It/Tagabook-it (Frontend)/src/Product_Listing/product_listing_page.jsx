import React, { useState, useEffect } from 'react';
import { FaArrowLeft } from 'react-icons/fa';
import Navbar2 from '../Components/navbar2';
import { useNavigate } from 'react-router-dom';

//hard coded list of products
const products = [
  { id: 1, type: 'Crops', name: 'Product 1', price: '10.00', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', image: 'src/assets/images/bg_image.jpg' },
  { id: 2, type: 'Crops', name: 'Product 2', price: '15.00', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', image: 'src/assets/images/field.jpg' },
  { id: 3, type: 'Poultry', name: 'Product 3', price: '75.00', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', image: 'src/assets/images/bg_image.jpg' },
  { id: 4, type: 'Poultry', name: 'Product 4', price: '95.00', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', image: 'src/assets/images/field.jpg' },
  { id: 5, type: 'Poultry', name: 'Product 5', price: '100.00', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', image: 'src/assets/images/field.jpg' },
  { id: 6, type: 'Crops', name: 'Product 6', price: '105.00', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', image: 'src/assets/images/field.jpg' },
];

function ProductList() {
  const [cart, setCart] = useState([]); //to store items added to cart
  const [filter, setFilter] = useState('All'); //initial product filter
  const navigate = useNavigate();

  //adds selected product to cart
  const addToCart = (product) => {
    setCart([...cart, product]);
  };

  //to filter products based on what button user chose
  const filtered_products = filter === 'All' ? products : products.filter(p => p.type === filter);

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
          </div>
        {/* product cards */}
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-6">
            {filtered_products.map((product) => (
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
                <h2 className="text-left text-lg font-bold text-[#154a06] mb-3 mt-2">{product.name}</h2>
                <p className="text-left text-[#154a06] text-sm mb-6 whitespace-normal break-words">{product.description}</p>
                <p className="text-left text-2xl font-extrabold text-[#154a06]">Php {product.price}</p>
                {/* add to cart */}
                <button
                  className="bg-[#154a06] text-white font-bold py-2 px-4 rounded mt-auto hover:bg-green-800"
                  onClick={() => addToCart(product)}
                >
                  ADD TO CART
                </button>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

export default ProductList;
