//
//  SavedGameStore.swift
//  WhatToPlay
//
//  Created by Kris Calma on 12/7/22.
//

import CoreData
import Foundation

class SavedGameStore {
    
    var context: NSManagedObjectContext!
    var savedGames: [SavedGame] = []
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WTP")
        
        container.loadPersistentStores {
            (description, error) in
            
            if let error = error {
                print("SavedGameStore caught error loading persistent data store \(error)")
            } else {
                print("SavedGameStore successfully loaded persistent data store")
            }
        }
        return container
    }()
    
    init(completion: @escaping(Result<[SavedGame], Error>) -> Void) {
        self.context = self.persistentContainer.viewContext
        self.loadAllSavedGames(completion: completion)
    }
    
    func makeSaveGame() -> SavedGame {
        return SavedGame(context: self.context)
    }
    
    func fetchAllSavedGames(
        completion: @escaping(Result<[SavedGame], Error>) -> Void
    ) {
        let fetchRequest: NSFetchRequest<SavedGame> = SavedGame.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(SavedGame.name), ascending: true)
        ]
        
        self.context.perform {
            do {
                let allSavedGames = try self.context.fetch(fetchRequest)
                completion(.success(allSavedGames))
            } catch {
                print("SavedGameStore::fetchAllSavedGames caught an exception: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    private func loadAllSavedGames(
        completion: @escaping(Result<[SavedGame], Error>) -> Void
    ) {
        self.fetchAllSavedGames {
            (fetchResult) in
            
            switch fetchResult {
            case let .success(fetchedSavedGames):
                self.savedGames = fetchedSavedGames
                print("SavedGameStore::loadAllSavedGames got \(self.savedGames.count) saved games from DB")
                completion(.success(fetchedSavedGames))
            case let .failure(error):
                print("SavedGameStore::loadAllSavedGames failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func saveGame(
        game: SavedGame,
        completion: @escaping(Result<[SavedGame], Error>) -> Void
    ) {
        self.context.perform {
            do {
                try self.context.save()
                self.loadAllSavedGames {
                    (loadResult) in
                    switch loadResult {
                    case let .success(games):
                        
                        completion(.success(games))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            } catch {
                print("SavedGameStore::saveGame caught an exception: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    private func removeSavedGame(_ game: SavedGame) {
        if let index = savedGames.firstIndex(of: game) {
            savedGames.remove(at: index)
        }
    }
    
    func deleteSavedGame(
        game: SavedGame,
        completion: @escaping(Result<[SavedGame], Error>) -> Void
    ) {        
        self.context.perform {
            do {
                self.context.delete(game)
                try self.context.save()
                print("SavedGameStore::deleteSavedGame delete: \(game)")
                self.loadAllSavedGames {
                    (loadResult) in
                    
                    switch loadResult {
                    case let .success(games):
                        self.removeSavedGame(game)
                        completion(.success(games))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            } catch {
                print("SavedGameStore::deleteSavedGame caught an exception: \(error)")
                completion(.failure(error))
            }
        }
    }
}
