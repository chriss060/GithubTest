//
//  RoundButton.swift
//  Calculator
//
//  Created by Chrissy Lee on 2022/04/18.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var isRound: Bool = false{
        didSet{
            if isRound{
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }
}
