import React from 'react';
import { useNavigate } from 'react-router-dom';
import bgImage from '/src/assets/images/bg_image.jpg';

function Login() {
  const navigate = useNavigate();

  const seeDashboard = (e) => {
    e.preventDefault(); //prevent form reload
    navigate('/dashboard');
  };

  const signUp = (e) => {
    e.preventDefault();
    navigate('/signUp');
  };

  return (
    <div
      className="min-h-screen flex items-center justify-center bg-cover bg-no-repeat bg-center"
      style={{
        backgroundImage: `url(${bgImage})`,
        backgroundSize: 'cover',
        width: '100vw',
        height: '100vh',
      }}
    >
      <div className="bg-white/90 p-8 rounded-2xl shadow-lg w-full max-w-4xl" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
        <div className="flex flex-col md:flex-row items-center md:items-start justify-between gap-8">
          <div className="text-center md:text-left self-start flex-1 ml-4 md:ml-8 mt-4 md:mt-25">
            <h1 className="text-5xl font-bold mb-2">
              <span className="text-[#154a06]">TAGA</span>
              <span className="text-[#fc9a01]">BOOK-IT</span>
            </h1>
            <p className="text-[#154a06] text-lg">Sariwang ani mula sa bukid — just book it!</p>
          </div>

          <form className="bg-white p-6 rounded-xl shadow w-full md:w-1/2 space-y-4" onSubmit={seeDashboard}>
            <div>
              <label className="block text-sm font-bold mb-1 text-[#154a06]">Email Address</label>
              <input
                type="email"
                placeholder="Enter your email"
                className="w-full border border-gray-300 p-2 rounded focus:outline-none focus:ring-2 focus:ring-[#154a06]"
              />
            </div>
            <div>
              <label className="block text-sm font-bold mb-1 text-[#154a06]">Password</label>
              <input
                type="password"
                placeholder="Enter your password"
                className="w-full border border-gray-300 p-2 rounded focus:outline-none focus:ring-2 focus:ring-[#154a06]"
              />
            </div>
            <button
              type="submit"
              className="w-full bg-[#154a06] text-white py-2 rounded hover:bg-[#126604] transition"
            >
              LOG IN
            </button>
            <div className="text-center text-sm mt-4">
              <span>No account yet? </span>
              <a onClick={signUp} className="text-[#f17b01] hover:underline cursor-pointer">Sign Up</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}

export default Login;
