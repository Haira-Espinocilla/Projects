import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Login from './Log_In/Login';
import Dashboard from './Dashboard/dashboard_page';
import ProductList from './Product_Listing/product_listing_page';
import ShoppingCart from './Shopping_Cart/shopping_cart_page';
import PlaceOrder from './Place_Order/place_order_page';
import MyOrders from './My_Orders/my_orders_page';
import SignUp from './Sign_Up/sign_up_page';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/signUp" element={<SignUp />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/productList" element={<ProductList />} />
        <Route path="/shoppingCart" element={<ShoppingCart />} />
        <Route path="/placeOrder" element={<PlaceOrder />} />
        <Route path="/myOrders" element={<MyOrders />} />
        <Route path="/logOut" element={<Login />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
