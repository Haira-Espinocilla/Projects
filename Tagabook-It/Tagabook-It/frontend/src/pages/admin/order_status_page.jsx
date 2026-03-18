import React, { useState, useEffect } from 'react';
import Navbar from '../../components/navbaradmin1.jsx';

function formatDate(date) {
  if (!date) return '';
  return new Date(date).toLocaleDateString();
}

function OrderStatusAdmin() {
  const [transactions, setTransactions] = useState([]);

  // Fetch transactions from backend
  useEffect(() => {
    const fetchTransactions = async () => {
      try {
        const token = localStorage.getItem('token');
        const res = await fetch('http://localhost:3000/getAllTransactions', {
          method: 'GET',
          headers: {
            'Authorization': `Bearer ${token}`,
          },
        });
        const data = await res.json();
        setTransactions(data);
      } catch (e) {
        console.error('Error fetching transactions:', e);
      }
    };
    
    fetchTransactions();
  }, []);

  // Update status in backend and UI
  const updateStatus = async (id, newStatus) => {
    try {
      const token = localStorage.getItem('token');
      const res = await fetch(`http://localhost:3000/updateTransactionStatus/${id}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
        body: JSON.stringify({ status: newStatus }),
      });
      if (res.status === 200) {
        setTransactions((prev) =>
          prev.map((tx) =>
            tx.id === id ? { ...tx, status: newStatus } : tx
          )
        );
      }
    } catch (e) {
      console.error('Error updating status:', e);
    }
  };

  return (
    <div className="min-h-screen flex flex-col" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
      <Navbar />

      <main className="p-8 flex-grow bg-gray-50">
        <h1 className="text-4xl font-bold mb-6 text-green-900">Admin Order Status</h1>
        <div className="overflow-x-auto">
          <table className="min-w-full border-collapse border border-gray-300">
            <thead>
              <tr className="bg-green-900 text-white">
                <th className="border border-gray-300 px-4 py-2">Order ID</th>
                <th className="border border-gray-300 px-4 py-2">Product ID</th>
                <th className="border border-gray-300 px-4 py-2">Quantity</th>
                <th className="border border-gray-300 px-4 py-2">Customer Email</th>
                <th className="border border-gray-300 px-4 py-2">Date</th>
                <th className="border border-gray-300 px-4 py-2">Time</th>
                <th className="border border-gray-300 px-4 py-2">Status</th>
                <th className="border border-gray-300 px-4 py-2">Actions</th>
              </tr>
            </thead>
            <tbody>
              {transactions.map(({ id, productID, orderQty, status, email, date, time }) => (
                <tr key={id} className="text-center border border-gray-300">
                  <td className="border border-gray-300 px-4 py-2">{id}</td>
                  <td className="border border-gray-300 px-4 py-2">{typeof productID === 'object' ? productID.id : productID}</td>
                  <td className="border border-gray-300 px-4 py-2">{orderQty}</td>
                  <td className="border border-gray-300 px-4 py-2">{email}</td>
                  <td className="border border-gray-300 px-4 py-2">{formatDate(date)}</td>
                  <td className="border border-gray-300 px-4 py-2">{time}</td>
                  <td className="border border-gray-300 px-4 py-2">
                    {status === 'pending' && <span className="text-yellow-600 font-semibold">Pending</span>}
                    {status === 'completed' && <span className="text-green-600 font-semibold">Confirmed</span>}
                    {status === 'canceled' && <span className="text-red-600 font-semibold">Canceled</span>}
                  </td>
                  <td className="border border-gray-300 px-4 py-2 space-x-2">
                    {status === 'pending' ? (
                      <>
                        <button
                          onClick={() => updateStatus(id, 'completed')}
                          className="bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700 transition my-2"
                        >
                          Confirm
                        </button>
                        <button
                          onClick={() => updateStatus(id, 'canceled')}
                          className="bg-red-600 text-white px-3 py-1 rounded hover:bg-red-700 transition my-2"
                        >
                          Cancel
                        </button>
                      </>
                    ) : (
                      <span className="italic text-gray-500">No actions available</span>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </main>
    </div>
  );
}

export default OrderStatusAdmin;
