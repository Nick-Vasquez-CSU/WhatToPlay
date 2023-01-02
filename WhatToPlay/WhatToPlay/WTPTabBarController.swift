//
//  WTPTabBarController.swift
//  WhatToPlay
//
//  Created by Kris Calma on 12/7/22.
//

import UIKit

class WTPTabBarController: UITabBarController {
    
    var savedGames: [SavedGame] = []
    var gamesToDelete: [SavedGame] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSLocalizedString("TabBarController loaded its view.", comment: "TabController Loaded"))
        
        self.navigationItem.hidesBackButton = true
    }

}
