import mongoose from "mongoose";

const transactionSchema = mongoose.Schema(
    {
        id: {
            type: String,
            required: true,
            unique: true
        },
        userID: {
            type: String,
            required: true
        },
        productID: {
            type: String,
            required: true
        },
        orderQty: {
            type: Number,
            required: true
        },
        status: {
            type: String,
            enum: ['pending', 'completed', 'cancelled'],
            default: 'pending'
        },
        mop: {
            type: String,
            enum: ['cod', 'card', 'e-wallet', 'bank-transfer'],
            default: 'cod'
        },
        total: {
            type: Number,
            required: true
        },
        email: {
            type: String,
            required: true
        },
        date: {
            type: Date,
            default: Date.now
        },
        time: {
            type: String,
            default: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
        },
    }
);

const Transaction = mongoose.model('Transaction', transactionSchema, 'transactions');

export default Transaction;