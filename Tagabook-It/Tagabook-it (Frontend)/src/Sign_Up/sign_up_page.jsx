import React from 'react';
import { useNavigate } from 'react-router-dom';
import { FaArrowLeft } from 'react-icons/fa';
import bgImage from '/src/assets/images/bg_image.jpg';

function SignUp() {
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();
    navigate('/');
  };

  return (
    <div
      className="min-h-screen flex flex-col items-center justify-center bg-cover bg-center relative"
      style={{ backgroundImage: `url(${bgImage})` }}
    >
      <div className="absolute top-4 left-4">
        <button
          onClick={() => navigate(-1)}
          className="w-15 h-15 rounded-full bg-orange-500 text-white flex items-center justify-center shadow hover:bg-green-800 transition"
          aria-label="Go Back"
        >
          <FaArrowLeft className="text-xl" />
        </button>
      </div>

      <div className="bg-white/95 p-10 rounded-3xl shadow-lg max-w-md w-full" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
        <h1 className="text-4xl font-extrabold text-center mb-8">
          <span className="text-green-800">SIGNUP</span>
          <span className="text-orange-500"> NOW</span>
        </h1>

        <form className="space-y-5" onSubmit={handleSubmit}>
          <div>
            <label className="block text-sm font-semibold mb-1">First Name</label>
            <input
              type="text"
              className="w-full border border-gray-300 p-2 rounded-md focus:ring-2 focus:ring-green-700"
            />
          </div>
          <div>
            <label className="block text-sm font-semibold mb-1">Middle Name</label>
            <input
              type="text"
              className="w-full border border-gray-300 p-2 rounded-md focus:ring-2 focus:ring-green-700"
            />
          </div>
          <div>
            <label className="block text-sm font-semibold mb-1">Last Name</label>
            <input
              type="text"
              className="w-full border border-gray-300 p-2 rounded-md focus:ring-2 focus:ring-green-700"
            />
          </div>
          <div>
            <label className="block text-sm font-semibold mb-1">Email</label>
            <input
              type="email"
              className="w-full border border-gray-300 p-2 rounded-md focus:ring-2 focus:ring-green-700"
            />
          </div>
          <div>
            <label className="block text-sm font-semibold mb-1">Password</label>
            <input
              type="password"
              className="w-full border border-gray-300 p-2 rounded-md focus:ring-2 focus:ring-green-700"
            />
          </div>

          <button
            type="submit"
            className="w-full bg-green-900 text-white py-2 rounded-md font-bold hover:bg-green-800 transition"
          >
            SIGN UP
          </button>
        </form>
      </div>
    </div>
  );
}

export default SignUp;
