const { MongoClient } = require('mongodb')
const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')
const crypto = require('crypto')
const { encrypt,decrypt } = require('./back')

const PORT = 5001
const HOST = "192.168.10.12"
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

app.post('/api/users/findName', async (req,res) => {
    try {
        let isFind = false
        const name = req.body.name
        const result = await db.collection(collectionName).find().toArray()
        for(let user of result){
            if(name == user.name){
                console.log(true)
                isFind = true
                break;
            }
        }
        res.json(isFind)
    } catch (error) {
        
    }
})

app.post('/api/users/addCard',async (req,res) => {
    try {
        const newCard = {
            number:req.body.number,
            cvv:req.body.cvv,
            username:req.body.username,
            cardname:req.body.cardname,
            date:req.body.date
        }
        const result = await db.collection('card').insertOne(newCard)
        console.log(result)
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
        const result = await db.collection(collectionName).find().toArray()
        for (let user of result) {
            if(newUser.name == user.name){
                if(newUser.password == decrypt(user.password,globalKey)){
                    isfind = true
                    break
                }
                isfind = false
            }
            isfind = false
        }
        console.log(isfind)
        res.json(isfind)
    } catch (error) {
        console.error(error)
    }
})
app.post('/api/users',async (req,res) => {
    try {
        const user = {
            name: req.body.name,
            password: req.body.name,
            number:req.body.number
        }
        const result = await db.collection(collectionName).insertOne({name:user.name,password:encrypt(user.password,globalKey),number:user.number})
        res.json(true)
    } catch (error) {
        console.error(error)
    }
})
app.post('/bank/api/create-user',async (req,res) => {
    try {
        const name = req.body.name
        const password = req.body.password
    } catch (error) {
        console.error(error)
    }
}) 

app.listen(PORT,HOST,() => {
    console.log(`Server Host http://${HOST}:${PORT}`)
})