import Types "Types";
import Trie "mo:base/Trie";

module Utils {
  public func initPlayer(playerId: Text, playerName: Text): Types.Player {
    let player: Types.Player = {
      id = playerId;
      name = playerName;
      matches = null;
      history = null;
    };
    return player;
  };

}