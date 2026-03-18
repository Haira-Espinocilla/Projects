import {v4 as uuidv4} from 'uuid';
import Transaction from "../models/transaction.js";

// Transaction API

// Adds a new transaction
const addTransaction = async (req, res) => {
    const body = req.body;

    const newTransaction = Transaction({
        id: uuidv4(),
        userID: res.user.id,
        productID: body.productID, //
        orderQty: body.orderQty,
        mop: body.mop,
        total: res.totalPrice, //
        email: res.user.email,
    })

    console.log("saving new transaction: ", newTransaction); // added label lang
    try {
        await newTransaction.save();
        console.log("saved this transaction successfully: ", newTransaction); // debugging check
        res.status(200).send(newTransaction);
    } catch (e) {
        console.log("error saving transaction: ", e); //
        res.status(500).send({ message: e.message });
    }
}

const getTransactions = async (req, res) => {
    try {
        const transactions = await Transaction.find({ userID: res.user.id }).populate({
                path: 'productID',
                model: 'Product', 
                localField: 'productID', 
                foreignField: 'id' 
            }); // 口fetch product details using prodID
        // if (!transaction) return res.status(404).send({ error: 'Transaction not found' });
        if (!transactions || transactions.length === 0) {
            // return an empty array instead of 404 if no transactions since baka new user lang sha
            return res.status(200).send([]);
        }
        console.log("transactions found: ", transactions); // debugging check
        res.status(200).send(transactions); // empty array is valid so i think sending it still is ok
    } catch (e) {
        console.log("error getting transaction: ", e); //
        res.status(500).send({ message: e.message });
    }
}

const cancelTransaction = async (req, res) => {
    const transactionID = req.params.id; // <-- fix here

    try {
        const transaction = await Transaction.findOneAndUpdate(
            { id: transactionID, userID: res.user.id },
            { status: 'canceled' }, // use 'canceled' to match frontend
            { new: true }
        );

        if (!transaction) {
            return res.status(404).send({ error: 'Transaction not found or already canceled' });
        }

        res.status(200).send(transaction);
    } catch (e) {
        console.log("error cancelling transaction: ", e);
        res.status(500).send({ message: e.message });
    }
}

const updateTransactionStatus = async (req, res) => {
    const transactionID = req.params.id;
    const { status } = req.body;
    try {
        const transaction = await Transaction.findOneAndUpdate(
            { id: transactionID },
            { status: status },
            { new: true }
        );
        if (!transaction) {
            return res.status(404).send({ error: 'Transaction not found' });
        }
        res.status(200).send(transaction);
    } catch (e) {
        res.status(500).send({ message: e.message });
    }
};

const getAllTransactions = async (req, res) => {
    try {
        const transactions = await Transaction.find({}).populate({
            path: 'productID',
            model: 'Product',
            localField: 'productID',
            foreignField: 'id'
        });
        res.status(200).send(transactions);
    } catch (e) {
        res.status(500).send({ message: e.message });
    }
};

const getConfirmedTransactions = async (req, res) => {
    try {
        const transactions = await Transaction.find({ status: { $in: [1, 'completed'] } }).populate({
            path: 'productID',
            model: 'Product',
            localField: 'productID',
            foreignField: 'id'
        });
        res.status(200).send(transactions);
    } catch (e) {
        res.status(500).send({ message: e.message });
    }
};

// NOTE: Add more methods when needed
export { addTransaction, getTransactions, cancelTransaction, updateTransactionStatus, getAllTransactions, getConfirmedTransactions };