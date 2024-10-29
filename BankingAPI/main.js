const { MongoClient, Double } = require('mongodb')
const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')
const crypto = require('crypto')
const { encrypt,decrypt } = require('./back')
const { basename } = require('path')
const { send } = require('process')

const PORT = 5001
const HOST = "192.168.10.10"
const app = express()

let globalKey;

app.use(cors())
app.use(bodyParser.json())
const uri = 'mongodb://localhost:27017'
const client = new MongoClient(uri)
const dbname = 'Bank'
const collectionName = 'users'

client.connect()
    .then(() => {
        console.log('Connect MongoDB');
        return getKey()
    })
    .then((mykey) => {
        setKey(crypto.createHash('sha256').update(mykey).digest('base64').substring(0,32))
    })
    .catch(err => console.error('Connect Error MongoDB:', err));


const db = client.db(dbname)

async function getKey(){
    try {
        let key
        const result = await db.collection('key').find().toArray()
        for (let index = 0; index < result.length; index++) {
            key = result[index].key
        }
        return key
    } catch (error) {
        console.error(error)       
    }
}

function setKey(key){
    globalKey = key
}

const updateKey = setInterval(async () => {
    try {
        const collection = await db.collection("card").find().toArray()
        for(let card of collection){
            await db.collection("card").updateOne({username:card.username}, {$set: {key:crypto.createHash('sha-256').update(crypto.randomBytes(32)).digest('base64').substring(0,32)}})
        }
        console.log("Key Updates")
    } catch (error) {
        console.error(error)
    }
},600000*24)

app.post('/api/users/findName', async (req,res) => {
    try {
        let isFind = true
        const name = req.body.name
        const user = await db.collection(collectionName).findOne({name:name})
        res.json(isFind)
    } catch (error) {
        console.error(error)
    }
})

app.post('/api/users/add-balance',async (req,res) => {
    try {
        let balance = 0.0
        const username = req.body.username
        const amount = req.body.amount
        const card = await db.collection('card').findOne({username:username})
        balance = card.balance += amount
        const changeBalance = await db.collection('card').updateOne(
            {username: username},
            {$set:{balance:balance}}
        )
        res.json(balance)
    } catch (error) {
        console.error(error)
    }
})

app.post('/api/users/send-money',async (req,res) => {
    try {
        let isSend = false
        const data = {
            username:req.body.username,
            senduserkey:req.body.senduserkey,
            amount:req.body.amount
        }
        const sender = await db.collection('card').findOne({username:data.username})
        const taker = await db.collection('card').findOne({key:data.senduserkey})
        const bank = await db.collection('bankwallet').findOne({name:"Bank"})
        if(sender && taker && bank){
            const isThenProcent = data.amount / 100 * 10;
            if(sender.balance >= data.amount + isThenProcent){
                const updateOne = await db.collection('card').updateOne(
                    {key:data.senduserkey},
                    {$set: {balance:taker.balance + data.amount}}
                )
                const updateTwo = await db.collection('card').updateOne(
                    {username:data.username},
                    {$set: {balance:sender.balance - (data.amount + isThenProcent)}}
                )
                const updateTree = await db.collection('bankwallet').updateOne(
                    {name:"Bank"},
                    {$set: {balance: bank.balance+isThenProcent}}
                )
                isSend = true
                const addTransaction = await db.collection("transaction").insertOne({sendername:sender.username,recipient:taker.username,amount:data.amount})
            }
            else{
                isSend = false
            }
        }
        res.json(isSend)
    } catch (error) {
        console.error(error)
    }
})

app.post('/api/users/get-balance',async (req,res) => {
    try {
        const username = req.body.username
        const result = await db.collection('card').findOne({username})
        res.json(result.balance)
    } catch (error) {
        console.error(error)
    }
})

app.post('/api/users/getCard',async (req,res) => {
    try {
        let userCard = {}
        const name = req.body.username
        const card = await db.collection("card").findOne({username:name})
        userCard = {
            _id:null,
            number:card.number,
            cvv:card.cvv,
            username:null,
            cardname:card.cardname,
            date:card.date,
            balance:card.balance,
            key:card.key
        }
        
        res.json(userCard)
    } catch (error) {
        console.error(error)
    }
})

app.post('/api/users/addCard',async (req,res) => {
    try {
        const newCard = {
            number:req.body.number,
            cvv:req.body.cvv,
            username:req.body.username,
            cardname:req.body.cardname,
            date:req.body.date,
            balance:req.body.balance,
            key:crypto.createHash('sha256').update(crypto.randomBytes(32)).digest('base64').substring(0,32),
            status:req.body.status
        }
        const result = await db.collection('card').insertOne(newCard)
        res.json(true)
    } catch (error) {
        console.log(error)
    }
})

app.post('/api/users/findUser',async (req,res) => {
    try {
        let isfind = false
        const newUser = {
            name:req.body.name,
            password:req.body.password
        }
        const collection = await db.collection(collectionName).findOne({name:newUser.name})
        if(collection != null && decrypt(collection.password,globalKey) == newUser.password){
            isfind = true
        }else{
            isfind = false
        }
        res.json(isfind)
    } catch (error) {
        console.error(error)
    }
})
app.post('/api/users',async (req,res) => {
    try {
        let idN
        const user = {
            name: req.body.name,
            password: req.body.name,
            number:req.body.number
        }
        const last = await db.collection(collectionName).find().sort({ _id: -1 }).limit(1).toArray()
        for(let param of last){
            idN = param.idN + 1
        }
        const result = await db.collection(collectionName).insertOne({name:user.name,password:encrypt(user.password,globalKey),number:user.number,idN:idN})
        res.json(true)
    } catch (error) {
        console.error(error)
    }
})

app.post("/api/users/getTransaction",async (req,res) =>{
    try {
        const username = req.body.username
        const userIsSender = await db.collection("transaction").find({sendername:username}).toArray()
        const userIsRecipient = await db.collection("transaction").find({recipient:username}).toArray() 
        let data = userIsRecipient.concat(userIsSender)
        res.json(data)
    } catch (error) {
        console.error(error)
        res.status(500).json({ error: "Internal Server Error" }); 
    }
})

app.listen(PORT,HOST,async () => {
    try{
        console.log(`Server Host http://${HOST}:${PORT}`)
    }
    catch(error){
        console.error(error)
    }
})