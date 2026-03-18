// import React from "react";
import { Navigate } from "react-router-dom";
import React, { useState, useEffect } from "react";

function ProtectedRoute({ children }) {
    const [sessionValid, setSessionValid] = useState(null); // null = loading, true = valid, false = invalid

    useEffect(() => {
        let isMounted = true;
        const checkSession = async () => {
            const token = localStorage.getItem("token"); // always get the latest token
            if (!token || token === "undefined") {
                if (isMounted) setSessionValid(false);
                return;
            }
            try {
                const res = await fetch("http://localhost:3000/check-expired", {
                    method: "GET",
                    headers: {
                        "Content-Type": "application/json",
                        Authorization: `Bearer ${token}`,
                    },
                });
                if (res.status === 200) {
                    if (isMounted) setSessionValid(true);
                } else {
                    throw new Error('Session expired');
                }
            } catch (error) {
                console.error("Session check error:", error);
                if (isMounted) setSessionValid(false);
                localStorage.removeItem("token");
                if (window.location.pathname !== "/") {
                    alert("Session expired. Please log in again.");
                }
            }
        };
        checkSession();
        return () => { isMounted = false; };
    }, []); // run only on mount

    if (sessionValid === null) {
        return null;
    }
    if (sessionValid === false) {
        return <Navigate to="/" replace />;
    }
    return children;
}

export default ProtectedRoute;