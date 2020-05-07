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
    func setupNextMime(with index: Int, currentMime: Mime)
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
        self.currentMimickr = getPlayer(with: firstUidSorted)
        game.selectablePlayersWithUid = game.uids
//        self.game.selectablePlayersWithUid.removeFirst()
        self.game.localPlayer.type = .diviner
        delegate?.setupStartGame()
    }
    
    func turnRound() {
        
        if self.currentMimickr?.uid == game.localPlayer.uid {
            chooseNextMimickr()
            setToMimickr()
        }
    }
    
    private func setToMimickr() {
        self.game.localPlayer.type = .mimickr
        self.nextMime()
        delegate?.setupToMimickr()
    }
    
    func nextMime() {
        guard let selectableMimes = self.selectableMimes else { return }
        let selectedMimeIndex = Int(arc4random()) % selectableMimes.count
        let selectedMime = selectableMimes[selectedMimeIndex]
        self.selectableMimes?.remove(at: selectedMimeIndex)
        delegate?.setupNextMime(with: selectedMimeIndex, currentMime: selectedMime)
    }
    
    func chooseNextMimickr() {
        
        if game.selectablePlayersWithUid.isEmpty {
            game.selectablePlayersWithUid = game.uids
        }
        
        var selectedMimickrIndex = Int(arc4random()) % game.selectablePlayersWithUid.count
        self.nextMimickr = getPlayer(with: game.uids[selectedMimickrIndex])
        print(self.nextMimickr?.name)
        let dataSelectedPlayerIndex = Data(bytes: &selectedMimickrIndex, count: MemoryLayout.size(ofValue: selectedMimickrIndex))
        self.game.selectablePlayersWithUid.remove(at: selectedMimickrIndex)
        delegate?.setupNextMimickr(nextMimickrIndex: dataSelectedPlayerIndex)
    }
    
    private func getPlayer(with uid: UInt) -> Player {
        
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
}
