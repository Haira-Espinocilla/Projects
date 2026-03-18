import mongoose from "mongoose";

const productSchema = mongoose.Schema(
    {
        id: {
            type: String,
            required: true,
            unique: true
        },
        name: {
            type: String,
            required: true
        },
        desc: {
            type: String,
            required: true
        },
        price: {
            type: Number,
            required: true
        },
        type: {
            type: Number,
            required: true
        },
        qty: {
            type: Number,
            required: true
        },
        image: {
            type: String,
            required: true
        }
    }
);

const Product = mongoose.model('Product', productSchema);

export default Product;