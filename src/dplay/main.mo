import Types "Types";
import Utils "Utils";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Trie "mo:base/Trie";
import Bool "mo:base/Bool";
import List "mo:base/List";
import Hash "mo:base/Hash";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";

actor {

  /*
    Stable objects to persist between deployments
  */
  // List of players, hash of msg.caller to the player data
  private stable var players: Trie.Trie<Hash.Hash, Types.Player> = Trie.empty();

  // List of player names, player name to hash of msg.caller
  private stable var playerNames: Trie.Trie<Text, Hash.Hash> = Trie.empty();

  // List of games, game ID to game data
  private stable var games: Trie.Trie<Int, Types.Game> = Trie.empty();


  //////////////////////////////////////////////////////////////////////////////////////////////
  /*
      Player Info
  */

  private func getPlayerByID(playerID: Hash.Hash) : ?Types.Player {
    return Trie.find(players, Utils.hashKey(playerID), Hash.equal);
  };
  private func getPlayerByName(playerName: Text) : ?Types.Player {
    switch(Trie.find(playerNames, Utils.textKey(playerName), Text.equal)) {
      case null {
        return null;
      };
      case (?playerID) {
        return getPlayerByID(playerID);
      }
    }
  };
  public func addPlayer(player: Types.Player){
    let playerID : Hash.Hash = player.id;
    let playerName : Text = player.name;
    players := Trie.replace(players, Utils.hashKey(playerID), Hash.equal, ?player).0;
    playerNames := Trie.replace(playerNames, Utils.textKey(playerName), Text.equal, ?playerID).0;
  };


  //////////////////////////////////////////////////////////////////////////////////////////////////
  /*
      Game Info
  */

  private func getGameByID(id: Int) : ?Types.Game {
    return Trie.find(games, Utils.intKey(id), Int.equal);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  /*
    Exposed methods
  */

  // Gets the player for a caller
  public query (msg) func getPlayer() : async ?Text {
    Debug.print("Getting player information...");

    switch(getPlayerByID(Principal.hash(msg.caller))){
      case null {
        Debug.print("No player found.");
        return null;
      };
      case (?player) {
        Debug.print("Player found.");
        return ?player.name;
      };
    };
  };

  // Creates and persists a player for a new user
  // Checks is name is already taken
  // returns the player if it already exists
  public shared (msg) func createPlayer(playerName: Text) : async ?Text {
    Debug.print("Checking for user...");
    let caller = Principal.hash(msg.caller);

    // Check if user has existing player info
    switch(getPlayerByID(caller)){
      case null {
        Debug.print("No player found for ID...");
      };
      case (?player) {
        return ?player.name;
      };
    };

    // Check if name is already taken
    switch(getPlayerByName(playerName)){
      case null {};
      case (?player) {
        Debug.print("Name already taken.");
        return null;
      };
    };

    // Create new player
    let player: Types.Player = {id=caller; name=playerName; balance=0; matches=Trie.empty(); history=[]};
    addPlayer(player);
    Debug.print("Player created for user, returning player...");
    return ?player.name;
  };


  public shared (msg) func getCallerWalletBalance() : async ?Nat {
    return ?Cycles.available();
  };

  // Retrieves player balance
  public shared query (msg) func getBalance(): async ?Nat {
    Debug.print("Getting player balance...");
    switch(getPlayerByID(Principal.hash(msg.caller))){
      case null { return null; };
      case (?player) { return ?player.balance };
    };
  };

  // Deposits to player balance
  public shared (msg) func addBalance(amount: Nat) : async ?Nat {
    if(amount <= 0) return null;

    Debug.print("Adding to player balance...");
    switch(getPlayerByID(Principal.hash(msg.caller))){
      case null {
        Debug.print("Player not found...");
        return null;
      };
      case (?player) {
        Debug.print("Player found...");
        Debug.print("Player has ");
        Debug.print(Nat.toText(Cycles.available()));
        Debug.print("Cycles available.");
        let deposit = Cycles.accept(amount);
        assert(deposit == amount);
        let new_player = {id=player.id; name=player.name; balance=player.balance + deposit; matches=player.matches; history=player.history};
        addPlayer(new_player);
        Debug.print(Text.concat(Text.concat("Added ", Int.toText(deposit)), "to balance."));
        return ?new_player.balance;
      };
    };
  };
};