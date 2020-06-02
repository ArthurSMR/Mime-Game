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
    func setupNextMimickr(nextMimickrIndex: Int)
    func setupToMimickr()
    func setupToDiviner()
    func setupChooseCurrentMime(currentMime: Mime, isNewTurn: Bool, mimeIndex: Int)
    func didSendMessage()
    func didReceiveMessage()
    func endGame()
    func startTurn()
}

class GameEngine {
    
    //MARK: - Variables
    
    var game: Game
    let totalTurnTime = 10 // tenho que mudar isso
    var currentTurn = 0
    let startPlayer = 0
    var delegate: GameEngineDelegate?
    var currentMimickr: Player?
    var nextMimickr: Player?
    var mimes: [Mime] = []
    var selectableMimes: [Mime] = []
    var messages: [Message] = []
    var chosenMimes: [Mime] = []
    var soundFXManager = SoundFX()
    var gameTheme: String
    
    init(localPlayer: Player, remotePlayers: [Player], with settings: GameSettings) {
        
        let uids = [localPlayer.uid] + remotePlayers.map { $0.uid }
        
        self.game = Game(localPlayer: localPlayer, players: remotePlayers, uids: uids, totalTime: settings.totalTurnTime, currentPlayer: self.startPlayer, messages: self.messages, quantityPlayedWithMimickr: settings.quantityPlayedWithMimickr)
        
        self.gameTheme = settings.theme
    }
    
    /// This method is to setup all the game configurations before it starts
    /// - Parameter completion: completion  when fetch mimes is sucessfull or fail
    func setupGame(completion: @escaping() -> Void)  {
        self.fetchMimes(completion: completion)
    }
    
    /// This method is to fetch mimes from the database
    /// - Parameter completion: completion when the fetch is completed
    func fetchMimes(completion: @escaping() -> Void) {
        
        MimeServices.fetchMimes(completion: { (mimes, error) in
            if let error = error {
                print(error)
            } else {
                self.mimes = mimes.filter { $0.theme.contains(self.gameTheme) } // filtering by the game theme
                self.selectableMimes = self.mimes
                completion()
            }
        })
    }
    
    //MARK: - Lifecycle
    
    /// This method start the game
    func startGame() {
        game.uids = game.uids.sorted() //the first uid will be the first mimickr
        guard let firstUidSorted = game.uids.first else { return }
        self.nextMimickr = getPlayer(with: firstUidSorted)
        self.currentMimickr = getPlayer(with: firstUidSorted)
        game.selectablePlayersWithUid = game.uids
        self.game.selectablePlayersWithUid.removeFirst()
        self.game.localPlayer.type = .diviner
        delegate?.setupStartGame()
    }
    
    func mimickrStartTurn() {
        
        self.currentTurn += 1
        
        // Mimickr start next turn
        if nextMimickr?.uid == game.localPlayer.uid {
            if canStartTurn() {
                delegate?.startTurn()
                self.startTurn()
            }
        }
    }
    
    /// This method start the turn setting to mimickr or diviner a player
    func startTurn() {
        self.currentMimickr = self.nextMimickr  // the queue goes on
        chooseNextMimickr()
        setToMimickr()
    }
    
    func setupToDiviner() {
        self.game.localPlayer.type = .diviner
        delegate?.setupToDiviner()
    }
    
    //MARK: - Mimes configuration
    
    /// This  method  choose the  current mime for the turn
    func chooseCurrentMime(newTurn: Bool) {
        
        // Check if there is selectable mimes
        validateSelectableMimes()
        
        // it will select a number between 0 and the selectable mimes count
        let selectedMimeIndex = Int(arc4random()) % selectableMimes.count
        let selectedMime = selectableMimes[selectedMimeIndex]
        
        // we have chosen a mime, so we can remove it from the selectableMimes
        self.selectableMimes.remove(at: selectedMimeIndex)
        
        delegate?.setupChooseCurrentMime(currentMime: selectedMime, isNewTurn: newTurn, mimeIndex: selectedMimeIndex)
    }
    
    //MARK: - Players configuration
    
    /// This method set the localPlayer to mimickr
    private func setToMimickr() {
        self.game.localPlayer.type = .mimickr
        self.chooseCurrentMime(newTurn: true)
        delegate?.setupToMimickr()
    }
    
    /// This method will set the next mimickr for the next turn
    /// - Parameter selectedMimickrIndex: selected mimickr index received from the mimickr
    func createNextMimickr(_ selectedMimickrIndex: Int) {
        self.nextMimickr = getPlayer(with: game.selectablePlayersWithUid[selectedMimickrIndex])
        self.game.selectablePlayersWithUid.remove(at: selectedMimickrIndex)
    }
    
    /// This method, the current mimickr will choose the next mimickr to play and set its index for the others players using the delegate
    func chooseNextMimickr() {
        
        validateSelectablePlayers()
        
        let selectedMimickrIndex = Int(arc4random()) % game.selectablePlayersWithUid.count
        
        createNextMimickr(selectedMimickrIndex)
        
        delegate?.setupNextMimickr(nextMimickrIndex: selectedMimickrIndex)
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
    
    /// This method set the current mimickr with uid received
    /// - Parameters:
    ///   - uid: curent mimickr uid
    func setCurrentMimickr(player uid: UInt) {
        self.currentMimickr = getPlayer(with: uid)
    }
    
    func removeSelectableMime(with index: Int) {
        self.selectableMimes.remove(at: index)
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
    
    /// This method will increase the points for determined player
    /// - Parameter player: player that scored
    func givePoints(for player: Player) {
        player.points += 10
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
        
        if isCorrect {
            givePoints(for: player)
            soundFXManager.playFX(named: "Mensagem_sistema")
        }
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
        
        if isCorrect {
            chooseCurrentMime(newTurn: false)
            givePoints(for: self.game.localPlayer)
            soundFXManager.playFX(named: "Acerto_palavra")
        }
    }
    
    /// This method is to create a message as the right last mime
    /// - Parameter lastMime: the last mime that the turn ended
    func showCorrectMime(lastMime: Mime) {
        
        let correctMime = Message(word: lastMime.name, player: Player(), isCorrect: false, showCorrectMime: true)
        
        self.messages.append(correctMime)
        
        delegate?.didReceiveMessage()
    }
    
    // MARK: - Validators
    
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
        
        return isCorrect
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
            game.selectablePlayersWithUid = game.uids // populating selectableplayers
        }
    }
    
    /// Validade if there is selectableMimes, if there is no mimes left, it will populate with the initial mimes
    func validateSelectableMimes() {
        
        if self.selectableMimes.isEmpty {
            self.selectableMimes = self.mimes
        }
    }
    
    /// Method to validate if can start the new turn
    /// It wiil compare iif the current turn is > than the total game urns
    /// - Returns: return a boolean indicating if can start or not
    func canStartTurn() -> Bool {
        if self.currentTurn > self.game.totalTurns {
            delegate?.endGame()
            return false
        }
        return true
    }
}
