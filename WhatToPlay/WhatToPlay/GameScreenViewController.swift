//
//  GameScreenViewController.swift
//  WhatToPlay
//
//  Created by Ai Chan Tran on 11/9/22.
//

import UIKit

class GameScreenViewController: UIViewController {
    
    @IBOutlet var dislikeButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet private var gameImageView: UIImageView!
    @IBOutlet private var gameTitleLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    
    let selectDefaults = UserDefaults()
    var platform: String?
    var genre: String?
    var playerCount: String?
    var platforms: [String:String] = [
        "PC": "1",
        "PlayStation": "2",
        "Xbox": "3",
        NSLocalizedString("Mobile", comment: "Phone"): "4,8",
        "Nintendo": "7"
    ]
    
    var delegate: getSavedGamesDelegate?
    var rawgResultsStore: GameStore!
    var games: [RawgGameInfo] = []
    var newSavedGames: [RawgGameInfo] = []
    var currentGameIndex: Int = 0
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSLocalizedString("\n**********\nGameScreenViewController loaded its view.\n", comment: "GSVC loader"))
        
        // Set default state and values of views
        self.setDefaultViewState()
        
        let baseParams = [
            NSLocalizedString("parent_platforms", comment: "plat"): self.platform == nil ? "" : platforms[self.platform!]!,
            NSLocalizedString("genres", comment: "genres"): self.genre == nil ? "" : self.genre!,
            NSLocalizedString("tags", comment: "tags"): self.playerCount == nil ? "" : self.playerCount!
        ]
        
        self.rawgResultsStore = GameStore()
        self.rawgResultsStore.getGameList(parameters: baseParams) {
            (gamesResult) in
            
            switch gamesResult {
            case let .success(gamesInfo):
                if gamesInfo.count == 0 {
                    print(NSLocalizedString("No results found.", comment: "None found."))
                    self.gameTitleLabel.text = NSLocalizedString("No results found.", comment: "None found.")
                } else {
                    print(NSLocalizedString("Successfully found \(gamesInfo.count) games.", comment: "Success"))
            
                    self.games = gamesInfo
                    
                    if let firstGame = gamesInfo.first {
                        self.updateDisplayedGame(for: firstGame)
                    }
                }
            case let .failure(error):
                print(NSLocalizedString("Error fetching games list: \(error)", comment: "Error fetch"))
            }
        }
    }
    
    @IBAction func dislikeButtonClicked(_sender: UIButton) {
        print(NSLocalizedString("Dislike button clicked. Ignored \(self.games[currentGameIndex].name)", comment: "Dislike button clicked"))
        self.showNextGame()
    }
    
    @IBAction func saveButtonClicked(_sender: UIButton) {
        let newGame = self.games[currentGameIndex]

        self.newSavedGames.append(newGame)
        print(NSLocalizedString("Save button clicked. Added \(newGame.name) to the list", comment: "Save button clicked."))
        
        self.showNextGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.getSavedGames(newSavedGames)
    }
    
    func setDefaultViewState() {
        self.gameTitleLabel.text = NSLocalizedString("Loading...", comment: "Loading")
        self.ratingLabel.isHidden = true
    }
    
    func updateDisplayedGame(for game: RawgGameInfo) {
        self.gameTitleLabel.text = game.name
        let rating: NSNumber! = NSNumber(value: game.rating)
        let maxRating: NSNumber! = 5.00
        self.ratingLabel.text = "\(self.numberFormatter.string(from: rating) ?? "") / \(self.numberFormatter.string(from: maxRating) ?? "")"
        self.ratingLabel.isHidden = false
        self.updateImageView(for: game)
    }
    
    func updateImageView(for game: RawgGameInfo) {
        self.rawgResultsStore.fetchImage(for: game) {
            (imageResult) in
            
            switch imageResult {
            case let .success(image):
                self.gameImageView.image = image
            case let .failure(error):
                print(NSLocalizedString("Error downloading image: \(error)", comment: "Error download image"))
            }
        }
    }
    
    func showNextGame() {
        self.currentGameIndex += 1
        if self.currentGameIndex == self.games.count {
            self.currentGameIndex = 0
        }
        
        self.updateDisplayedGame(for: self.games[currentGameIndex])
    }
}
