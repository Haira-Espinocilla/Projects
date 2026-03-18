import { getUser, signUp, getAllUsers, login, addToCart, getUserByUsername, updateCartQty, deleteCartItem, returnUser, removeCartItems } from '../controllers/userController.js';
import {getAllProducts, addProduct, updateProduct, updateProductQty, deleteProduct, getProduct, getCartItems, checkStock } from '../controllers/productController.js'
import { addTransaction, getTransactions, cancelTransaction, getAllTransactions, updateTransactionStatus, getConfirmedTransactions } from '../controllers/transactionController.js';
import { authenticateToken, checkToken } from '../middleware/auth.js';

// Contains all routes

// Sample route
const router = (app) => {

    // User routes
    app.post('/register', signUp);
    app.post('/login', getUserByUsername, login);
    app.post('/addToCart', authenticateToken, getUser, addToCart);
    app.get('/getCartItems', authenticateToken, getUser, getCartItems);
    app.post('/updateCartQty', authenticateToken, getUser, updateCartQty);
    app.post('/deleteCartItem', authenticateToken, getUser, deleteCartItem);
    app.post('/removeFromCart', authenticateToken, getUser, removeCartItems);
    app.get('/getUser', authenticateToken, getUser, returnUser );

    // Transaction routes
    app.post('/createTransaction', authenticateToken, getUser, checkStock, addTransaction);
    app.get('/getTransaction', authenticateToken, getUser, getTransactions);
    app.get('/getAllTransactions', authenticateToken, getAllTransactions); // Admin can use this to view all transactions
    app.patch('/cancelTransaction/:id', authenticateToken, getUser, updateProductQty, cancelTransaction);
    app.patch('/updateTransactionStatus/:id', authenticateToken, updateTransactionStatus);
    app.get('/getConfirmedTransactions', authenticateToken, getConfirmedTransactions);

    // Auth only
    app.get('/check-expired', checkToken, (req, res) => {
        res.status(200).send({ message: 'Token is valid' });
    });
    app.get('/check-usertype', authenticateToken, getUser, (req, res) => {
        // res.status(200).send({ message: 'Token is valid' });
        // res.status(200).send({message: res.user.type})
        console.log("user", res.user);
        if (res.user && res.user.type) { 
            res.status(200).send({ message: res.user.type }); 
        } else {
            res.status(400).send("user type not found or user not authenticated");
        }
        console.log("ito yohann", res.user);
    });

    // admin 
    app.get('/getAllUsers', authenticateToken, getUser, getAllUsers);
    app.delete('/deleteProduct/:id', authenticateToken, getUser, deleteProduct);
    app.put('/updateProduct/:id', authenticateToken, getUser, updateProduct);

    // Product routes
    app.post('/addProduct', authenticateToken, getUser, addProduct);
    app.get('/getAllProducts', getAllProducts)
}

export default router;

