//Shopping_Cart/shopping_cart_page.jsx
import { useNavigate } from 'react-router-dom';
import React, { useState, useEffect } from 'react';
import Navbar3 from '../Components/navbar3';
import { FaArrowLeft } from 'react-icons/fa';

function ShoppingCart() {
  const navigate = useNavigate();

  //to navigate to place order screen
  const checkout = (e) => {
    e.preventDefault();
    navigate('/placeOrder');
  };

  const [quantities, setQuantities] = useState({}); //state of product quantity
  const [chosenItems, setChosenItems] = useState([]); //selected products
  const [showModal, setShowModal] = useState(false); //to show the confirmation delete modal
  const [productToDelete, setProductToDelete] = useState(null); //current selected product to delete

  //hard coded list of items
  const [products, setProducts] = useState([
    { id: 1, type: 'Crops', name: 'Product 1', price: '10.00', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', image: 'src/assets/images/bg_image.jpg' },
    { id: 2, type: 'Crops', name: 'Product 2', price: '15.00', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', image: 'src/assets/images/field.jpg' },
    { id: 3, type: 'Poultry', name: 'Product 3', price: '75.00', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', image: 'src/assets/images/bg_image.jpg' },
    { id: 4, type: 'Poultry', name: 'Product 4', price: '95.00', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', image: 'src/assets/images/field.jpg' },
    { id: 5, type: 'Poultry', name: 'Product 5', price: '100.00', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', image: 'src/assets/images/field.jpg' },
    { id: 6, type: 'Crops', name: 'Product 6', price: '105.00', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', image: 'src/assets/images/field.jpg' },
  ]);

  //lock scroll
  useEffect(() => {
    document.body.style.overflow = showModal ? 'hidden' : 'auto';
    return () => { document.body.style.overflow = 'auto'; };
  }, [showModal]);

  //used to increase or decrease product quantity 
  const increase = (id) => setQuantities(prev => ({ ...prev, [id]: (prev[id] || 1) + 1 }));
  const decrease = (id) => setQuantities(prev => ({ ...prev, [id]: prev[id] > 1 ? prev[id] - 1 : 1 }));

  //checkbox
  const toggleSelect = (id) => {
    setChosenItems(prev =>
      prev.includes(id) ? prev.filter(itemId => itemId !== id) : [...prev, id]
    );
  };

  //trigger confirmation modal to delete a product
  const confirmDelete = (id) => {
    setProductToDelete(id);
    setShowModal(true);
  };

  //execute delete
  const deleteProduct = () => {
    setProducts(prev => prev.filter(product => product.id !== productToDelete));
    setChosenItems(prev => prev.filter(id => id !== productToDelete));
    setQuantities(prev => { const updated = { ...prev }; delete updated[productToDelete]; return updated; });
    setShowModal(false);
    setProductToDelete(null);
  };

  //calculate total price
  const totalPrice = chosenItems.reduce((total, id) => {
    const product = products.find(p => p.id === id);
    return total + parseFloat(product.price) * (quantities[id] || 1);
  }, 0);

  //fin the product to delete
  const product = products.find(p => p.id === productToDelete);

  return (
    <div className="min-h-screen bg-gray-100 font-sans" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
      <div className="fixed top-0 left-0 w-full z-50">
        <Navbar3 pageName="Shopping Cart" />
        <div className="mt-2 ml-4">
          <button
            onClick={() => navigate(-1)}
            className="w-15 h-15 rounded-full bg-[#154a06] text-white flex items-center justify-center shadow hover:bg-green-800 transition"
            aria-label="Go Back"
          >
            <FaArrowLeft className="text-xl" />
          </button>
        </div>
      </div>

      {/* main content*/}
      <div className="pt-32 px-4 pb-40">
        {products.map(product => (
          <div key={product.id} className="max-w-5xl mx-auto bg-white p-6 mt-6 rounded-xl shadow">
            <div className="flex items-center mb-4">
              <input type="checkbox" className="mr-4 w-6 h-6 accent-[#154a06]" checked={chosenItems.includes(product.id)} onChange={() => toggleSelect(product.id)} />
              <h2 className="text-2xl font-bold text-green-900">{product.name}</h2>
            </div>
            <hr className="border-t-2 border-green-900 mb-4" />
            <div className="flex flex-col md:flex-row gap-6">
              <img src={product.image} alt={product.name} className="w-35 h-35 object-cover border" />
              <div className="flex-1 text-green-900">
                <p className="mb-4">{product.description}</p>

                {/* quantity */}
                <div className="flex items-center mb-4 border border-green-800 rounded w-fit">
                  <button onClick={() => decrease(product.id)} className="border-r border-green-800 text-green-800 px-4 py-2 hover:bg-green-800 hover:text-white">-</button>
                  <span className="px-6 py-2 bg-white text-green-900 font-semibold">{quantities[product.id] || 1}</span>
                  <button onClick={() => increase(product.id)} className="border-l border-green-800 text-green-800 px-4 py-2 hover:bg-green-800 hover:text-white">+</button>
                </div>
                <p className="text-3xl mt-10">Php {product.price}</p>
              </div>

              {/* delete button */}
              <div className="flex items-end justify-end">
                <button onClick={() => confirmDelete(product.id)} className="bg-orange-500 text-white font-bold py-2 px-6 rounded hover:bg-orange-600 shadow-md">DELETE</button>
              </div>
            </div>
          </div>
        ))}
      </div>

        {/* fixed footer */}
      <div className="bg-white w-full shadow-md p-6 fixed bottom-0 z-40">
        <div className="max-w-5xl mx-auto flex justify-between items-center">
          <div>
            <h3 className="text-2xl font-bold text-green-900">Total: Php {totalPrice.toFixed(2)}</h3>
            <p className="text-green-800">{chosenItems.length} item(s)</p>
          </div>
          <button onClick={checkout} className="bg-green-900 text-white font-bold py-3 px-8 rounded hover:bg-green-800 shadow-md">CHECK OUT</button>
        </div>
      </div>

      {/* modal for confirmation delete*/}
      {showModal && product && (
        <div className="fixed inset-0 z-50 bg-black/30 backdrop-blur-sm flex justify-center items-center">
          <div className="bg-white rounded-lg shadow-xl p-8 border-2 border-green-900 max-w-md w-full">
            <h2 className="text-xl font-bold text-green-900 mb-4">Confirm Deletion</h2>
            <p className="text-green-800 mb-6">Are you sure you want to remove <span className="font-semibold">{product.name}</span> from your shopping cart?</p>
            <div className="flex justify-end space-x-4">
              <button onClick={() => setShowModal(false)} className="px-4 py-2 bg-gray-300 text-gray-800 rounded hover:bg-gray-400">Cancel</button>
              <button onClick={deleteProduct} className="px-4 py-2 bg-orange-500 text-white rounded hover:bg-orange-600">Delete</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ShoppingCart;
