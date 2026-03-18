import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Login from './pages/Login.jsx';
import SignUp from './pages/sign_up_page.jsx';
import Dashboard from './pages/dashboard_page.jsx';
import ProductList from './pages/product_listing_page.jsx';
import ShoppingCart from './pages/shopping_cart_page.jsx';
import PlaceOrder from './pages/place_order_page.jsx';
import MyOrders from './pages/my_orders_page.jsx';
import ProtectedRoute from './components/ProtectedRoute.jsx'; 
import AdminDashboard from './pages/admin/dashboard_admin.jsx';
import AdminAccountsManagement from './pages/admin/accounts_page.jsx';
import AdminProductList from './pages/admin/product_listing_admin_page.jsx';
import OrderStatusAdmin from './pages/admin/order_status_page.jsx';
import SalesReportAdmin from './pages/admin/sales_report_page.jsx';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/signUp" element={<SignUp />} />
        <Route path="/login" element={<Login />} />
        <Route path="/dashboard" element={<ProtectedRoute><Dashboard /></ProtectedRoute>} />
        <Route path="/productList" element={<ProtectedRoute><ProductList /></ProtectedRoute>} />
        <Route path="/shoppingCart" element={<ProtectedRoute><ShoppingCart /></ProtectedRoute>} />
        <Route path="/placeOrder" element={<ProtectedRoute><PlaceOrder /></ProtectedRoute>} />
        <Route path="/myOrders" element={<ProtectedRoute><MyOrders /></ProtectedRoute>} />
        <Route path="/accounts" element={<ProtectedRoute><AdminAccountsManagement /></ProtectedRoute>} />
        <Route path="/productListAdmin" element={<ProtectedRoute><AdminProductList /></ProtectedRoute>} />
        <Route path="/admin" element={<ProtectedRoute><AdminDashboard /></ProtectedRoute>}></Route>
        <Route path="/orderStatus" element={<ProtectedRoute><OrderStatusAdmin /></ProtectedRoute>}></Route>
        <Route path="/salesReport" element={<ProtectedRoute><SalesReportAdmin /></ProtectedRoute>}></Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
