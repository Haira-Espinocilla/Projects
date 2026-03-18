import React, { useState, useEffect } from 'react';
import { FaMapMarkerAlt, FaArrowLeft } from 'react-icons/fa';
import Navbar3 from '../Components/navbar3';
import { useNavigate } from 'react-router-dom';

function PlaceOrder () {
  const navigate = useNavigate();

  //navigation to my orders page
  const seeOrders = (e) => {
    e.preventDefault();
    navigate('/myOrders');
  };

  //user state
  const [user, setUser] = useState({ firstname: '', middlename: '', lastname: '', email: '' });
  
  //address state
  const [address, setAddress] = useState('No address yet');
  const [showAddressModal, setShowAddressModal] = useState(false);
  const [addressForm, setAddressForm] = useState({
    street: '', houseNo: '', barangay: '', city: '', province: '', postalCode: ''
  });

  //hard coded list of items
  const [items] = useState([
    { id: 1, name: 'Product 1', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque et venenatis sapien, a cursus dolor.', quantity: 1, price: 150, image: '/src/assets/images/field.jpg' },
    { id: 2, name: 'Product 2', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque et venenatis sapien, a cursus dolor.', quantity: 1, price: 250, image: '/src/assets/images/field.jpg' },
    { id: 3, name: 'Product 3', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque et venenatis sapien, a cursus dolor.', quantity: 1, price: 100, image: '/src/assets/images/field.jpg' },
  ]);

  //reduce and increase quantity
  const totalItems = items.reduce((sum, item) => sum + item.quantity, 0);
  const totalPrice = items.reduce((sum, item) => sum + item.quantity * item.price, 0);

  //not sure how to implement this sa backend kaya ito muna hahaha, pa-remove nalang nung mga || ... if magffinalize na
  useEffect(() => {
    const storedUser = JSON.parse(localStorage.getItem('user')) || {};
    setUser({
      firstname: storedUser.firstname || 'Izuku',
      middlename: storedUser.middlename || '',
      lastname: storedUser.lastname || 'Midoriya',
      email: storedUser.email || 'wagizuku@mha.com'
    });
  }, []);

  //lock scroll
  useEffect(() => {
    document.body.style.overflow = showAddressModal ? 'hidden' : 'auto';
    return () => { document.body.style.overflow = 'auto'; };
  }, [showAddressModal]);

  //to save address input from user
  const saveAddress = () => {
    const fullAddress = `${addressForm.houseNo}, ${addressForm.street}, Brgy. ${addressForm.barangay}, ${addressForm.city}, ${addressForm.province}, ${addressForm.postalCode}`;
    setAddress(fullAddress);
    setShowAddressModal(false);
    setAddressForm({ street: '', houseNo: '', barangay: '', city: '', province: '', postalCode: '' });
  };

  //update address input
  const updateForm = (field, value) => setAddressForm(prev => ({ ...prev, [field]: value }));

  return (
    <div className="min-h-screen bg-gray-100 flex flex-col font-sans relative" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
      <div className="fixed top-0 left-0 w-full z-50">
        <Navbar3 pageName="Place Order" />
        <div className="bg-white w-full px-8 py-6 border-b shadow-sm">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 items-start">
            <div>
              <h3 className="text-2xl font-bold text-green-900">{user.firstname} {user.middlename} {user.lastname}</h3>
              <p className="text-sm text-green-700">{user.email}</p>
            </div>
            <div className="text-right">
              <div className="flex items-center justify-end gap-2">
                <FaMapMarkerAlt className="text-green-900 w-4 h-4" />
                <p className="text-green-900 font-medium text-sm text-right">{address}</p>
              </div>

              {/* edit info button */}
              <button
                onClick={() => setShowAddressModal(true)}
                className="text-sm text-green-700 underline mt-1 hover:text-green-900 transition"
              >
                Edit Info
              </button>
            </div>
          </div>
        </div>
        {/* back button */}
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
      <div className="mt-[190px] flex-1 overflow-y-auto px-4">
        <div className="max-w-5xl mx-auto">
          <div className="bg-white p-6 mt-6 rounded shadow">
            <h2 className="text-xl font-bold text-green-900 mb-4">Products Ordered</h2>
            {items.map(item => (
              <div key={item.id} className="flex items-center justify-between py-4">
                <div className="flex items-start gap-4">
                  <img src={item.image} alt={item.name} className="w-16 h-16 object-cover rounded" />
                  <div>
                    <p className="font-semibold text-green-900">{item.name}</p>
                    <p className="text-sm text-green-800 max-w-md">{item.description}</p>
                  </div>
                </div>
                <div className="text-right text-green-900">
                  <p className="font-semibold">Quantity</p>
                  <p>{item.quantity}</p>
                </div>
                <div className="text-right text-green-900">
                  <p className="font-semibold">Unit Price</p>
                  <p>Php {item.price.toFixed(2)}</p>
                </div>
              </div>
            ))}
          </div>
          {/* to display payment method */}
          <div className="bg-white rounded shadow p-6 mt-6 flex items-center gap-6">
            <h2 className="text-xl font-bold text-green-900">Payment Method</h2>
            <span className="px-6 py-1 border border-green-900 text-green-900 font-semibold rounded-xl">
              CASH-ON-DELIVERY
            </span>
          </div>
        </div>
      </div>

      {/* footer to display total price, items and place order button */}
      <div className="bg-white w-full shadow-md p-6 sticky bottom-0 z-10">
        <div className="max-w-5xl mx-auto flex justify-between items-center">
          <div>
            <h3 className="text-2xl font-bold text-green-900">Total: Php {totalPrice.toFixed(2)}</h3>
            <p className="text-green-800">{totalItems} item(s)</p>
          </div>
          <button onClick={seeOrders} className="bg-green-900 text-white font-bold py-3 px-8 rounded hover:bg-green-800 shadow-md">
            PLACE ORDER
          </button>
        </div>
      </div>
      
      {/* to show modal for address */}
      {showAddressModal && (
        <div className="fixed inset-0 z-50 bg-black/30 backdrop-blur-sm flex justify-center items-center">
          <div className="bg-white rounded-lg shadow-xl p-8 border-2 border-green-900 max-w-md w-full">
            <h2 className="text-xl font-bold text-green-900 mb-4">Edit Address</h2>
            {['houseNo', 'street', 'barangay', 'city', 'province', 'postalCode'].map(field => (
              <input
                key={field}
                type="text"
                className="w-full border border-green-900 p-2 rounded mb-3 text-gray-500"
                value={addressForm[field]}
                onChange={(e) => updateForm(field, e.target.value)}
                placeholder={field.replace(/([A-Z])/g, ' $1').replace(/^./, str => str.toUpperCase())}
              />
            ))}
            <div className="flex justify-end space-x-4">
              <button onClick={() => setShowAddressModal(false)} className="px-4 py-2 bg-gray-300 text-gray-800 rounded hover:bg-gray-400">Cancel</button>
              <button onClick={saveAddress} className="px-4 py-2 bg-green-900 text-white rounded hover:bg-green-800">Save</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default PlaceOrder;
