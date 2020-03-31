//
//  Label.swift
//  StayHome
//
//  Created by Enrico Castelli on 22/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import Foundation
import UIKit

protocol CounterLabelDelegate {
    func didFinishAnimation()
}

class CounterLabel: UILabel {
    
    private var count = -1
    private var animationDuration = 0.2
    private var previousNumber : Int = 0
    private var futureNumber : Int = 0
    private var previousLetter = "z"
    private var futureLetter = "a"
    var delegate: CounterLabelDelegate?
    
    let alphabet: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", " "]
    
    init(_ text: String) {
        super.init(frame: .zero)
        self.text = text
        font = Font.with(.light, 32)
        textAlignment = .center
        textColor = UIColor.black
    }
    
    func animateNumber(_ string: String) {
        guard let future = Int(string), let previous = Int(text ?? "") else { return }
        self.futureNumber = future
        self.previousNumber = previous
        let _ = Timer.scheduledTimer(withTimeInterval: getRandom(), repeats: false) { (_) in
            let _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerCallback(_ :)), userInfo: nil, repeats: true)
        }
    }
    
    func animateString(_ string: String) {
        self.previousLetter = randomLetter()
        self.futureLetter = string
        self.previousNumber = alphabet.firstIndex(of: previousLetter)!
        self.futureNumber = alphabet.firstIndex(of: futureLetter)!
        let _ = Timer.scheduledTimer(withTimeInterval: getRandom(), repeats: false) { (_) in
            let _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerCallbackString(_ :)), userInfo: nil, repeats: true)
        }
    }
    
    
    /// the actual animation method repeated. When the correct number is reached, it invalidates the timer.
    @objc private func timerCallback(_ sender: Timer) {
        // checks for the count
        guard count != futureNumber else {
            sender.invalidate()
            return
        }
        if count == -1 { count = previousNumber }
        let countdown = (futureNumber - previousNumber) <= 0
        if countdown { count -= 1 } else { count += 1 }
        if count == 10 { count = 0 } else if count == -1 { count = 9 }
        let anim = CATransition()
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        anim.type = CATransitionType.push
        anim.subtype = CATransitionSubtype.fromTop
        anim.duration = animationDuration
        layer.add(anim, forKey: "change")
        if count != futureNumber {
            text = String(count)
        } else {
            // no more need for the timer now
            text = String(futureNumber)
            sender.invalidate()
            delegate?.didFinishAnimation()
        }
    }
    
    /// the actual animation method repeated. When the correct number is reached, it invalidates the timer.
    @objc private func timerCallbackString(_ sender: Timer) {
        // checks for the count
        guard count != futureNumber else {
            sender.invalidate()
            return
        }
        if count == -1 { count = previousNumber}
        let countdown = (futureNumber - previousNumber) <= 0
        if countdown { count -= 1 } else { count += 1 }
        if count == alphabet.count { count = 0 } else if count == -1 { count = alphabet.count - 1 }
        let anim = CATransition()
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        anim.type = CATransitionType.push
        anim.subtype = CATransitionSubtype.fromTop
        anim.duration = animationDuration
        layer.add(anim, forKey: "change")
        if count != futureNumber {
            text = alphabet[count]
        } else {
            // no more need for the timer now
            text = futureLetter
            sender.invalidate()
            delegate?.didFinishAnimation()
        }
    }
    
    private func getRandom() -> Double {
        return Double(arc4random_uniform(30))/100
    }

    private func randomLetter() -> String {
        return(alphabet.randomElement()!)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
