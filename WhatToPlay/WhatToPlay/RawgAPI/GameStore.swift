//
//  PhotoStore.swift
//  WhatToPlay
//
//  Created by Kris Calma on 12/3/22.
//

import UIKit

enum ImageError: Error {
    case imageCreationError
    case missingImageURL
}

class GameStore {
    
//    var allGames = [RawgGameInfo]()
    
//    let gameArchiveURL: URL = {
//        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentDirectory = documentsDirectories.first!
//        return documentDirectory.appendingPathComponent("savedGames.plist")
//    }()
    
    let imageStore = ImageStore()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func getGameList(
        parameters: [String:String]?,
        completion: @escaping (Result<[RawgGameInfo], Error>) -> Void
    ) {
        let url = RawgAPI.listGamesURL(parameters: parameters)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processGameListRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processGameListRequest(
        data: Data?,
        error: Error?
    ) -> Result<[RawgGameInfo], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return RawgAPI.results(fromJSON: jsonData)
    }
    
    func fetchImage(
        for game: RawgGameInfo,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        
        let gameKey = String(game.gameID)
        
        // Load image from cache if existing
        if let image = imageStore.image(forKey: gameKey) {
            OperationQueue.main.addOperation {
                completion( .success(image))
            }
            return
        }
        
        guard let imageURL = game.imageURL else {
            completion(.failure(ImageError.missingImageURL))
            return
        }
        
        let request = URLRequest(url: imageURL)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: gameKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processImageRequest(
        data: Data?,
        error: Error?
    ) -> Result<UIImage, Error> {
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
            
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(ImageError.imageCreationError)
            }
        }
        
        return .success(image)
    }
    
//    @discardableResult func saveGame(game: RawgGameInfo) -> RawgGameInfo {
//        let newGame = game
//
//        // Only add new save game if it doesn't already exist
//        if (!allGames.contains(game)) {
//            allGames.append(newGame)
//        }
//
//        return newGame
//    }
//
//    @discardableResult func appendSaveGames(games: GameStore) -> GameStore {
//        let newStore = games
//
//        newStore.allGames.forEach { g in
//            self.saveGame(game: g)
//        }
//
//        return newStore
//    }
//
//    func removeSaveGame(_ game: RawgGameInfo) {
//        if let index = allGames.firstIndex(of: game) {
//            allGames.remove(at: index)
//        }
//    }
    
//    @objc @discardableResult func saveChanges() -> Bool {
//        print("\nSaving items to: \(gameArchiveURL)")
//
//        do {
//            let encoder = PropertyListEncoder()
//            let data = try encoder.encode(allGames)
//            try data.write(to: gameArchiveURL, options: [.atomic])
//            print("Saved all of the games in the list\n")
//            return true
//        } catch let encodingError {
//            print("Error encoding allGames: \(encodingError)\n")
//            return false
//        }
//    }
//
//    init() {
//        do {
//            let data = try Data(contentsOf: gameArchiveURL)
//            let unarchiver = PropertyListDecoder()
//            let games = try unarchiver.decode([GameInfo].self, from: data)
//            allGames = games
//        } catch {
//            print("Error readinug in saved games: \(error)")
//        }
//
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(
//            self,
//            selector: #selector(saveChanges),
//            name: UIScene.didEnterBackgroundNotification,
//            object: nil
//        )
//    }
}
