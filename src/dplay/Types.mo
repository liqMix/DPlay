import Trie "mo:base/Trie";
import Int "mo:base/Int";
import List "mo:base/List";
import Text "mo:base/Text";
import Hash "mo:base/Hash";

module Types {
  public type PlayerID = Text;
  public type PlayerName = Text;

  public type Participant = {
    id: PlayerID;
    name: PlayerName;
    bet: Int;
    guess: Int;
  };

  public type Game = {
    sender: Participant;
    recipient: ?Participant;
    result: ?Int;
    victor: ?PlayerID;
  };

  public type Player = {
    id: PlayerID;
    name: PlayerName;
    matches: ?Trie.Trie<PlayerID, ?Game>;
    history: ?Trie.Trie<PlayerID, ?List.List<Game>>;
  };
}