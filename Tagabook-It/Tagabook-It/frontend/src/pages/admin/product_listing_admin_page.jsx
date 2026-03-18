import React, { useState, useEffect } from 'react';
import { FaArrowLeft } from 'react-icons/fa';
import { useNavigate } from 'react-router-dom';
// import Navbar from '../../../frontend/src/Components/navbaradmin1';
import Navbar from '../../components/navbaradmin1';

// const initialProducts = [
//   { id: 1, name: 'Carrots', type: 'Crops', price: 10.0, description: 'Fresh organic carrots', quantity: 20, image: 'src/assets/images/bg_image.jpg' },
//   { id: 2, name: 'Corn', type: 'Crops', price: 15.0, description: 'Sweet corn from local farms', quantity: 50, image: 'src/assets/images/field.jpg' },
//   { id: 3, name: 'Chicken', type: 'Poultry', price: 75.0, description: 'Free-range chicken', quantity: 30, image: 'src/assets/images/bg_image.jpg' },
// ];

function AdminProductList() {
  // const [products, setProducts] = useState(initialProducts);
  const [products, setProducts] = useState([]); // empty state
  const [filter, setFilter] = useState('All');
  const [sortBy, setSortBy] = useState('name');
  const [sortOrder, setSortOrder] = useState('asc');
  const [showForm, setShowForm] = useState(false);
  const [editingProduct, setEditingProduct] = useState(null);

   const fetchProducts = async () => {
      try {
        const token = localStorage.getItem('token'); // get token 
  
        // check if token is here siguro      
        const res = await fetch('http://localhost:3000/getAllProducts', { // implement this endpoint
            method: 'GET',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': `Bearer ${token}`, 
            },
          });
    
          // check if !res.ok
    
          const data = await res.json();
          console.log("current", data);
          setProducts(data); // dapat array return ni getAllUsers
    
      } catch (error) {
        console.error("getAllUsers failed: ", error);
      }
    }
  
    useEffect(() => {
      fetchProducts();
      
    }, []);

  const navigate = useNavigate();

  const handleSort = (criteria) => {
    if (sortBy === criteria) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    } else {
      setSortBy(criteria);
      setSortOrder('asc');
    }
  };

  const handleDelete = async (productId) => {
    if (!window.confirm('Are you sure you want to delete this product?')) {
      return;
    }
    try {
      const token = localStorage.getItem('token');
      const res = await fetch(`http://localhost:3000/deleteProduct/${productId}`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
      });

      if (!res.ok) {  // status 200 ?
        const data = await res.json();
        throw new Error(data.message || 'Failed to delete product');
      }

      setProducts(products.filter((p) => p.id !== productId));
    } catch (error) {
      console.error("Error deleting product: ", error);
      alert("Error deleting product: " + error.message);
    }
  };

  const handleEdit = (product) => {
    setEditingProduct(product);
    setShowForm(true);
  };

  const handleFormSubmit = async (e) => {
    e.preventDefault();
    const form = e.target;
    const newProductData = {
      name: form.name.value,
      type: form.type.value,
      price: parseFloat(form.price.value),
      qty: parseInt(form.quantity.value),
      desc: form.description.value,
      image: form.image.value || 'src/assets/images/bg_image.jpg', // ginawa kong default image
    };

    try {
      const token = localStorage.getItem('token');
      let res, updatedProduct;
      if (editingProduct) {
        // edit existing product
        res = await fetch(`http://localhost:3000/updateProduct/${editingProduct.id}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`,
          },
          body: JSON.stringify(newProductData),
        });
        updatedProduct = await res.json();
        setProducts(products.map((p) => (p.id === updatedProduct.id ? updatedProduct : p)));
      } else {
        // add new product
        res = await fetch('http://localhost:3000/addProduct', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`,
          },
          body: JSON.stringify(newProductData),
        });
        // reload
        window.location.reload();
      }

      setEditingProduct(null);
      setShowForm(false);

    } catch (error) {
      console.error(`error ${editingProduct ? 'edited' : 'added'} product!`, error);
    }
  };

  const sortedFilteredProducts = [...products]
    .filter((p) => filter === 'All' || p.type === filter)
    .sort((a, b) => {
      if (sortBy === 'price' || sortBy === 'type' || sortBy === 'qty') {
        return sortOrder === 'asc' ? a[sortBy] - b[sortBy] : b[sortBy] - a[sortBy];
      } else {
        return sortOrder === 'asc'
          ? a[sortBy].localeCompare(b[sortBy])
          : b[sortBy].localeCompare(a[sortBy]);
      }
    });
  
  const getlabel = (type) => {
    switch (type) {
      case 'Crops':
        return 1;
      case 'Poultry':
        return 2;
      default:
        return 'All';
    }
  }

  return (
    <div className="min-h-screen bg-[#efefef]" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
      <Navbar />

      <div className="mt-4 px-6">
        <div className="flex justify-between items-center mb-4">
          <button onClick={() => navigate(-1)} className="flex items-center gap-2 text-green-900 hover:text-green-800">
            <FaArrowLeft /> Back
          </button>

          <div className="flex gap-2">
            {['All', 'Crops', 'Poultry'].map((label) => (
              <button
                key={label}
                onClick={() => setFilter(getlabel(label))}
                className={`px-4 py-2 rounded-full font-semibold transition ${
                  filter === getlabel(label) ? 'bg-green-900 text-white' : 'bg-green-700 text-white hover:bg-green-800'
                }`}
              >
                {label}
              </button>
            ))}
          </div>

          <div className="flex gap-2 items-center">
            <span className="text-green-900 font-semibold">Sort by:</span>
            {['name', 'type', 'price', 'qty'].map((key) => (
              <button
                key={key}
                onClick={() => handleSort(key)}
                className={`px-3 py-1 rounded text-sm font-medium ${
                  sortBy === key ? 'bg-green-800 text-white' : 'bg-green-300 hover:bg-green-400'
                }`}
              > 
              {/*visual toggle + uppercase button */}
                {key == 'qty' ? 'Quantity' : key.charAt(0).toUpperCase() + key.slice(1)}
                {sortBy === key ? (sortOrder === 'asc' ? ' ▲' : ' ▼') : ''}
              </button>
            ))}
            <button onClick={() => setShowForm(true)} className="ml-4 bg-orange-600 text-white px-4 py-2 rounded hover:bg-orange-700">
              + Add Product
            </button>
          </div>
        </div>

        {/* Product Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {sortedFilteredProducts.map((product) => (
            <div key={product.id} className="bg-white shadow-md rounded-xl p-4 flex flex-col">
              <img src={product.image} alt={product.name} className="h-40 w-full object-cover rounded-lg" />
              <h2 className="text-xl font-bold text-green-900 mt-2">{product.name}</h2>
              <p className="text-sm text-green-800">{product.description}</p>
              <div className="mt-2 text-green-900 text-sm">
                <p><strong>Type:</strong> {(product.type)==2 ? 'Poultry' : 'Crop'}</p>
                <p><strong>Price:</strong> Php {product.price.toFixed(2)}</p>
                <p><strong>Quantity:</strong> {product.qty}</p>
              </div>
              <div className="mt-auto flex justify-between gap-2 pt-4">
                <button
                  onClick={() => handleEdit(product)}
                  className="bg-green-700 text-white px-3 py-1 rounded hover:bg-green-800"
                >
                  Edit
                </button>
                <button
                  onClick={() => handleDelete(product.id)}
                  className="bg-orange-600 text-white px-3 py-1 rounded hover:bg-orange-700"
                >
                  Delete
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Modal Form */}
      {showForm && (
        <div className="fixed inset-0 bg-opacity-50 backdrop-blur-sm flex items-center justify-center z-50">
          <form onSubmit={handleFormSubmit} className="bg-white p-6 rounded-xl shadow-lg w-full max-w-md space-y-4">
            <h2 className="text-2xl font-bold text-green-900">{editingProduct ? 'Edit Product' : 'Add New Product'}</h2>
            <div>
              <label className="block text-xs font-semibold text-green-900 mb-1">Name</label>
              <input type="text" name="name" placeholder="Name" defaultValue={editingProduct?.name} required className="w-full p-2 border rounded" />
            </div>
            <div>
              <label className="block text-xs font-semibold text-green-900 mb-1">Type</label>
              <select
                name="type"
                defaultValue={editingProduct?.type || ''}
                required
                className="w-full p-2 border rounded"
              >
                <option value="" disabled>Select type</option>
                <option value={1}>Crops</option>
                <option value={2}>Poultry</option>
              </select>
            </div>
            <div>
              <label className="block text-xs font-semibold text-green-900 mb-1">Price</label>
              <input type="number" name="price" placeholder="Price" step="0.01" defaultValue={editingProduct?.price} required className="w-full p-2 border rounded" />
            </div>
            <div>
              <label className="block text-xs font-semibold text-green-900 mb-1">Quantity</label>
              <input type="number" name="quantity" placeholder="Quantity" defaultValue={editingProduct?.qty} required className="w-full p-2 border rounded" />
            </div>
            <div>
              <label className="block text-xs font-semibold text-green-900 mb-1">Description</label>
              <textarea name="description" placeholder="Description" defaultValue={editingProduct?.desc} required className="w-full p-2 border rounded" />
            </div>
            <div>
              <label className="block text-xs font-semibold text-green-900 mb-1">Image URL (optional)</label>
              <input type="text" name="image" placeholder="Image URL (optional)" defaultValue={editingProduct?.image} className="w-full p-2 border rounded" />
            </div>
            <div className="flex justify-end gap-2">
              <button type="button" onClick={() => { setShowForm(false); setEditingProduct(null); }} className="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400">Cancel</button>
              <button type="submit" className="px-4 py-2 bg-green-800 text-white rounded hover:bg-green-700">Save</button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}

export default AdminProductList;
