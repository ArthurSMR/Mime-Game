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
    func didSendMessage()
    func didReceiveMessage()
}

class GameEngine {
    
    //MARK: - Variables
    
    var game: Game
    let totalTurnTime = 5
    let startPlayer = 0
    let wordCategory: Theme = .general
    var delegate: GameEngineDelegate?
    var currentMimickr: Player?
    var nextMimickr: Player?
    var mimes: [Mime] = []
    var selectableMimes: [Mime] = []
    var messages: [Message] = []
    
    init(localPlayer: Player, remotePlayers: [Player]) {
        
        let uids = [localPlayer.uid] + remotePlayers.map { $0.uid }
        
        self.game = Game(localPlayer: localPlayer, players: remotePlayers, uids: uids, totalTime: self.totalTurnTime, currentPlayer: self.startPlayer, wordCategory: self.wordCategory, messages: self.messages)
    }
    
    /// This method is to setup all the game configurations before it starts
    /// - Parameter completion: completion  when fetch mimes is sucessfull or fail
    func setupGame(completion: @escaping() -> Void)  {
        self.fetchMimes(completion: completion)
    }
    
    /// This method is to fetch mimes from the database
    /// - Parameter completion: completion when the fetch is completed
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
    
    //MARK: - Lifecycle
    
    /// This method start the game
    func startGame() {
        game.uids = game.uids.sorted()
        guard let firstUidSorted = game.uids.first else { return }
        self.nextMimickr = getPlayer(with: firstUidSorted)
        game.selectablePlayersWithUid = game.uids
        self.game.selectablePlayersWithUid.removeFirst()
        self.game.localPlayer.type = .diviner
        delegate?.setupStartGame()
    }
    
