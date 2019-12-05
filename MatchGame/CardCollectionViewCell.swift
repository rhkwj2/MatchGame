//
//  CardViewController.swift
//  MatchGame
//
//  Created by Kim Yeon Jeong on 2019/12/3.
//  Copyright © 2019 Kim Yeon Jeong. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    
    var card:Card?
    
    func setCard(_ card:Card){
        
        //keep track if the card that get passed in
        self.card = card
        
        if card.isMatched == true{
            
            //If the card is matched, then make the image views invisible
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return

        }
        else {
            
             //If the card is has not matched, then make the image views invisible
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        
        frontImageView.image = UIImage(named: card.imageName)
        
        //Determine if the card is in fliped up state or fipped down state
        if card.isFliped == true {
            //make sure the fount image view is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
            
        } else{
            // Make sure the backimage view is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
        
        }
    }
    
    func flip(){
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack(){
        
        DispatchQueue.main.asyncAfter(deadline:  DispatchTime.now() + 0.5) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options:[.transitionFlipFromRight,.showHideTransitionViews ], completion: nil)
            
            
        }
        
    }
    
    func remove() {
        //Remove both imagevies from veing invisable
        backImageView.alpha = 0
        
        // Todo : Animated it
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
        
    }
    
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


