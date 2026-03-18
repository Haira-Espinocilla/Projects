import mongoose from "mongoose";

const userSchema = mongoose.Schema(
    {
        firstName: {
            type: String,
            required: true
        },
        middleName: {
            type: String,
        },
        lastName: {
            type: String,
            required: true
        },
        type: {
            type: String,
            enum: ['admin', 'customer'],
            default: 'customer'
        },
        email: {
            type: String,
            required: true,
            unique: true
        },
        username: {
            type: String,
            required: true,
            unique: true
        },
        password: {
            type: String,
            required: true
        },
        cart:
        {
            type: Array,
            default: []
        },
    }
);

const User = mongoose.model('User', userSchema, 'users');

export default User;