    /// This method start the turn setting to mimickr or diviner a player
    func startTurn() {
        
        guard let nextMimickr = self.nextMimickr else { return }
        
        if nextMimickr.type == .unavailable { // Testar com mais pessoas numa partida...
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
    
    //MARK: - Mimes configuration
    
    /// This  method  choose the  current mime for the turn
    func chooseCurrentMime() {
        
        validadeSelectableMimes()
        
        let selectedMimeIndex = Int(arc4random()) % selectableMimes.count
        let selectedMime = selectableMimes[selectedMimeIndex]
        self.selectableMimes.remove(at: selectedMimeIndex)
        delegate?.setupChooseCurrentMime(with: selectedMimeIndex, currentMime: selectedMime)
    }
    
    //MARK: - Players configuration
    
    /// This method set the localPlayer to mimickr
    private func setToMimickr() {
        self.game.localPlayer.type = .mimickr
        self.chooseCurrentMime()
        delegate?.setupToMimickr()
    }
    
    /// This method will set the next mimickr for the next turn
    /// - Parameter selectedMimickrIndex: selected mimickr index received from the mimickr
    func createNextMimickr(_ selectedMimickrIndex: Int) {
        self.nextMimickr = getPlayer(with: game.selectablePlayersWithUid[selectedMimickrIndex])
        self.game.selectablePlayersWithUid.remove(at: selectedMimickrIndex)
    }
    
    /// This method will validade if the selectable to see if it is empty or not
    /// If selectablePlayers is empty, it will reset it to the initial selectable players
    ///
    /// Example: First selectable player array:  selectablePlayer = [Arthur, Anthony, Jesse, Lucas]
    /// If all people from the array already played, the array should be empty: selectablePlayer = []
    /// This method will set it to the full and first array: selectablePlayer receive [Arthur, Anthony, Jesse, Lucas]
    /// To continue  the gameplay
    func validateSelectablePlayers() {
        if game.selectablePlayersWithUid.isEmpty {
            game.selectablePlayersWithUid = game.uids
        }
    }
    
    func validadeSelectableMimes() {
        
        if self.selectableMimes.isEmpty {
            self.selectableMimes = self.mimes
        }
    }
    
    /// This method, the current mimickr will choose the next mimickr to play and set its index for the others players using the delegate
    func chooseNextMimickr() {
        
        validateSelectablePlayers()
        
        var selectedMimickrIndex = Int(arc4random()) % game.selectablePlayersWithUid.count
        
        createNextMimickr(selectedMimickrIndex)
        
         let dataSelectedPlayerIndex = Data(bytes: &selectedMimickrIndex, count: MemoryLayout.size(ofValue: selectedMimickrIndex))
        delegate?.setupNextMimickr(nextMimickrIndex: dataSelectedPlayerIndex)
    }
    
    /// This method is to get player using its index
    /// - Parameter index: Index player
    /// - Returns: return the player in the index received
    func getPlayer(with index: Int) -> Player {
        return getPlayer(with: game.selectablePlayersWithUid[index])
    }
    
    /// This method is to get player using its UID
    /// - Parameter uid: player uid
    /// - Returns: return a player with uid received
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
    
    /// This method will set the next mimickr for the diviners
    /// This method is called when the diviners receive the next mimickr at agora delegate data stream
    /// - Parameter selectedNextPlayerIndex: next player index
    func setNextMimickr(selectedNextPlayerIndex: Int) {
        validateSelectablePlayers()
        createNextMimickr(selectedNextPlayerIndex)
    }
    
    
    /// This method remove the mime the mime chosen with index received to no longer be selected and
    /// set the current mimickr with uid
    /// - Parameters:
    ///   - index: mime index used on selectable mimes,  received from the mimickr.
    ///   - uid: curent mimickr uid
    func setCurrentMimickr(with index: Int, player uid: UInt) {
        self.selectableMimes.remove(at: index)
        self.currentMimickr = getPlayer(with: uid)
    }
    
    
    /// This method will sort players by points
    /// - Returns: sorted players aray by points
    func sortPlayers() -> [Player] {
        let players = [self.game.localPlayer] + self.game.remotePlayers
        return players.sorted(by: { $0.points > $1.points })
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
    
    //MARK: - Messages configuration
    
    /// This method set the received message with the player who sent it and if it is correct or not
    /// - Parameters:
    ///   - receivedMessage: received message from the agora delegate data stream
    ///   - currentMimeWord: the current mime word
    ///   - uid: uid from the player who sent the message
    func setReceivedMessage(receivedMessage: String, currentMimeWord: String, receivedMessegeFrom uid: UInt) {
        
        let player = getPlayer(with: uid)
        
        let isCorrect = isMessegeCorrect(wordWritten: receivedMessage, currentMime: currentMimeWord, player: player)
        
        let message = Message(word: receivedMessage, player: player, isCorrect: isCorrect)
        
        self.messages.append(message)
        
        delegate?.didReceiveMessage()
    }
    
    /// This method will be called when the local player send a message, and check if it is correct or not
    /// - Parameters:
    ///   - sentMessage: sent message from the text field on game view controller
    ///   - currentMimeWord: current mime word
    func setSentMessage(sentMessage: String, currentMimeWord: String) {
        
        let isCorrect = isMessegeCorrect(wordWritten: sentMessage, currentMime: currentMimeWord, player: self.game.localPlayer)
        
        let message = Message(word: sentMessage, player: self.game.localPlayer, isCorrect: isCorrect)
        
        self.messages.append(message)
        
        delegate?.didSendMessage()
    }
    
    /// This method check is the message is correct comparing in a uppercased way and ignoring diacritics
    /// - Parameter wordWritten: the received word that will be checked with the right word
    /// - Parameter currentMime: Mime word that the people are trying to divine
    /// - Parameter player: Player that wrote the message
    /// - Returns: return a boolean (true if is correct and false if is wrong)
    func isMessegeCorrect(wordWritten: String, currentMime: String, player: Player) -> Bool {
        
        // We ignore diacritics and set to uppercased
        // to compare the the word written and the current mime
        
        let wordDiacriticInsensitive = wordWritten.folding(options: .diacriticInsensitive, locale: .current)
        let currentMimeDiacriticInsensitive = currentMime.folding(options: .diacriticInsensitive, locale: .current)
        
        let isCorrect = wordDiacriticInsensitive.uppercased() == currentMimeDiacriticInsensitive.uppercased() ? true : false
        
        if isCorrect {
            givePoints(for: player)
//            chooseCurrentMime()
        }
        
        return isCorrect
    }
    
    /// This method will increase the points for determined player
    /// - Parameter player: player that scored
    func givePoints(for player: Player) {
        player.points += 10
    }
}
