import Types "Types";
import Hash "mo:base/Hash";
import Trie "mo:base/Trie";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Principal "mo:base/Principal";

module Utils {
  // Keys
  public func principalKey(principal: Principal) : Trie.Key<Principal> {
    return { hash = Principal.hash(principal); key = principal };
  };

  public func hashKey(x: Hash.Hash) : Trie.Key<Hash.Hash> {
    return { hash = x; key = x };
  };

  public func textKey(x : Text) : Trie.Key<Text> {
    return { hash = Text.hash(x); key = x };
  };

  public func intKey(x : Int) : Trie.Key<Int> {
    return { hash = Int.hash(x); key = x }
  };
}