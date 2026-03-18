import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import bgImage from '/src/assets/images/bg_image.jpg';

function Login() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [hidepassword, setHidePassword] = useState(true);
  const [errorMsg, setErrorMsg] = useState(''); // <-- add this
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (token && token !== 'undefined') {
      navigate('/dashboard');
    }
  }, []);

  const handleLogin = async (event) => {
    event.preventDefault();
    setErrorMsg(''); // clear previous error
    try {
      const res = await fetch('http://localhost:3000/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          username,
          password,
        }),
      });
      const data = await res.json();
      if(res.status !== 200) {
        throw new Error(data.error); 
      }
      const token = data.token;
      setUsername('');
      setPassword('');
      localStorage.setItem('token', token);
      navigate('/dashboard'); 
    } catch (error) {
      setErrorMsg(error.message); // set error message for display
    }
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

          <form className="bg-white p-6 rounded-xl shadow w-full md:w-1/2 space-y-4" onSubmit={handleLogin}>
            {errorMsg && (
              <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-2 rounded mb-2 text-center">
                {errorMsg}
              </div>
            )}
            <div>
              <label className="block text-sm font-bold mb-1 text-[#154a06]">Username</label>
              <input
                type="text"
                placeholder="Enter your username"
                className="w-full border border-gray-300 p-2 rounded focus:outline-none focus:ring-2 focus:ring-[#154a06]"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
              />
            </div>
            <div>
              <label className="block text-sm font-bold mb-1 text-[#154a06]">Password</label>
              <div className="relative">
                <input
                  type={hidepassword ? "password" : "text"}
                  placeholder="Enter your password"
                  className="w-full border border-gray-300 p-2 rounded focus:outline-none focus:ring-2 focus:ring-[#154a06]"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                />
                <button
                  type="button"
                  className="absolute right-2 top-2.5 text-sm text-[#154a06] focus:outline-none"
                  onClick={() => setHidePassword(!hidepassword)}
                >
                  {hidepassword ? "Show" : "Hide"}
                </button>
              </div>
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
