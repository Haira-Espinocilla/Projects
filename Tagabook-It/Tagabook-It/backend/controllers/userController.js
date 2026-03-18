import User from '../models/user.js';
import dotenv from 'dotenv';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

// User API

// Fetch all Users in the database
const getAllUsers = async (req, res) => {
    try {
        const users = await User.find({}, 'firstName middleName lastName email type'); // get all info from fields
        res.status(201).send(users);
    } catch (e) {
        res.status(500).send({ error: e.message });
    }
}

// Adds new user into the database
const signUp = async (req, res) => {
    const body = req.body;
    console.log(body);

    // User already exists
    let userWithName;
    let userWithEmail;
    try {
        userWithName = await User.findOne({ username: body.username });
        userWithEmail = await User.findOne({ email: body.email });
    } catch (e) {
        res.status(500).send({ message: e.message });
    }
    if (userWithEmail) return res.status(400).send({ error: 'email-exists' });
    if (userWithName) return res.status(400).send({ error: 'username-exists' });


    // Save User
    try {
        const { firstName, middleName, lastName, email, username, password } = req.body;
        const hashedPassword = await bcrypt.hash(password, 10);

        // Instantiate Model
        const newUser = User({ 
            firstName, 
            middleName, 
            lastName, 
            email, 
            username,
            password: hashedPassword, 
            type: "customer" ,
            cart: []
        });

        await newUser.save();   // Register to the Db
        res.status(201).send({ message: 'User registered successfully' });
    } catch (e) {
        res.status(500).send({ error: e.message });
    }
}

// Checks user credentials
const login = async (req, res) => {
    try {
        const { password } = req.body;
        // getUser middleware will handle the find and passed to 'res.user'
        const isPasswordValid = await bcrypt.compare(password, res.user.password);
        if (!isPasswordValid) return res.status(401).send({ error: 'Invalid password' });
        
        // token
        const { password: _pw, __v: __v, ...cleanedUser } = res.user._doc;
        console.log(cleanedUser);
        const token = jwt.sign({ ...cleanedUser }, process.env.TOKEN_SK, { expiresIn: '1hr' });
        res.status(200).send({ message: 'Login successful', token: token});
    } catch (e) {
        res.status(500).send({ error: 'Login failed', message: e.message });
    }
}

const addToCart = async (req, res) => {
    try {
        const { productID } = req.body;
        // autheticateToken middleware will handle the find and passed to 'res.user'
        if (res.user.cart.length === 0) {
            res.user.cart.push({
                productID: productID,
                qty: 1
            });
            await res.user.save();
            return res.status(200).send({ message: 'Product added to cart' });
        }
        
        const cartItem = res.user.cart.find(item => item.productID === productID);
        if (cartItem) {
            cartItem.qty += 1; // increment
        } else {
            res.user.cart.push({
                productID: productID,
                qty: 1 // default
            });
        }
        res.user.markModified('cart');
        await res.user.save();
        res.status(200).send({ message: 'Product added to cart' });
    } catch (e) {
        res.status(500).send({ error: 'Failed to add product to cart', message: e.message });
    }
}

const updateCartQty = async (req, res) => {
    try {
        const { productID, qty } = req.body;
        const cartItem = res.user.cart.find(item => item.productID === productID);
        if (!cartItem) return res.status(404).send({ error: 'Product not in cart' });
        
        if (qty === 0) {
            res.user.cart = res.user.cart.filter(item => item.productID !== productID);
        } else {
            cartItem.qty = qty;
        }
        res.user.markModified('cart');
        await res.user.save();
        res.status(200).send({ message: 'Cart updated' });
    } catch (e) {
        res.status(500).send({ error: 'Failed to update cart', message: e.message });
    }
}

// delete one cart item
const deleteCartItem = async (req, res) => {
    try {
        const { productID } = req.body;
        const cartItem = res.user.cart.find(item => item.productID === productID);
        if (!cartItem) return res.status(404).send({ error: 'Product not in cart' });
        
        res.user.cart = res.user.cart.filter(item => item.productID !== productID);
        res.user.markModified('cart');
        await res.user.save();
        res.status(200).send({ message: 'Cart updated' });
    } catch (e) {
        res.status(500).send({ error: 'Failed to update cart', message: e.message });
    }
}

// delete multiple cart items
const removeCartItems = async (req, res) => {
    try {
        const { productIDs } = req.body;
        res.user.cart = res.user.cart.filter(item => !productIDs.includes(item.productID));
        res.user.markModified('cart');
        await res.user.save();
        res.status(200).send({ message: 'Cart updated' });
    } catch (e) {
        res.status(500).send({ error: 'Failed to update cart', message: e.message });
    }
}


// Update user in the database
const updateUser = async (req, res) => {
    try {
        const { firstName, middleName, lastName, password } = res.body;
        const hashedPassword = bcrypt.hash(password, 10);

        // User 'res.user' from middleware getUser()
        res.user = {
            ...res.user,
            firstName, middleName, lastName,
            password: hashedPassword
        }

        const updatedUser = await res.user.save();
        res.status(201).send({ message: 'User updated' });
    } catch (e) {
        res.status(400).send({ error: 'User update failed', message: e.message });
    }
}


// Deletes a user from the database
const deleteUser = async (req, res) => {
    try {
        await res.user.deleteOne();
        res.status(200).send({ message: 'User deleted' });
    } catch (e) {
        res.status(500).send({ message: e.message });
    }
}

// Middleware for User API
const getUser = async (req, res, next) => {
    let user;
    try {
        user = await User.findOne({ username: res.username });
        console.log("userobject: ", user);
        if(!user) return res.status(404).send({ error: "User not found!" });
    } catch (e) { 
        console.log(e)
        return res.status(500).send({ error: e.message });
    }

    res.user = user;
    next();
}

const getUserByUsername = async (req, res, next) => {
    let user;
    try {
        user = await User.findOne({ username: req.body.username });
        if(!user) return res.status(404).send({ error: "User not found" }); 
    }
    catch (e) { 
        return res.status(500).send({ error: e.message });
    }
    res.user = user;
    next();
}

const returnUser = async (req, res) => {
    res.status(200).send(res.user);
}

const authUser = async (req, res) => {
    res.status(200).send(res.user);
}

// NOTE: Add more methods when needed
export { removeCartItems, returnUser, getAllUsers, signUp, login, updateUser, deleteUser, getUser, authUser, addToCart, getUserByUsername, updateCartQty, deleteCartItem };
