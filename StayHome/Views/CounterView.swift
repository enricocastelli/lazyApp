//
//  CounterLabel.swift
//  StayHome
//
//  Created by Enrico Castelli on 22/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import Foundation
import UIKit

class CounterView : UIView {
    
    private var stack = UIStackView()
    private var labels : [CounterLabel] = []
    private var previousNumberArray = [String]()
    private var futureNumberArray = [String]()
    
    private var number: Double?
    private var text: String?
    private var finalText: String?
    private var animationCompletion: ()->()
    private var animationCounter = 0

    
    init(_ number: Double, _ animationCompletion: @escaping() ->()) {
        self.number = number
        self.animationCompletion = animationCompletion
        super.init(frame: .zero)
        initStackView()
        createLabels(string: createEmptyString())
        let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
            self.updateLabels()
        }
    }
    
    init(_ text: String, _ finalText: String, _ animationCompletion: @escaping() ->()) {
        self.text = text
        self.finalText = finalText
        self.animationCompletion = animationCompletion
        super.init(frame: .zero)
        initStackView()
        createLabels(string: text)
        let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
            self.updateLabels()
        }
    }
    
    func update(_ number: Double, _ animationCompletion: @escaping() ->()) {
        self.animationCompletion = animationCompletion
        self.number = number
        updateLabels()
    }
    
    ///initialize stackView containing labels
    private func initStackView() {
        addSubview(stack)
        translatesAutoresizingMaskIntoConstraints = false
        number == nil ? addConstraint() : addContentView(stack)
        stack.alignment = number == nil ? .top : .center
        stack.axis = .horizontal
        stack.distribution = number == nil ? .fillEqually : .fillEqually
        stack.spacing = number == nil ? 2 : 0
    }
    
    /// update all the labels with a specific number, isCurrency or percentage
    func updateLabels() {
        previousNumberArray = futureNumberArray
        let string = number == nil ? finalText! : number!.toCounterString
        // populating the futureNumberArray
        let arrayChar = string.map { (Character) -> Character in
            return Character
        }
        futureNumberArray = []
        for car in arrayChar {
            futureNumberArray.append(String(car))
        }
        animate()
    }

    private func createEmptyString() -> String {
        var string = ""
        for _ in 1...2 {
            string.append("0")
        }
        return string + ",0"
    }
    
    /// create labels for every number and populate the labels arrays
    private func createLabels(string : String) {
        let arrayChar = string.map { (Character) -> Character in
            return Character
        }
        let shouldPopulatePreviousArray = !previousNumberArray.isEmpty
        for car in arrayChar {
            // create a label and add it to the stack, until the labels count is the same as the string count
            if labels.count != arrayChar.count {
                let label = createSingleLabel(car: car)
                labels.append(label)
                stack.addArrangedSubview(label)
            }
            if shouldPopulatePreviousArray {
                previousNumberArray.append(String(car))
            } else  {
                futureNumberArray.append(String(car))
            }
        }
        layoutIfNeeded()
    }
    
    /// create and return a single counter label with a specific character as text
    private func createSingleLabel(car: Character) -> CounterLabel {
        let label = CounterLabel(String(car))
        label.delegate = self
        return label
    }
    
    /// start the animations, triggering every label's animation
    public func animate() {
        for label in labels {
            guard let index = labels.firstIndex(of: label) else { return }
            let string = futureNumberArray[index]
            if number == nil {
                label.animateString(string)
            } else {
                label.animateNumber(string)
            }
        }
    }
    
    private func addConstraint() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.init(item: stack,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: stack,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: stack,
                                attribute: .leadingMargin,
                                relatedBy: .greaterThanOrEqual,
                                toItem: self,
                                attribute: .leadingMargin,
                                multiplier: 1,
                                constant: 0).isActive = true
        NSLayoutConstraint.init(item: stack,
                                attribute: .trailingMargin,
                                relatedBy: .lessThanOrEqual,
                                toItem: self,
                                attribute: .trailingMargin,
                                multiplier: 1,
                                constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.number = 0
        self.animationCompletion = {()}
        super.init(coder: aDecoder)
        initStackView()
    }
    
}

extension CounterView: CounterLabelDelegate {
    
    func didFinishAnimation() {
        animationCounter += 1
        let counterStops = number == nil ? text!.count : String(Int(number!)).count
        if animationCounter == counterStops {
            animationCompletion()
            animationCounter = 0
        }
    }
}
