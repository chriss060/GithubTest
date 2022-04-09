//
//  ViewController.swift
//  QuotesGenerator
//
//  Created by Chrissy Lee on 2022/04/09.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    let quotes = [
        Quote(contents: "Be yourself; everyone else is already taken.", name: "Oscar Wilde"),
        Quote(contents: "Two things are infinite: the universe and human stupidity and I'm not sure about the universe." , name:"Albert Einstein"),
        Quote(contents: "A room without books is like a body without a soul.", name: "Marcus Tullius Cicero"),
        Quote(contents: "So many books, so little time.", name : "Frank Zappa"),
        Quote(contents: "In three words I can sum up everything I've learned about life: it goes on.", name: "Robert Frost")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapQuoteGeneratorButton(_ sender: UIButton) {
        let random = Int(arc4random_uniform(5)) // 0 ~ 4 사이의 난수 생성
        let quote = quotes[random]
        self.quoteLabel.text = quote.contents
        self.nameLabel.text = quote.name
    }
    
}

