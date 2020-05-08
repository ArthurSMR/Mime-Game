//
//  GameService.swift
//  Mime Game
//
//  Created by anthony gianeli on 07/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import Foundation

protocol GameEngineDelegate: class {
    func setupStartGame()
    func setupNextMimickr(nextMimickrIndex: Data)
    func setupToMimickr()
    func setupToDiviner()
    func setupChooseCurrentMime(with index: Int, currentMime: Mime)
}

class GameEngine {
    
    var game: Game
    let totalTurnTime = 10
    let startPlayer = 0
    let wordCategory: Theme = .general
    var delegate: GameEngineDelegate?
    var currentMimickr: Player?
    var nextMimickr: Player?
    
    var mimes: [Mime]?
    var selectableMimes: [Mime]?
    
    init(localPlayer: Player, remotePlayers: [Player]) {
        
        let uids = [localPlayer.uid] + remotePlayers.map { $0.uid }
        
        self.game = Game(localPlayer: localPlayer, players: remotePlayers, uids: uids, totalTime: self.totalTurnTime, currentPlayer: self.startPlayer, wordCategory: self.wordCategory)
    }
    
    func setupGame(completion: @escaping() -> Void)  {
        self.fetchMimes(completion: completion)
    }
    
    func fetchMimes(completion: @escaping() -> Void) {
        
        MimeServices.fetchMimes(for: game.wordCategory, completion: { (mimes, error) in
            if let error = error {
                print(error)
            } else {
                self.mimes = mimes
                self.selectableMimes = mimes
                completion()
            }
        })
    }
    
    func startGame() {
        game.uids = game.uids.sorted()
        guard let firstUidSorted = game.uids.first else { return }
        self.nextMimickr = getPlayer(with: firstUidSorted)
        game.selectablePlayersWithUid = game.uids
        self.game.selectablePlayersWithUid.removeFirst()
        self.game.localPlayer.type = .diviner
        delegate?.setupStartGame()
    }
    
    func startTurn() {
        
        guard let nextMimickr = self.nextMimickr else { return }
        
        if nextMimickr.type == .unavailable {
            chooseNextMimickr()
            startTurn()
        }
        
        if nextMimickr.uid == game.localPlayer.uid {
            self.currentMimickr = self.nextMimickr
            chooseNextMimickr()
            setToMimickr()
        } else {
            self.game.localPlayer.type = .diviner
            delegate?.setupToDiviner()
        }
    }
    
    private func setToMimickr() {
        self.game.localPlayer.type = .mimickr
        self.chooseCurrentMime()
        delegate?.setupToMimickr()
    }
    
    func chooseCurrentMime() {
        guard let selectableMimes = self.selectableMimes else { return }
        let selectedMimeIndex = Int(arc4random()) % selectableMimes.count
        let selectedMime = selectableMimes[selectedMimeIndex]
        self.selectableMimes?.remove(at: selectedMimeIndex)
        delegate?.setupChooseCurrentMime(with: selectedMimeIndex, currentMime: selectedMime)
    }
    
    func createNextMimickr(_ selectedMimickrIndex: Int) {
        self.nextMimickr = getPlayer(with: game.selectablePlayersWithUid[selectedMimickrIndex])
        self.game.selectablePlayersWithUid.remove(at: selectedMimickrIndex)
    }
    
    func validateSelectablePlayers() {
        if game.selectablePlayersWithUid.isEmpty {
            game.selectablePlayersWithUid = game.uids
        }
    }
    
    func chooseNextMimickr() {
        
        validateSelectablePlayers()
        
        var selectedMimickrIndex = Int(arc4random()) % game.selectablePlayersWithUid.count
        
        createNextMimickr(selectedMimickrIndex)
        
         let dataSelectedPlayerIndex = Data(bytes: &selectedMimickrIndex, count: MemoryLayout.size(ofValue: selectedMimickrIndex))
        delegate?.setupNextMimickr(nextMimickrIndex: dataSelectedPlayerIndex)
    }
    
    func getPlayer(with index: Int) -> Player {
        return getPlayer(with: game.selectablePlayersWithUid[index])
    }
    
    func getPlayer(with uid: UInt) -> Player {
        
        if uid == self.game.localPlayer.uid {
            return self.game.localPlayer
        }
        
        for remotePlayer in game.remotePlayers {
            if remotePlayer.uid == uid {
                return remotePlayer
            }
        }
        return Player()
    }
    
    func setNextMimickr(selectedNextPlayerIndex: Int) {
        validateSelectablePlayers()
        createNextMimickr(selectedNextPlayerIndex)
    }
    
    /// Set the player type to unavailable  when he leaves
    /// - Parameter uid: player leaving uid
    func removeRemotePlayer(with uid: UInt) {
    
        for remotePlayer in game.remotePlayers {
            if remotePlayer.uid == uid {
                remotePlayer.type = .unavailable
                print("\(remotePlayer.name) leave channel ")
            }
        }
    }
    
}
