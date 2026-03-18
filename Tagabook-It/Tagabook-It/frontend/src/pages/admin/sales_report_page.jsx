import React, { useState, useMemo, useEffect } from 'react';
import Navbar from '../../components/navbaradmin1.jsx';

export default function SalesReportAdmin() {
  const [period, setPeriod] = useState('weekly');
  const [transactions, setTransactions] = useState([]);

  useEffect(() => {
    const fetchTransactions = async () => {
      try {
        const token = localStorage.getItem('token');
        const res = await fetch('http://localhost:3000/getConfirmedTransactions', {
          headers: { 'Authorization': `Bearer ${token}` }
        });
        const data = await res.json();
        console.log('Fetched transactions:', data);
        setTransactions(data);
      } catch (e) {
        console.error('Error fetching transactions:', e);
      }
    };
    fetchTransactions();
    
  }, []);

  // helpers for date calculations
  function startOfWeek(date) {
    const d = new Date(date);
    const day = d.getDay();
    const diff = d.getDate() - day + (day === 0 ? -6 : 1);
    return new Date(d.setDate(diff));
  }
  function startOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth(), 1);
  }
  function startOfYear(date) {
    return new Date(date.getFullYear(), 0, 1);
  }
  function endOfWeek(date) {
    const start = startOfWeek(date);
    return new Date(start.getFullYear(), start.getMonth(), start.getDate() + 6, 23, 59, 59);
  }
  function endOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth() + 1, 0, 23, 59, 59);
  }
  function endOfYear(date) {
    return new Date(date.getFullYear(), 11, 31, 23, 59, 59);
  }

  const { startDate, endDate } = useMemo(() => {
    const now = new Date();
    if (period === 'weekly') {
      return { startDate: startOfWeek(now), endDate: endOfWeek(now) };
    } else if (period === 'monthly') {
      return { startDate: startOfMonth(now), endDate: endOfMonth(now) };
    } else {
      return { startDate: startOfYear(now), endDate: endOfYear(now) };
    }
  }, [period]);

  // Filter only confirmed transactions within the period
  const filteredTransactions = useMemo(() => {
    return transactions.filter(
      (tx) =>
        (tx.status === 1 || tx.status === 'completed') &&
        new Date(tx.createdAt || tx.date) >= startDate &&
        new Date(tx.createdAt || tx.date) <= endDate
    );
  }, [transactions, startDate, endDate]);

  // Aggregate sales by product
  const salesByProduct = useMemo(() => {
    const sales = {};
    filteredTransactions.forEach(({ productID, orderQty }) => {
      if (!productID) return;
      const prodId = typeof productID === 'object' ? productID.id : productID;
      const prodName = typeof productID === 'object' ? productID.name : '';
      const prodPrice = typeof productID === 'object' ? productID.price : 0;
      if (!sales[prodId]) {
        sales[prodId] = { name: prodName, qty: 0, income: 0, price: prodPrice };
      }
      sales[prodId].qty += orderQty;
      sales[prodId].income += orderQty * prodPrice;
    });
    return sales;
  }, [filteredTransactions]);

  const totalIncome = useMemo(() => {
    return Object.values(salesByProduct).reduce((acc, cur) => acc + cur.income, 0);
  }, [salesByProduct]);

  return (
    <div className="min-h-screen flex flex-col" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
      <Navbar />

      <main className="p-8 flex-grow bg-gray-50">
        <h1 className="text-4xl font-bold mb-6 text-green-900">Sales Report</h1>

        <div className="mb-6 space-x-4">
          {['weekly', 'monthly', 'annual'].map((p) => (
            <button
              key={p}
              onClick={() => setPeriod(p)}
              className={`px-4 py-2 rounded font-semibold ${
                period === p ? 'bg-green-900 text-white' : 'bg-white border border-green-900 text-green-900 hover:bg-green-100'
              } transition`}
            >
              {p.charAt(0).toUpperCase() + p.slice(1)}
            </button>
          ))}
        </div>

        <p className="mb-6 text-gray-600">
          Showing sales from <strong>{startDate.toLocaleDateString()}</strong> to <strong>{endDate.toLocaleDateString()}</strong>
        </p>

        <div className="overflow-x-auto">
          <table className="min-w-full border-collapse border border-gray-300 bg-white rounded shadow">
            <thead>
              <tr className="bg-green-900 text-white">
                <th className="border border-gray-300 px-4 py-2 text-left">Product</th>
                <th className="border border-gray-300 px-4 py-2 text-right">Quantity Sold</th>
                <th className="border border-gray-300 px-4 py-2 text-right">Sales Income (₱)</th>
              </tr>
            </thead>
            <tbody>
              {Object.entries(salesByProduct).length === 0 ? (
                <tr>
                  <td colSpan="3" className="text-center py-6 text-gray-500 italic">
                    No sales data for this period.
                  </td>
                </tr>
              ) : (
                Object.entries(salesByProduct).map(([productID, { name, qty, income }]) => (
                  <tr key={productID} className="border-b border-gray-200 hover:bg-green-50 transition">
                    <td className="border border-gray-300 px-4 py-2">{name || productID}</td>
                    <td className="border border-gray-300 px-4 py-2 text-right">{qty}</td>
                    <td className="border border-gray-300 px-4 py-2 text-right">₱{income.toFixed(2)}</td>
                  </tr>
                ))
              )}
            </tbody>
            {Object.entries(salesByProduct).length > 0 && (
              <tfoot>
                <tr className="bg-green-100 font-semibold">
                  <td className="border border-gray-300 px-4 py-2 text-left">Total</td>
                  <td className="border border-gray-300 px-4 py-2 text-right">
                    {Object.values(salesByProduct).reduce((acc, cur) => acc + cur.qty, 0)}
                  </td>
                  <td className="border border-gray-300 px-4 py-2 text-right">₱{totalIncome.toFixed(2)}</td>
                </tr>
              </tfoot>
            )}
          </table>
        </div>
      </main>
    </div>
  );
}
