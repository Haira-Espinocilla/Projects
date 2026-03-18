//Shopping_Cart/shopping_cart_page.jsx
import { useNavigate } from 'react-router-dom';
import React, { useState, useEffect } from 'react';
import Navbar3 from '../components/navbar3';
import { FaArrowLeft } from 'react-icons/fa';

function ShoppingCart() {
  const navigate = useNavigate();
  const [chosenItems, setChosenItems] = useState([]); // selected product IDs
  const [showModal, setShowModal] = useState(false); // to show the confirmation delete modal
  const [products, setProducts] = useState([]); // get products from server
  const [productToDelete, setProductToDelete] = useState(null); // product to delete
  const [showSuccessModal, setShowSuccessModal] = useState(false); // to show the delete success/error modal
  const [successMessage, setSuccessMessage] = useState('');  // store the success message for the modal

  // to navigate to place order screen
  const checkout = (e) => {
    e.preventDefault();
    const selectedProducts = products.filter(product => chosenItems.includes(product.id));
    console.log('Selected items:', selectedProducts);
    navigate('/placeOrder', { state: { selectedProducts } });
  };

  // separate useeffect for fetch cart
  useEffect(() => {
    fetchCartItems();
  }, []); 

  // lock scroll
  useEffect(() => {
    // fetchCartItems();
    document.body.style.overflow = showModal ? 'hidden' : 'auto';
    return () => { document.body.style.overflow = 'auto'; };
  }, [showModal, showSuccessModal]);

  // recalculate total prrice and items after delete
  useEffect(() => {products, chosenItems});

  // fetch cart items from the server
  const fetchCartItems = async () => {
    try {
      const token = localStorage.getItem('token');
      const res = await fetch('http://localhost:3000/getCartItems', {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
      });
      if (res.status !== 201) {
        throw new Error('Failed to fetch cart items');
      }
      const data = await res.json();
      setProducts(data);
      setChosenItems(data.map(product => product.id)); // select all products in cart so that it's auto calculated
      console.log('Fetched cart items:', data);
    } catch (error) {
      console.error('Error fetching cart items:', error);
    }
  };

  // sync to backend
  const updateCartQty = async (productId, qty) => {
    setProducts(prevProducts =>
      prevProducts.map(product =>
        product.id === productId
          ? { ...product, cartQty: qty < 1 ? 1 : qty }
          : product
      )
    );
    try {
      const token = localStorage.getItem('token');
      await fetch('http://localhost:3000/updateCartQty', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
        body: JSON.stringify({
          productID: productId,
          qty: qty < 1 ? 1 : qty,
        }),
      });
    } catch (error) {
      console.error('Error updating cart qty:', error);
    }
  };

  // checkbox
  const toggleSelect = (product) => {
    setChosenItems(prev =>
      prev.includes(product.id)
        ? prev.filter(id => id !== product.id)
        : [...prev, product.id]
    );
  };

  // trigger confirmation modal to delete a product
  const confirmDelete = (product) => {
    setProductToDelete(product);
    setShowModal(true);
  };

  // dleete and sync to backend
  const deleteCartItem = async () => {
    // Update list
    setProducts(prevProducts =>
      prevProducts.filter(product => product.id !== productToDelete.id)
    );

    setChosenItems(prevChosenItems =>
      prevChosenItems.filter(id => id !== productToDelete.id)
    );

    setShowModal(false);
    setProductToDelete(null);
    try {
      const token = localStorage.getItem('token');
      await fetch('http://localhost:3000/deleteCartItem', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
        body: JSON.stringify({
          productID: productToDelete.id,
        }),
      });
      // alert('Product removed from cart'); // to be replaced with the success modal
      setSuccessMessage('Product removed from cart');
      setShowSuccessModal(true);
    } catch (error) {
      console.error('Error deleting cart item:', error);
      setSuccessMessage('Error deleting cart item');
      setShowSuccessModal(true);
    }
  };

  // calculate total price
  const totalPrice = products
    .filter(product => chosenItems.includes(product.id))
    .reduce((total, product) => total + parseFloat(product.price) * product.cartQty, 0);

  // 口check
  console.log('Total Price:', totalPrice, 'Chosen Items:', chosenItems.length);
  return (
    <div className="min-h-screen bg-gray-100 font-sans" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
      <div className="fixed top-0 left-0 w-full z-50">
        <Navbar3 pageName="Shopping Cart" />
        <div className="mt-2 ml-4">
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
      <div className="pt-32 px-4 pb-40">
        {products.map(product => (
          <div key={product.id} className="max-w-5xl mx-auto bg-white p-6 mt-6 rounded-xl shadow">
            <div className="flex items-center mb-4">
              <input
                type="checkbox"
                className="mr-4 w-6 h-6 accent-[#154a06]"
                checked={chosenItems.includes(product.id)}
                onChange={() => toggleSelect(product)}
              />
              <h2 className="text-2xl font-bold text-green-900">{product.name}</h2>
            </div>
            <hr className="border-t-2 border-green-900 mb-4" />
            <div className="flex flex-col md:flex-row gap-6">
              <img src={product.image} alt={product.name} className="w-35 h-35 object-cover border" />
              <div className="flex-1 text-green-900">
                <p className="mb-4">{product.desc}</p>

                {/* quantity */}
                <div className="flex items-center mb-4 border border-green-800 rounded w-fit">
                  <button onClick={() => updateCartQty(product.id, product.cartQty - 1)} className="border-r border-green-800 text-green-800 px-4 py-2 hover:bg-green-800 hover:text-white">-</button>
                  <span className="px-6 py-2 bg-white text-green-900 font-semibold">{product.cartQty}</span>
                  <button onClick={() => updateCartQty(product.id, product.cartQty + 1)} className="border-l border-green-800 text-green-800 px-4 py-2 hover:bg-green-800 hover:text-white">+</button>
                </div>
                <p className="text-3xl mt-10">Php {product.price.toFixed(2)}</p>
              </div>

              {/* delete button */}
              <div className="flex items-end justify-end">
                <button onClick={() => confirmDelete(product)} className="bg-orange-500 text-white font-bold py-2 px-6 rounded hover:bg-orange-600 shadow-md">DELETE</button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* fixed footer */}
      <div className="bg-white w-full shadow-md p-6 fixed bottom-0 z-40">
        <div className="max-w-5xl mx-auto flex justify-between items-center">
          <div>
            <h3 className="text-2xl font-bold text-green-900">Total: Php {totalPrice.toFixed(2)}</h3>
            <p className="text-green-800">{chosenItems.length} item(s)</p>
          </div>
          <button onClick={checkout} className="bg-green-900 text-white font-bold py-3 px-8 rounded hover:bg-green-800 shadow-md">CHECK OUT</button>
        </div>
      </div>

      {/* modal for confirmation delete */}
      {showModal && productToDelete && (
        <div className="fixed inset-0 z-50 bg-black/30 backdrop-blur-sm flex justify-center items-center">
          <div className="bg-white rounded-lg shadow-xl p-8 border-2 border-green-900 max-w-md w-full">
            <h2 className="text-xl font-bold text-green-900 mb-4">Confirm Deletion</h2>
            <p className="text-green-800 mb-6">Are you sure you want to remove <span className="font-semibold">{productToDelete.name}</span> from your shopping cart?</p>
            <div className="flex justify-end space-x-4">
              <button onClick={() => setShowModal(false)} className="px-4 py-2 bg-gray-300 text-gray-800 rounded hover:bg-gray-400">Cancel</button>
              <button onClick={deleteCartItem} className="px-4 py-2 bg-orange-500 text-white rounded hover:bg-orange-600">Delete</button>
            </div>
          </div>
        </div>
      )}
      
    {/* modal for success/error notif */}
      {showSuccessModal && (
        <div className="fixed inset-0 z-50 bg-black/30 backdrop-blur-sm flex justify-center items-center">
          <div className="bg-white rounded-lg shadow-xl p-8 border-2 border-green-900 max-w-md w-full">
            {/* <h2 className="text-xl font-bold text-green-900 mb-4">Notice</h2> */}
            <p className="text-green-800 mb-6">{successMessage}</p>
            <div className="flex justify-end space-x-4">
              <button onClick={() => setShowSuccessModal(false)} className="px-4 py-2 bg-gray-300 text-gray-800 rounded hover:bg-gray-400">OK</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ShoppingCart;
