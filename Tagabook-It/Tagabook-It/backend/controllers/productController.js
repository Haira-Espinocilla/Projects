import Product from '../models/product.js';
import {v4 as uuidv4} from 'uuid';

// Product API

// Fetch all products in the database
const getAllProducts = async (req, res) => {
    try {
        const products = await Product.find();
        res.status(200).send(products);
    } catch (e) {
        res.status(500).send({ message: e.message });
    }
};

const getCartItems = async (req, res) => {
    try {
        const userCartRefs = res.user.cart;
        const cartItems = [];

        for (const refItem of userCartRefs) {
            try {
                const cartItem = await Product.findOne({ id: refItem.productID });
                if (!cartItem) return res.status(404).send({ error: 'Product not found' });
                cartItems.push({ ...cartItem.toObject(), cartQty: refItem.qty });
            } catch (e) {
                return res.status(500).send({ error: 'Failed to fetch cart item', message: e.message });
            }
        }
        if (!cartItems) return res.status(404).send({ error: 'Cart is empty' });
        return res.status(201).send(cartItems);
    } catch (e) {
        return res.status(500).send({ error: 'Failed to fetch cart items', message: e.message });
    }
}

// Adds a new product in the database
const addProduct = async (req, res) => {
    // const body = req.body;

    // // if (!res.user || res)

    try {
        const { name, type, price, qty, desc, image } = req.body;
        const newProduct = new Product({ id: uuidv4(), name, type, price, qty, desc, image });
        console.log("saving new product: ", newProduct); // added label lang
        await newProduct.save();
        return res.status(200).send(newProduct);
    } catch (e) {
        return res.status(400).send({ message: e.message });
    }
};

// Updates a product in the database
const updateProduct = async (req, res) => {
    try {
        // res.product.name = req.body.name;
        // res.product.desc = req.body.desc;
        // res.product.price = req.body.price;
        // res.product.type = req.body.type;
        // res.product.qty = req.body.qty;
        const { id }  = req.params;

        const updatedProduct = await Product.findOneAndUpdate({id: id}, req.body, {new: true, runValidators: true}); // delets by id
        if (!updatedProduct){
            return res.status(404).send({error: "Product not found"}); // if no matching product returns
        }
        console.log("updated product: ", updatedProduct); // debugging check 
        return res.status(200).json(updatedProduct);
    } catch (e) {
        return res.status(400).send({ error: e.message });
    }
};

// Update a product's quantity
const updateProductQty = async (req, res, next) => {
    try {
        const product = await Product.findOne({ id: req.body.productID }); // await here
        if (!product) throw new Error('Product not found');
        product.qty += req.body.amount; 
        await product.save(); // await here
        next();
    } catch (e) {
        res.status(400).send({ message: e.message });
    }
}

// Deletes a product from the database
const deleteProduct = async (req, res) => {
    try {
        const { id }  = req.params;
        const deletedProduct = await Product.findOneAndDelete({id: id}); // delets by id
        if (!deletedProduct){
            return res.status(404).send({error: "Product not found"}); // if no matching product returns
        }
        res.status(200).send({ message: 'Product deleted saksesfohlly' });
    } catch (e) {
        res.status(500).send({ message: e.message });
    }
};

// Middleware for Product API
const getProduct = async (req, res, next) => {
    let product;
    try {
        product = await Product.findOne({ id: req.body.productID });
        if (!product) res.status(404).send({ message: 'Product not found' });
    } catch (e) {
        res.status(500).send({ message: e.message });
    }

    res.product = product;
    next();
}

const checkStock = async (req, res, next) => {
    let product;
    try {
        product = await Product.findOne({ id: req.body.productID });
        if (!product) return res.status(404).send({ error: 'Product not found' });  
        console.log(product.qty, req.body.orderQty);
        if (product.qty < req.body.orderQty) return res.status(400).send({ error: 'Not enough stock' });
        else {
            // update stock
            product.qty -= req.body.orderQty;
            await product.save();
        }
    } catch (e) {
        console.log(e)
        return res.status(500).send({ error: 'Error occurred while checking stock', message: e.message });
    }
    res.product = product;
    res.totalPrice = product.price * req.body.orderQty;
    next();
}

// NOTE: Add more methods when needed
export { getAllProducts, addProduct, updateProduct, updateProductQty, deleteProduct, getProduct, getCartItems, checkStock };