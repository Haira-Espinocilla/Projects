import React, { useState, useEffect } from 'react';
import Navbar from '../../components/navbaradmin1'; // Reuse your Navbar

function AdminAccountsManagement() {
  const [users, setUsers] = useState([]); // empty array

  const fetchUsers = async () => {
    try {
      const token = localStorage.getItem('token'); // get token 

      // check if token is here siguro 
    
    
    const res = await fetch('http://localhost:3000/getAllUsers', { // implement this endpoint
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`, 
        },
      });

      // check if !res.ok

      const data = await res.json();
      console.log("current", data);
      setUsers(data); // dapat array return ni getAllUsers

    } catch (error) {
      console.error("getAllUsers failed: ", error);
    }
  }

  useEffect(() => {
    fetchUsers();
  }, []);

  const itemsPerPage = 10;
  const [page, setPage] = useState(0);

  const paginatedUsers = users.slice(page * itemsPerPage, (page + 1) * itemsPerPage);

  return (
    <div className="min-h-screen bg-gray-100">
      <Navbar />
      <div className="max-w-6xl mx-auto py-10 px-4">
        <h1 className="text-3xl font-bold text-green-900 mb-6">Accounts Management</h1>
        {/* number of accounts */}
        <p className="text-gray-700 mb-4">
          Total Accounts: <span className="font-semibold text-gray-900">{users.length}</span>
        </p>
        <div className="overflow-x-auto bg-white shadow rounded-lg">
          <table className="min-w-full table-auto text-left">
            <thead className="bg-green-900 text-white">
              <tr>
                <th className="px-6 py-3">First Name</th>
                <th className="px-6 py-3">Middle Name</th>
                <th className="px-6 py-3">Last Name</th>
                <th className="px-6 py-3">Email</th>
                <th className="px-6 py-3">User Type</th>
              </tr>
            </thead>
            <tbody>
              {paginatedUsers.map((user, idx) => (
                <tr key={idx} className="border-b">
                  <td className="px-6 py-4">{user.firstName}</td>
                  <td className="px-6 py-4">{user.middleName}</td>
                  <td className="px-6 py-4">{user.lastName}</td>
                  <td className="px-6 py-4">{user.email}</td>
                  <td className="px-6 py-4">{user.type}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <div className="flex justify-between items-center mt-6">
          <button
            disabled={page === 0}
            onClick={() => setPage(page - 1)}
            className={`px-4 py-2 rounded bg-green-700 text-white hover:bg-green-800 transition ${page === 0 && 'opacity-50 cursor-not-allowed'}`}
          >
            Previous
          </button>
          <span className="text-green-900 font-semibold">
            Page {page + 1} of {Math.ceil(users.length / itemsPerPage)}
          </span>
          <button
            disabled={(page + 1) * itemsPerPage >= users.length}
            onClick={() => setPage(page + 1)}
            className={`px-4 py-2 rounded bg-green-700 text-white hover:bg-green-800 transition ${(page + 1) * itemsPerPage >= users.length && 'opacity-50 cursor-not-allowed'}`}
          >
            Next
          </button>
        </div>
      </div>
    </div>
  );
}

export default AdminAccountsManagement;
