import React from 'react';
import DPlay from './dplay';
const idl = require('../utilities/idl');

export default class User extends React.Component {

  constructor() {
    super();
    this.state = {
      render: "Loading user...",
      player: null,
      playername: "",
      error: ""
    };

    this.createPlayer = this.createPlayer.bind(this);
    this.createPlayerInput = this.createPlayerInput.bind(this);
    this.onChange = this.onChange.bind(this);
  }

  onChange = e => this.setState({ [e.target.name]: e.target.value })

  componentDidMount(){
    DPlay.getPlayer().then((result) => {
      const player = idl.fromOptional(result);
      if(!result || result.length === 0) this.setState({render: this.createPlayerInput()});
      else this.setState({player: player});
    });
  }

  createPlayer(){
    this.setState({render: "Creating user..."});
    DPlay.createPlayer(this.state.playername).then((result) => {
      const player = idl.fromOptional(result);
      if(player) this.setState({player: player});
      else this.setState({
        error: "Player name already taken.",
        render: this.createPlayerInput()
      });
    });

  }
  createPlayerInput(){
    return (
      <>
        <h1>Create Player</h1>
        <input placeholder="Enter name" type="text" name="playername" onChange={this.onChange}/>
        <button type="submit" onClick={this.createPlayer}>Submit</button>
      </>
    )
  }

  render() {
    let render = this.state.render;
    if(this.state.player){
      render =  (
        <>
          <h1>{this.state.player.name}</h1>
          <p>ID: {this.state.player.id}</p>
        </>
      )
    }
    return (
      <div>
        {this.state.error}
        {render}
      </div>
    );
  }
}
