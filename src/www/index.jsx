import React from 'react';
import ReactDOM from 'react-dom';

import User from "./components/user";

class App extends React.Component {

  render() {
    return (
      <div>
        <h1>DPlay</h1>
        <hr/>
        <User/>
      </div>
    );
  }
}

export default App;

ReactDOM.render(<App/>, document.getElementById('app'));