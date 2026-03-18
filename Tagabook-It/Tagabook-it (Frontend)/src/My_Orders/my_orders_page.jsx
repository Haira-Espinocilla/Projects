import React, { useState, useEffect } from 'react';
import { FaMapMarkerAlt, FaArrowLeft } from 'react-icons/fa';
import Navbar4 from '../Components/navbar4';
import { useNavigate } from 'react-router-dom';

function MyOrders() {
  const navigate = useNavigate();

    const [showCancelModal] = useState(false);

  //hard coded list of items
  const [items, setItems] = useState([
    { id: 1, name: 'Product 1', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque et venenatis sapien, a cursus dolor.', quantity: 1, price: 150, image: '/src/assets/images/field.jpg' },
    { id: 2, name: 'Product 2', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque et venenatis sapien, a cursus dolor.', quantity: 1, price: 250, image: '/src/assets/images/field.jpg' },
    { id: 3, name: 'Product 3', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque et venenatis sapien, a cursus dolor.', quantity: 1, price: 100, image: '/src/assets/images/field.jpg' },
  ]);

  const [chosenItems, setChosenItems] = useState([]); //tracker of selected items
  const [showModal, setShowModal] = useState(false); //to show cancellation confirmation

  //so that when the modal shows up, you cannot scroll up or down
   useEffect(() => {
    document.body.style.overflow = showCancelModal ? 'hidden' : 'auto';
    return () => {
      document.body.style.overflow = 'auto';
    };
  }, [showCancelModal]);

  //toggle selection of a product for cancellation
  const toggleChooseItem = (id) => {
    setChosenItems(prev =>
      prev.includes(id) ? prev.filter(itemId => itemId !== id) : [...prev, id]
    );
  };

  //trigger the confirmation modal only if items are selected
  const cancelChosen = () => {
    if (chosenItems.length > 0) {
      setShowModal(true);
    }
  };

  //remove selected items from list and close modal
  const confirmCancel = () => {
    setItems(prev => prev.filter(item => !chosenItems.includes(item.id)));
    setChosenItems([]);
    setShowModal(false);
  };

  //computation for estimated delivery date (currdate + 3days => initial computation)
  const estimatedDelivery = new Date();
  estimatedDelivery.setDate(estimatedDelivery.getDate() + 3);
  const deliveryString = estimatedDelivery.toLocaleDateString('en-US', {
    weekday: 'long', month: 'long', day: 'numeric', year: 'numeric'
  });

  return (
    <div className="min-h-screen bg-gray-100 flex flex-col font-sans relative" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
      <div className="fixed top-0 left-0 w-full z-50">
        {/* for unscrollable nav bar and back button */}
        <Navbar4 pageName="My Orders" />
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
      <div className="mt-[110px] flex-1 overflow-y-auto px-4">
        <div className="max-w-5xl mx-auto">
          <div className="bg-green-900 text-white text-lg font-medium px-6 py-3 mt-6 rounded-t-xl shadow">
            Estimated Delivery Date: {deliveryString}
          </div>
          {/* list of products ordered */}
          <div className="bg-white p-6 rounded-b shadow">
            <h2 className="text-xl font-bold text-green-900 mb-4">Products Ordered</h2>
            {items.map(item => (
              <div key={item.id} className="grid grid-cols-12 gap-4 items-start py-4">
                {/* checkbox column */}
                <div className="col-span-1 pt-2">
                  <input
                    type="checkbox"
                    checked={chosenItems.includes(item.id)}
                    onChange={() => toggleChooseItem(item.id)}
                    className="w-5 h-5 text-green-900 border-green-900 accent-[#154a06]"
                  />
                </div>
                {/* images */}
                <div className="col-span-6 flex gap-4">
                  <img src={item.image} alt={item.name} className="w-16 h-16 object-cover rounded shrink-0" />
                  <div className="flex flex-col">
                    <p className="font-semibold text-green-900">{item.name}</p>
                    <p className="text-sm text-green-800 max-w-md whitespace-normal break-words">{item.description}</p>
                  </div>
                </div>
                {/* quantity */}
                <div className="col-span-2 text-right text-green-900">
                  <p className="font-semibold">Quantity</p>
                  <p>{item.quantity}</p>
                </div>
                {/* unit price */}
                <div className="col-span-3 text-right text-green-900">
                  <p className="font-semibold">Unit Price</p>
                  <p>Php {item.price.toFixed(2)}</p>
                </div>
              </div>
            ))}

            {/* cancel button only appears if you select an item to be cancelled */}
            {chosenItems.length > 0 && (
              <div className="flex justify-end mt-6">
                <button
                  onClick={cancelChosen}
                  className="bg-orange-500 hover:bg-orange-600 text-white font-semibold px-6 py-2 rounded shadow"
                >
                  Cancel Order
                </button>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* cancellation modal itself */}
      {showModal && (
        <div className="fixed inset-0 z-50 bg-black/30 backdrop-blur-sm flex justify-center items-center">
          <div className="bg-white rounded-lg shadow-xl p-8 border-2 border-green-900 max-w-md w-full">
            <h2 className="text-xl font-bold text-green-900 mb-4">Confirm Cancellation</h2>
            <p className="text-green-800 mb-6">Are you sure you want to cancel {chosenItems.length} item(s)?</p>
            <div className="flex justify-end space-x-4">
              <button onClick={() => setShowModal(false)} className="px-4 py-2 bg-gray-300 text-gray-800 rounded hover:bg-gray-400">Back</button>
              <button onClick={confirmCancel} className="px-4 py-2 bg-orange-500 text-white rounded hover:bg-orange-600">Confirm</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default MyOrders;
