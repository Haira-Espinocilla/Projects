import jwt from 'jsonwebtoken';

const authenticateToken = (req, res, next) => {
    const header = req.headers['authorization'];
    const token = header && header.split(' ')[1]

    if (!token) {
        console.log("no token"); // added log
        return res.status(401).send({ error: 'unauthorized: no token' });
    } 
    // wrapping in try catch to see if log in error
    try {
        const decoded = jwt.verify(token, process.env.TOKEN_SK);
        res.username = decoded.username;
        // res.username = decoded._doc.username;
        next();
    } catch (error) {
        if (error.name === 'TokenExpiredError') {
            return res.status(401).send({ error: 'unauthorized: token expired' });
        }
        return res.status(403).send({ error: 'unauthorized: invalid token' }); 
    }
    
}

const checkToken = (req, res, next) => {
    const header = req.headers['authorization'];
    const token = header && header.split(' ')[1]
    if (!token) return res.status(401).send({ error: 'unauthorized' });

    jwt.verify(token, process.env.TOKEN_SK, (err, decoded) => {
        if (err) return res.status(403).send({ error: 'forbidden' });
        res.username = decoded.username;
        // res.username = decoded._doc.username;
        next();
    });
}

export { authenticateToken, checkToken }; 