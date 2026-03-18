import React, { useState, useEffect } from 'react';
import { FaShoppingCart } from 'react-icons/fa';
import Navbar from '../components/navbar.jsx';
import { useNavigate } from 'react-router-dom';

const images = [
    '/src/assets/images/farmImg1.png',
    '/src/assets/images/farmImg2.png',
    '/src/assets/images/farmImg3.png',
    '/src/assets/images/farmImg4.png',
    '/src/assets/images/farmImg5.png',
];

function Dashboard() {

    useEffect(() => { checkUserType(); }, []); // func call
    // check for usertype
    
        const token = localStorage.getItem("token"); // get token 
        
        const checkUserType = async () => {
            const res = await fetch("http://localhost:3000/check-usertype", {
                method: "GET",
                headers: {
                    "Content-Type": "application/",
                    Authorization: `Bearer ${token}`,
                },
            });
            console.log("res", res);
            const data = await res.json();
            console.log("data", data);
            
            if (data.message === 'admin'){
                console.log("admin acc", data);
                // setIsAdmin(true);
                navigate('/admin');
            } else {
                console.log("customer", data);
                // setIsAdmin(false);
                navigate('/dashboard'); 
            }
        }
  



    const navigate = useNavigate();

    const seeProducts = (e) => {
        e.preventDefault();
        navigate('/productList');
    };

    const shoppingCart = (e) => {
        e.preventDefault();
        navigate('/shoppingCart');
    };

    const [currentSlide, setCurrentSlide] = useState(0);

    useEffect(() => {
        const interval = setInterval(() => {
            setCurrentSlide((prev) => (prev + 1) % images.length);
        }, 5000); //change every 5 seconds

        return () => clearInterval(interval);
    }, []);
    return (
        <div className="flex flex-col min-h-screen" style={{ fontFamily: 'Ubuntu, sans-serif' }}>
            <Navbar />

            {/* description */}
            <section className="relative h-[400px] overflow-hidden text-white">
                {/* so that images can have a fade transition everytime it transitions to the next image */}
                {images.map((src, index) => (
                    <img
                        key={index}
                        src={src}
                        alt={`Slide ${index}`}
                        className={`absolute inset-0 w-full h-full object-cover transition-opacity duration-1000 ease-in-out ${index === currentSlide ? 'opacity-100' : 'opacity-0'
                            }`}
                    />
                ))}

                <div className="relative z-10 p-20 bg-black/40 h-full flex flex-col justify-center">
                    <h1 className="text-5xl font-bold mb-4">Who are we?</h1>
                    <p className="max-w-2xl mb-6">
                        TAGABOOK-IT is on a mission to bring fresh, locally grown food directly from farmers to your table. Our platform connects consumers with local farmers, cutting out the middleman and offering farm-fresh produce, meats, dairy, and more—all at great prices.
                    By shopping with us, you're supporting local agriculture and promoting a sustainable food system. We’re here to help you enjoy the freshest ingredients while supporting the hardworking farmers who grow them.
                    </p>
                    <div className="flex flex-row space-x-4">
                        <button
                            onClick={seeProducts}
                            className="bg-[#fc9a01] text-[#154a06] px-4 py-2 rounded font-bold hover:bg-[#f17b01] transition"
                        >
                            PRODUCT LISTING
                        </button>
                        <button
                            onClick={shoppingCart}
                            className="bg-[#fc9a01] text-[#154a06] px-4 py-2 rounded font-bold hover:bg-[#f17b01] transition"
                        >
                            <FaShoppingCart className="text-green-900 text-2xl" />
                        </button>
                    </div>
                </div>
                {/* this is where the carousel images are being displayed */}
                <div className="absolute bottom-4 left-1/2 transform -translate-x-1/2 flex space-x-2 z-20">
                    {images.map((_, index) => (
                        <span
                            key={index}
                            className={`w-3 h-3 rounded-full ${index === currentSlide ? 'bg-green-600' : 'bg-green-300'}`}
                        />
                    ))}
                </div>
            </section>

            {/* contact us */}
            <section className="w-full flex justify-end items-stretch">
                <div className="flex items-stretch gap-15">
                    <div className="flex justify-center items-center bg-white p-4 gap-6">
                        <img
                            src="/src/assets/images/field.jpg"
                            alt="Cornfield"
                            style={{ width: '400px', height: '300px' }}
                            className="rounded shadow-2xl"
                        />
                        <div className="max-w-xl text-green-900 font-semibold text-lg" style={{ lineHeight: '1.6' }}>
                            At <span className="text-[#fc9a01] font-semibold">TAGABOOK-IT</span>, we connect local farmers directly with consumers, offering fresh, high-quality produce and goods.
                            Our platform allows farmers to list their products, while customers can easily browse and purchase directly from the source.
                            We believe in promoting sustainable agriculture, supporting local businesses, and making farm-fresh products accessible to everyone.
                        </div>
                    </div>
                    <div
                        className="bg-green-900 text-white p-10 flex flex-col justify-center shadow-lg space-y-4"
                        style={{ width: '600px', height: '443px' }}
                    >
                        <h2 className="text-4xl font-extrabold tracking-wide text-white border-b border-white pb-2">
                            Contact Us
                        </h2>

                        <div>
                            <h3 className="text-xl font-semibold text-orange-300">Customer Support</h3>
                            <p className="text-sm text-white/90 mt-1">
                                For inquiries about your orders, product availability, or technical help, please email us at:
                            </p>
                            <p className="mt-1 text-sm text-green-200 font-medium">📧 support@tagabookit.com</p>
                        </div>

                        <div>
                            <h3 className="text-xl font-semibold text-orange-300">Farmers & Suppliers</h3>
                            <p className="text-sm text-white/90 mt-1">
                                Interested in selling your fresh, local products on our platform? Contact our farmer support team:
                            </p>
                            <p className="mt-1 text-sm text-green-200 font-medium">📧 farmers@tagabookit.com</p>
                        </div>

                        <div>
                            <h3 className="text-xl font-semibold text-orange-300">General Inquiries</h3>
                            <p className="mt-1 text-sm text-green-200 font-medium">📧 info@tagabookit.com</p>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    );
};

export default Dashboard;