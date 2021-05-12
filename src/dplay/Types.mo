import Text "mo:base/Text";
import Trie "mo:base/Trie";
import Hash "mo:base/Hash";
import Int "mo:base/Int";

module Types {
  public type Player = {
    id: Hash.Hash;
    name: Text;

    // Holds the amount a user can bet/withdraw
    balance: Nat;

    // Contains a mapping of users -> game ids
    matches: Trie.Trie<Text, [Int]>;
    history: [Int];
  };

  // Marks participant information, connects guess to player
  public type Participant = {
    playerName: Text;
    guess: ?Int;
  };

  // Holds the status of the game
  // Exists as two states:
  //    Pending: victor and result are not populated, recipient's guess is null
  //    Completed: victor and result are populated
  public type Game = {
    gameID: Int;
    sender: Participant;
    recipient: Participant;
    wager: Nat;
    result: ?Int;
    victor: ?Text;
  };
};