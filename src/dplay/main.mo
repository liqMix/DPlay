import Types "Types";
import Utils "Utils";
import Trie "mo:base/Trie";
import Bool "mo:base/Bool";
import List "mo:base/List";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";

shared(msg) actor class Game() {
  // Set owner
  let owner = msg.caller;

  // User Info
  private stable var playerList : Trie.Trie<Types.PlayerID, Types.Player> = Trie.empty();
  private stable var playerNameList: Trie.Trie<Types.PlayerName, Types.PlayerID> = Trie.empty();

  // Gets the player for a caller
  public shared (msg) func getPlayer() : async ?Types.Player {
    Debug.print("Getting player information...");
    Debug.print(Principal.toText(msg.caller));


    switch(Trie.find(playerList, textKey(Principal.toText(msg.caller)), Text.equal)){
      case null {
        Debug.print("No player found.");
        return null;
      };
      case (?player) {
        Debug.print("Player found.");
        if(msg.caller == owner)
          Debug.print("And you're the owner! helo ownr :)");
        return ?player;
      };
    };
  };

  // Creates and persists a player for a new user
  // Checks is name is already taken
  // returns the player if it already exists
  public shared (msg) func createPlayer(playerName: Text) : async ?Types.Player {
    let caller = Principal.toText(msg.caller);

    Debug.print("Checking for user...");

    // Check if user has existing player info
    switch(Trie.find(playerList, textKey(caller), Text.equal)){
      case null {
        Debug.print("No player found for ID...");
      };
      case (?player) {
        return ?player;
      };
    };

    // Check if name is already taken
    switch(Trie.find(playerNameList, textKey(playerName), Text.equal)){
      case (?player) {
        Debug.print("Name already taken, returning null...");
        return null;
      };
      case null {};
    };

    // Create new player
    let player: Types.Player = Utils.initPlayer(caller, playerName);
    playerList := Trie.replace(playerList, textKey(caller), Text.equal, ?player).0;
    playerNameList := Trie.replace(playerNameList, textKey(playerName), Text.equal, ?caller).0;
    Debug.print("Player created for user, returning player...");
    return ?player;
  };

  /**
  * Utilities
  */

  private func textKey (x : Text) : Trie.Key<Text> {
    return { hash = Text.hash(x); key = x };
  };
};
