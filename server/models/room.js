const mongoose=require('mongoose');
const playerSchema=require('./player');

const roomSchema=new mongoose.Schema({
    occupancy: {
        type: Number,
        default: 2,
    },
    players:[playerSchema],
    isJoin:{
        type:Boolean,
        default:true,
    },
    turn:playerSchema,
    turnIndex:{
        type:Number,
        default:0,
    },
    lastActivity: { type: Date, default: Date.now },
});

const roomModel=mongoose.model('Room',roomSchema);
module.exports=roomModel;