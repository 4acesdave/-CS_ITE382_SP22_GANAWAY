//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Paul Solt on 9/28/17.
//  Copyright © 2017 Paul Solt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var tip1Label: UILabel!
    @IBOutlet weak var fifteenPercentTipLabel: UILabel!
    @IBOutlet weak var twentyPercentTipLabel: UILabel!
    @IBOutlet weak var billTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        billTextField.delegate = self
        
        print("Hello")
        print("Hi Paul! \(18)")
        
        // Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    deinit {
        // Stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // Actions
    @IBAction func calculateTipButtonPressed(_ sender: Any) {
        print("Calculate Tip")
        hideKeyboard()
        calculateAllTips()
    }
    
    // Methods or Functions
    func hideKeyboard() {
        billTextField.resignFirstResponder()
    }
    
    func calculateAllTips() {
        guard let subtotal = convertCurrencyToDouble(input: billTextField.text!) else {
            print("Not a number!: \(billTextField.text!)")
            return
        }
        print("The subtotal is: \(subtotal)")
        
        // Calculate the tips
        let tip1 = calculateTip(subtotal: subtotal, tipPercentage: 10.0)
        let tip2 = calculateTip(subtotal: subtotal, tipPercentage: 15.0)
        let tip3 = calculateTip(subtotal: subtotal, tipPercentage: 20.0)
        
        // Update the UI
        tip1Label.text = convertDoubleToCurrency(amount: tip1)
        fifteenPercentTipLabel.text = convertDoubleToCurrency(amount: tip2)
        twentyPercentTipLabel.text = convertDoubleToCurrency(amount: tip3)
    }
    
    func calculateTip(subtotal: Double, tipPercentage: Double) -> Double {
        return subtotal * (tipPercentage / 100.0)
    }
    
    
    func convertCurrencyToDouble(input: String) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.number(from: input)?.doubleValue
    }
    
    func convertDoubleToCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    
    @objc func keyboardWillChange(notification: Notification) {

        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    
    // UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return pressed")
        hideKeyboard()
        calculateAllTips()
        return true
    }
}

