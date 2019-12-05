//
//  CardModule.swift
//  MatchGame
//
//  Created by Kim Yeon Jeong on 2019/12/3.
//  Copyright © 2019 Kim Yeon Jeong. All rights reserved.
//

import Foundation
class CardModule{
    func getCard() -> [Card] {
        
        //decare an array to store numbers we`ve already generated
        var generatedNumbersArray = [Int]()
        //randomly generate pairs of cards
      
        var generatedCardArray = [Card]()
        
        while generatedNumbersArray.count < 8 {
            //get a random number
          
            let randomNumber = arc4random_uniform(13) + 1
            //Ensure that the random number isn`t one we already have
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
             
                //log the number
                print(randomNumber)
                
                //Store the number into the generatedCardArray
                generatedNumbersArray.append(Int(randomNumber))

                
                //create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                generatedCardArray.append(cardOne)
                
                 //create the second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardArray.append(cardTwo)
                
                // make it so we only have unqiu pairs of cards
            } else {
                
            }
            
        }
        //Randomize the array
        
        for i in 0...generatedCardArray.count-1{
            // find a random index to swap with
            let randomNumber = Int (arc4random_uniform(UInt32(generatedCardArray.count)))
            
            // swap the two cards
            let temporaryStorage = generatedCardArray[i]
            generatedCardArray[i] = generatedCardArray[randomNumber]
            generatedCardArray[randomNumber] = temporaryStorage
        }
        
        //return
        return generatedCardArray
        
    }
}
