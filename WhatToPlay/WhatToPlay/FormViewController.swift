//
//  FormViewController.swift
//  WhatToPlay
//
//  Created by Ai Chan Tran on 11/8/22.
//

import UIKit
import DropDown
import Foundation

protocol getSavedGamesDelegate {
    func getSavedGames(_ gameStore: [RawgGameInfo])
}

extension UserDefaults {
    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
}

class FormViewController: UIViewController, getSavedGamesDelegate {
    
    @IBOutlet weak var platformButton: UIButton!
    @IBOutlet weak var platformView: UIView!
    @IBOutlet weak var platformLabel: UILabel!
    
    @IBOutlet weak var genreButton: UIButton!
    @IBOutlet weak var genreView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var playercountButton: UIButton!
    @IBOutlet weak var playercountView: UIView!
    @IBOutlet weak var playercountLabel: UILabel!
    
    @IBOutlet var searchButton: UIButton!
    
    let selectDefaults = UserDefaults()
    
    let platformDropDown = DropDown()
    let platformArray = ["PC", "PlayStation", "Xbox", "Nintendo", NSLocalizedString("Mobile", comment: "Phone")]
    let genreDropDown = DropDown()
    let genreArray = [NSLocalizedString("action", comment: "action"), NSLocalizedString("platformer", comment: "platformer"), NSLocalizedString("simulation", comment: "simulation"), NSLocalizedString("shooter", comment: "shooter"), NSLocalizedString("role-playing-games-rpg", comment: "RPG"), NSLocalizedString("indie", comment: "indie"), NSLocalizedString("massively-multiplayer", comment: "MMO")]
    let playercountDropDown = DropDown()
    let playercountArray = [NSLocalizedString("singleplayer", comment: "singleplayer"), NSLocalizedString("multiplayer", comment: "multiplayer"), NSLocalizedString("online-co-op", comment: "online co-op"), NSLocalizedString("local-co-op", comment: "local co-op")]
    
    let strokeTextAttributes = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.strokeWidth: -4.0,
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        as [NSAttributedString.Key: Any]
    
    var platform: String?
    var genre: String?
    var playerCount: String?
    var savedGameStore: SavedGameStore!
    var gamesToDelete: [SavedGame] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSLocalizedString("\n**********\nFormViewController loaded its view.\n", comment: "FVC Loaded"))
        
        let tabBar = tabBarController as! WTPTabBarController
        
        self.savedGameStore = SavedGameStore {
            (result) in
            
            self.savedGameStore.fetchAllSavedGames {
                (loadResult) in
                
                tabBar.savedGames = self.savedGameStore.savedGames
            }
        }
        
        self.platformLabel.attributedText = NSMutableAttributedString(string: NSLocalizedString("Select...", comment: "Select"),  attributes: strokeTextAttributes)
        self.genreLabel.attributedText = NSMutableAttributedString(string: NSLocalizedString("Select...", comment: "Select"),  attributes: strokeTextAttributes)
        self.playercountLabel.attributedText = NSMutableAttributedString(string: NSLocalizedString("Select...", comment: "Select"),  attributes: strokeTextAttributes)
        
        if self.selectDefaults.valueExists(forKey: "platform"){
            self.platformLabel.text = selectDefaults.value(forKey: "platform") as? String ?? ""
            selectDefaults.removeObject(forKey: "platform")
        }
        if self.selectDefaults.valueExists(forKey: "genre"){
            self.genreLabel.text = selectDefaults.value(forKey: "genre") as? String ?? ""
            selectDefaults.removeObject(forKey: "genre")
        }
        if self.selectDefaults.valueExists(forKey: "players"){
            self.playercountLabel.text = selectDefaults.value(forKey: "players") as? String ?? ""
            selectDefaults.removeObject(forKey: "players")
        }
        
        platformDropDown.anchorView = platformView
        platformDropDown.dataSource = platformArray
        platformDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print(NSLocalizedString("Selected item: \(item)", comment: "Selected item"))
            self.platformLabel.text = platformArray[index]
            self.platform = item
        }
        
        genreDropDown.anchorView = genreView
        genreDropDown.dataSource = genreArray
        genreDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print(NSLocalizedString("Selected item: \(item)", comment: "Selected item"))
            self.genreLabel.text = genreArray[index]
            self.genre = item
        }
        
        playercountDropDown.anchorView = playercountView
        playercountDropDown.dataSource = playercountArray
        playercountDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print(NSLocalizedString("Selected item: \(item)", comment: "Selected item"))
            self.playercountLabel.text = playercountArray[index]
            self.playerCount = item
        }
    }
    
    @IBAction func showPlatformOptions(_sender: UIButton) {
        platformDropDown.show()
    }
    
    @IBAction func showGenreOptions(_sender: UIButton) {
        genreDropDown.show()
    }
    
    @IBAction func showPlayerCountOptions(_sender: UIButton) {
        playercountDropDown.show()
    }
    
    func getSavedGames(_ gameStore: [RawgGameInfo]) {
        let tabBar = tabBarController as! WTPTabBarController
        
        gameStore.forEach { g in
            if self.savedGameStore.savedGames.first(where: { $0.gameID == g.gameID }) != nil {
                print(NSLocalizedString("Duplicate: Not adding \(g.name) in DB because it already exists.", comment: "Not adding"))
            } else {
                let newStore = self.savedGameStore.makeSaveGame()
                
                newStore.gameID = g.gameID
                newStore.name = g.name
                newStore.rating = g.rating
                newStore.imageURL = g.imageURL
                
                if (self.viewsToSavedGame(game: newStore, rawgInfo: g)) {
                    self.savedGameStore.saveGame(game: newStore) {
                        (saveResult) in
                        tabBar.savedGames = self.savedGameStore.savedGames
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tabBar = tabBarController as! WTPTabBarController
        gamesToDelete = tabBar.gamesToDelete
        
        gamesToDelete.forEach { game in
            self.savedGameStore.deleteSavedGame(game: game) {
                (deleteResult) in
            }
        }
        
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let tabBar = tabBarController as! WTPTabBarController
        tabBar.savedGames = self.savedGameStore.savedGames
    }
    
    private func viewsToSavedGame(game: SavedGame, rawgInfo: RawgGameInfo) -> Bool {
        let displayedGame = rawgInfo
        
        if displayedGame != nil {
            game.gameID = displayedGame.gameID
            game.name = displayedGame.name
            game.rating = displayedGame.rating
            game.imageURL = displayedGame.imageURL
            
            return true
        } else {
            print(NSLocalizedString("Unable to save the current game.", comment: "Unable to save current game"))
        }
        
        return false
    }
    
    @IBAction func searchButtonClicked(_sender: UIButton) {

        print(NSLocalizedString("Search button clicked.\n**********\n", comment: "Search button clicked"))
        selectDefaults.set(self.platformLabel.text, forKey: "platform")
        selectDefaults.set(self.genreLabel.text, forKey: "genre")
        selectDefaults.set(self.playercountLabel.text, forKey: "players")

        self.performSegue(withIdentifier: "GameScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "GameScreen":
            let gameScreenViewController = segue.destination as! GameScreenViewController
            gameScreenViewController.platform = self.platform
            gameScreenViewController.genre = self.genre
            gameScreenViewController.playerCount = self.playerCount
            gameScreenViewController.delegate = self
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}
