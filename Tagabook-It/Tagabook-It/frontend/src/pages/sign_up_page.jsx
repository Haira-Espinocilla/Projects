import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { FaArrowLeft } from 'react-icons/fa';
import bgImage from '/src/assets/images/bg_image.jpg';

function SignUp() {
  const [hidePassword, setHidePassword] = useState(true);
  const [firstName, setFirstName] = useState('');
  const [middleName, setMiddleName] = useState('');
  const [lastName, setLastName] = useState('');
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errorMsg, setErrorMsg] = useState(''); // <-- add this
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (token && token !== 'undefined') {
      navigate('/');
    }
  }, []);

  const handleRegister = async (event) => {
    event.preventDefault();
    setErrorMsg(''); // clear previous error
    try {
      const res = await fetch('http://localhost:3000/register', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          firstName,
          middleName,
          lastName,
          username,
          email,
          password,
        }),
      });
      if (res.status !== 201) {
        const data = await res.json();
        throw new Error(data.error || 'Registration failed');
      }
      setFirstName('');
      setMiddleName('');
      setLastName('');
      setUsername('');
      setEmail('');
      setPassword('');
      navigate('/login');
    } catch (e) {
      setErrorMsg(e.message); // show error in UI
    }
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

        <form className="space-y-5" onSubmit={handleRegister}>
          {errorMsg && (
            <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-2 rounded mb-2 text-center">
              {errorMsg}
            </div>
          )}
          <div>
            <label className="block text-sm font-semibold mb-1">First Name</label>
            <input
              type="text"
              className="w-full border border-gray-300 p-2 rounded-md focus:ring-2 focus:ring-green-700"
              value={firstName}
              onChange={(e) => setFirstName(e.target.value)}
              required
            />
          </div>
          <div>
            <label className="block text-sm font-semibold mb-1">Middle Name</label>
            <input
              type="text"
              className="w-full border border-gray-300 p-2 rounded-md focus:ring-2 focus:ring-green-700"
              value={middleName}
              onChange={(e) => setMiddleName(e.target.value)}
            />
          </div>
          <div>
            <label className="block text-sm font-semibold mb-1">Last Name</label>
            <input
              type="text"
              className="w-full border border-gray-300 p-2 rounded-md focus:ring-2 focus:ring-green-700"
              value={lastName}
              onChange={(e) => setLastName(e.target.value)}
              required
            />
          </div>
          <div>
            <label className="block text-sm font-semibold mb-1">Username</label>
            <input
              type="text"
              className="w-full border border-gray-300 p-2 rounded-md focus:ring-2 focus:ring-green-700"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
            />
          </div>
          <div>
            <label className="block text-sm font-semibold mb-1">Email</label>
            <input
              type="email"
              className="w-full border border-gray-300 p-2 rounded-md focus:ring-2 focus:ring-green-700"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          <div>
            <label className="block text-sm font-semibold mb-1">Password</label>
            <div className="relative">
              <input
                type={hidePassword ? "password" : "text"}
                className="w-full border border-gray-300 p-2 rounded-md focus:ring-2 focus:ring-green-700"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
              <button
                type="button"
                className="absolute right-2 top-2.5 text-sm text-green-700 focus:outline-none"
                onClick={() => setHidePassword(!hidePassword)}
                tabIndex={-1}
              >
                {hidePassword ? 'Show' : 'Hide'}
              </button>
            </div>
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
