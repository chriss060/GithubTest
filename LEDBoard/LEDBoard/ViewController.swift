//
//  ViewController.swift
//  LEDBoard
//
//  Created by Gunter on 2021/08/17.
//

import UIKit

class ViewController: UIViewController, LEDBoardSettingDelegate {

  @IBOutlet weak var contentsLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.contentsLabel.textColor = .yellow
  }

    //segueway로 화면 전환 - prepare 함수
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let settingViewController = segue.destination as? SettingViewController {
      settingViewController.delegate = self
      settingViewController.ledText = self.contentsLabel.text
      settingViewController.textColor = self.contentsLabel.textColor
      settingViewController.backgroudColor = self.view.backgroundColor ?? .black //옵셔너이면 black으로 초기화
    }
  }

    // LEDBoardSettingDelegate 프로토콜 준수
  func changedSetting(text: String?, textColor: UIColor, backgroudColor: UIColor) {
    if let text = text { //text parameter 옵셔널 바인딩 
      self.contentsLabel.text = text
    }
    self.contentsLabel.textColor = textColor
    self.view.backgroundColor = backgroudColor
  }
}


