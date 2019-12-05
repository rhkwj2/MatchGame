//
//  ViewController.swift
//  MatchGame
//
//  Created by Kim Yeon Jeong on 2019/12/3.
//  Copyright © 2019 Kim Yeon Jeong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModule()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex : IndexPath?
    
    var timer : Timer?
    var milliseconds: Float = 30 * 1000 // 30 sec
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call the getcard method
        cardArray = model.getCard()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManger.playSound(.shuffle)
    }
    
    //Mark : Timer Mathods
    @objc func timerElapsed(){
        
        milliseconds -= 1
        
        //Conver to seconds
       let seconds = String(format:"%.2f", milliseconds/1000)
      
        //set Label
        timerLabel.text = "time Remaining: \(seconds)"
        
        //When the timer has reached 0 will stop it
        if milliseconds <= 0 {
            
            //Stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //Check if theere are any cards unmatched
            ckeckGameEnded()
        }
        
        
    }
    
    //Mark : UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        // get a cardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //Get the card that the colletion view is trying to display
        let card = cardArray[indexPath.row]
        
        
        //set that card for the cell
        cell.setCard(card)
        
                return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //check if there`s any time left
        if milliseconds <= 0 {
            return
        }
        
       let cell =  collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFliped == false && card.isMatched == false {
            //flip the card
            cell.flip()
            
            //Play the filp sound
            SoundManger.playSound(.flip)
            
            //set the status of the card
            card.isFliped = true
            
            //determine if it`s first card or second card that`s flipped over
            if firstFlippedCardIndex == nil {
                //fisr card being flipped
                firstFlippedCardIndex = indexPath
            } else {
                
                // this is the secand card being flipped
                
                
                // perform the matching logic
                checkForMatches(indexPath)
                
                
            }
        }
        
        
    } //Engding of didSelectItem method.
    
    //mark : game logic methods
    func checkForMatches(_ secondFlippedCardIndex: IndexPath){
        //get the cell for the two cards that were reaveled
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //get the cards for the two cards that were reaveled
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //compare the two cards
       if cardOne.imageName == cardTwo.imageName {
           //it`s a match
        
        //play Sound
        SoundManger.playSound(.match)
        
        
            //set the statues of cards
        cardOne.isMatched = true
        cardTwo.isMatched = true
        
            //Remove the matching card
        cardOneCell?.remove()
        cardTwoCell?.remove()
        
        // Check if there are cards left unmathced
        ckeckGameEnded()
        
        }
        else {
              //it`s not a match
            
        //play sound
        SoundManger.playSound(.nomatch)
        
            //set the statues of the cards
        cardOne.isFliped = false
        cardTwo.isFliped = false
            
            //filp both cards back
        cardOneCell?.flipBack()
        cardTwoCell?.flipBack()
            
        }
        //tell the collectionview to reload the cell for the first card if it was nil
        
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        //reset the property that tracks the first card flipped 
        firstFlippedCardIndex = nil
    }
    func ckeckGameEnded() {
        
        //Determine if there are any cards unmatched
        var isWon = true
        
        for card in cardArray {
            
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        //Messing variables
        var title = ""
        var message = ""
        
        
        //If not, then user has won, stop the timer
        if isWon == true {
            
            if milliseconds > 0{
                timer?.invalidate()
            }
            title = "Congrarulations!"
            message  = "You`ve Won"
            
        } else {
           //If there are unmatched cards, check if there`s any time left
            
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You`ve Lost"
        }
         //Show won/lost messaging
        showAlert(title, message)
        

    }
    func showAlert(_ title : String, _ message : String){
        //Show won/lost messaging
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)

        
    }
    
} // Endging of veiwController class

