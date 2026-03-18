import React, { useState, useEffect } from 'react';
import { FaMapMarkerAlt, FaArrowLeft } from 'react-icons/fa';
import Navbar4 from '../components/navbar4';
import { useNavigate } from 'react-router-dom';

function MyOrders() {
  const navigate = useNavigate();

  const [transactions, setTransactions] = useState([]); //to get transactions from server

// replace list with transactions from database
  const fetchTransactions = async () => {
    try {
      const token = localStorage.getItem('token');
      const res = await fetch('http://localhost:3000/getTransaction', { // typo?
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
      });
      if (res.status !== 200) {
        throw new Error('Failed to fetch orders');
      }
      const data = await res.json();
      setTransactions(data); // set the data
      console.log('Fetched orders:', data);
    } catch (error) {
      console.error('Error fetching orders:', error);
    }
  };

  useEffect(() => { fetchTransactions(); }, []); // func call

  //computation for estimated delivery date (currdate + 3days => initial computation)
  const estimatedDelivery = new Date();
  estimatedDelivery.setDate(estimatedDelivery.getDate() + 3);
  const deliveryString = estimatedDelivery.toLocaleDateString('en-US', {
    weekday: 'long', month: 'long', day: 'numeric', year: 'numeric'
  });

  // Add this function inside MyOrders component
const handleCancel = async (id, orderQty, productID) => {
  try {
    const token = localStorage.getItem('token');
    const res = await fetch(`http://localhost:3000/cancelTransaction/${id}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify({ 
        amount: orderQty,
        productID: productID
      }),
    });
    if (res.status !== 200) {
      throw new Error('Failed to cancel order');
    }
  } catch (error) {
    console.error('Error canceling order:', error);
  }
};

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
            {transactions.map(item => (
              <div key={item.id} className="mb-6">
                {/* Transaction ID */}
                <div className="text-xs text-gray-500 mb-1 pl-1">
                  Transaction ID: <span className="font-mono">{item.id}</span>
                </div>
                <div className="grid grid-cols-13 gap-4 items-start py-4 bg-white rounded shadow">
                  {/* images */}
                  <div className="col-span-6 flex gap-4">
                    <img src={item.productID.image} alt={item.productID.name} className="w-16 h-16 object-cover rounded shrink-0 ml-10" />
                    <div className="flex flex-col">
                      <p className="font-semibold text-green-900">{item.productID.name}</p>
                      <p className="text-sm text-green-800 max-w-md whitespace-normal break-words">
                        {item.productID.desc && item.productID.desc.length > 75
                          ? item.productID.desc.slice(0, 75) + '...'
                          : item.productID.desc}
                      </p>
                      {item.status === 'pending' && (
                        <button
                          className="mt-2 px-3 py-1 bg-red-400 text-white text-xs rounded hover:bg-red-700 transition w-fit"
                          onClick={() => handleCancel(item.id, item.orderQty, item.productID.id)}
                        >
                          Cancel
                        </button>
                      )}
                    </div>
                  </div>
                  {/* quantity */}
                  <div className="col-span-2 text-right text-green-900 flex flex-col justify-center">
                    <p className="font-semibold">Quantity</p>
                    <p>{item.orderQty}</p>
                  </div>
                  {/* unit price */}
                  <div className="col-span-3 text-right text-green-900 flex flex-col justify-center">
                    <p className="font-semibold">Total Amount</p>
                    <p>Php {item.total.toFixed(2)}</p>
                  </div>
                  {/* status */}
                  <div className="col-span-1 text-right text-green-900 flex flex-col items-end justify-center">
                    <p className="font-semibold">Status</p>
                    <p className={`text-sm ${
                      item.status === 'pending' ? 'text-yellow-500' :
                      item.status === 'completed' ? 'text-green-600' :
                      item.status === 'canceled' ? 'text-red-600' : ''
                    }`}>
                      {item.status}
                    </p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default MyOrders;
