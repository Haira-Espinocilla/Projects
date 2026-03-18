import React, { useState } from 'react';
import axios from 'axios';
import Data from '../components/Data';

function Account() {

  const [data, setData] = useState('');

  // WIP ( no endpoint yet in backend )
  const getUserData = async () => {
    try {
      const userToken = localStorage.getItem('token');

      // move to a provider;
      const response = await axios.get('http://localhost:3000/myacc', {
        headers: {
          'authorization': `Bearer ${userToken}`
        }
      })
      console.log(response.data);
      setData(response.data.username);
    } catch (e) {
      console.log('Error fetching user data:', e);
    }
  }

  return (
    <div className='w-full h-screen bg-[#1a1a1a] text-white flex
    justify-center items-center flex-col'>
      <h2 className='text-2xl'>ACCOUNT</h2> 

      <button onClick={getUserData}>get data</button>
      <Data data={data} />
    </div>
  )
}

export default Account;