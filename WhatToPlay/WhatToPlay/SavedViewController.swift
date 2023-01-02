//
//  SavedViewController.swift
//  WhatToPlay
//
//  Created by Ai Chan Tran on 11/8/22.
//

import UIKit
import Foundation

class SavedViewController: UITableViewController{
    
    var savedGames: [SavedGame] = []
    var gamesToDelete: [SavedGame] = []
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        if isEditing {
            sender.setTitle(NSLocalizedString("Edit", comment: "Edit"), for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle(NSLocalizedString("Done", comment: "Done"), for: .normal)
            setEditing(true, animated: true)
        }
    }
    
    @IBAction func saveTableToFile(_ sender: UIButton) {
        let fileName = "SavedGames"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        print("File Path: \(fileURL.path)")
        
        var curstring = ""
        for curgame in savedGames{
            print("Curgame: \(curgame)")
            curstring += curgame.name!
            curstring += " | "
        }
        do{
            try curstring.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }catch let error as NSError{
                print("Failed to write to URL")
                print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabBar = tabBarController as! WTPTabBarController
        
        savedGames = tabBar.savedGames
        gamesToDelete = []
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let tabBar = tabBarController as! WTPTabBarController
        tabBar.gamesToDelete = gamesToDelete
        
        print(NSLocalizedString("GamesTODelete - SavedView: \(gamesToDelete.count)", comment: "GamesToDelete"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tabBar = tabBarController as! WTPTabBarController
        savedGames = tabBar.savedGames
        
        self.tableView.reloadData()
        
        print(NSLocalizedString("SavedGames count: \(savedGames.count)", comment: "SaveGames"))
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return savedGames.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        let game = savedGames[indexPath.row]
        
        cell.textLabel?.text = game.name
        let rating: NSNumber! = NSNumber(value: game.rating)
        cell.detailTextLabel?.text = "\(self.numberFormatter.string(from: rating) ?? "")"
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let game = savedGames[indexPath.row]
            
            if let index = savedGames.firstIndex(of: game) {
                savedGames.remove(at: index)
                gamesToDelete.append(game)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
