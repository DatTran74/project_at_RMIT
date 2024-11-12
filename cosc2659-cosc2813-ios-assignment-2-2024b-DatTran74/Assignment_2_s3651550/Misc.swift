/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Tran Xuan Hoang Dat
  ID: s3651550
  Created  date: 25/07/2024
  Last modified: dd/mm/yyyy (e.g. 05/08/2023)
  Acknowledgement: Acknowledge the resources that you use here.
*/

import Foundation

let everydayObjects = [
"Pillow", "Lamp", "USB Drive", "Bracelet", "Battery", "Shampoo", "Slippers",
"Shirt", "Toothbrush", "Wallet", "Door", "Bottle", "Lighter", "Dress",
"Fan", "Pen", "Backpack", "Printer", "Jeans", "Radio", "Flashlight", "Boots",
"Fork", "Necklace", "Plate", "Brush", "Mirror", "Suitcase", "Watch",
"Headphones", "Scanner", "Sweater", "Gloves", "Lightbulb", "Tablet",
"Wallet", "Ruler", "Computer", "Comb", "Eraser", "Bicycle", "Hat",
"Train", "Bus", "Camera", "Tie", "Chair", "Remote", "Car", "Sandals",
"Jacket", "Sofa", "Scissors", "Map", "Pencil", "Charger", "Adapter",
"Earrings", "Purse", "Bed", "Umbrella", "Toothpaste", "Candle", "Curtain",
"Keyboard", "Socks", "Knife", "Magazine", "Mouse", "Blouse", "Ticket",
"Scarf", "Wallet", "Television", "Cable", "Passport", "Spoon", "Shorts",
"Plane", "Notebook", "ID Card", "Towel", "Raincoat", "Speaker", "Soap",
"Window", "Skirt", "Book", "Pants", "Phone", "Bag", "Table", "Glass",
"Blanket", "Ring", "Key", "Laptop", "Boat", "Projector", "Clock"
]

enum PlayerAuthState: String{
    case authenticating = "Logging in the Game Center ... "
    case unauthenticated = "Please sign in to Game Center to play."
    case authenticated=" "
    
    case error = "There was an error logging into the Game Center"
    case restricted = "You're not allow to play multiplayer games!"
}
struct PassGuess: Identifiable {
    let id = UUID()
    var message:String
    var correct: Bool
}
let maxTimeRemaining = 100 
