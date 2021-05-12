import React from 'react';
import DPlay from './dplay';
const idl = require('../utilities/idl');

export default class User extends React.Component {

  constructor() {
    super();
    this.state = {
      render: "Loading user...",
      status: null,
      player: null,
      deposit: 0,
      balance: 0,
      wallet_balance: 0,
      matches: [],
      requests: [],
      playername: "",
      error: ""
    };

    this.createPlayer = this.createPlayer.bind(this);
    this.createPlayerInput = this.createPlayerInput.bind(this);
    this.getBalance = this.getBalance.bind(this);
    this.deposit = this.deposit.bind(this);
    this.onChange = this.onChange.bind(this);
  }

  onChange = e => {this.setState({ [e.target.name]: e.target.value })};

  componentDidMount(){
    DPlay.getPlayer().then((result) => {
      const player = idl.fromOptional(result);
      if(!result || result.length === 0) this.setState({render: this.createPlayerInput()});
      else {
        this.setState({player: {name: player}});
        this.getBalance();
      };
    });
  }

  createPlayer(e){
    e.preventDefault(); 
    this.setState({render: "Creating user..."});
    DPlay.createPlayer(this.state.playername).then((result) => {
      const player = idl.fromOptional(result);
      if(player) {
        this.setState({player: {name: player}});
        this.getBalance();
      }
      else this.setState({
        error: "Player name already taken.",
        render: this.createPlayerInput()
      });
    });
  }

  getBalance(){
    DPlay.getBalance().then((result) => {
      const balance = idl.fromOptional(result);
      this.setState({status: null, player: {...this.state.player, balance: balance? balance: 0}});
    });
    DPlay.getCallerWalletBalance().then((result) => {
      const balance = idl.fromOptional(result);
      this.setState({status: null, player: {...this.state.player, wallet_balance: balance? balance: 0}});
    });
  }

  createPlayerInput(){
    return (
      <>
        <h1>Create Player</h1>
        <form onSubmit={this.createPlayer}>
          <input placeholder="Enter name" type="text" name="playername" onChange={this.onChange}/>
          <button type="submit">Submit</button>
        </form>
      </>
    )
  }

  deposit(e){
    e.preventDefault();
    this.setState({status: "Depositing..."});
    console.log('Deposit: ', this.state.deposit);
    DPlay.addBalance(parseInt(this.state.deposit)).then((result)=>{
      if(!result){this.setState({error: "Unable to deposit."})}
      else {
        this.setState({deposit: 0});
        this.getBalance();
      }
    });
  }

  createBalanceInput(){
    return (
      <form onSubmit={this.deposit}>
        <input placeholder="Enter deposit" type="number" name="deposit" onChange={this.onChange}/>
        <button type="submit">Deposit</button>
      </form>
    )
  }

  render() {
    let render = this.state.render;
    if(this.state.player){
      render =  (
        <>
          <h1>{this.state.player.name}</h1>
          <p>Wallet: {this.state.player.wallet_balance} shkekles</p>
          <p>Balance: {this.state.player.balance} shkekles</p> {this.createBalanceInput()}
        </>
      )
    }
    return (
      <div>
        {this.state.error}
        {render}
        {this.state.status}
      </div>
    );
  }
}
