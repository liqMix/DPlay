# DPlay
This is a small project to explore Dfinity platform, DFX, and the Makoto language.

The goal is to provide a simple game between two players, and allowing both players to wager identical amounts on the outcome. The game is a simple one-dimensional euclidean distance from a random number. IE: A random number is generated between a given range and is considered the target. Each player must then guess a number. Whoever has the closest number to the target wins both the wagers. A tie refunds the wagers to the players

Each game begins a request from one player to another. The request consists of simply the player name, the wager amount, and a hidden guess. Once received, a player will be able to respond to the request with their own guess, and spends the same amount as the first requester's wager. Once both wagers and guesses are recieved, the winner is decided, paid, and the match history for both players is updated. If the player does not want to wager the same amount, they may decline the request.

Only one game between two unique players is allowed at a time.

# Current Features
- New Player Creation
- User Player Retrieval

# Future Features
- The Actual Game Part
- Current Requests
- Match History

# Build
- Clone the repo
- Run `dfx start` in one console window to start the local dpx service
- Run `npm install` to install the node dependencies
- Run `dfx deploy` to deploy the canisters

# DFX Intro
Welcome to your new DPlay project and to the internet computer development community. By default, creating a new project adds this README and some template files to your project directory. You can edit these template files to customize your project and to include your own code to speed up the development cycle.

To get started, you might want to explore the project directory structure and the default configuration file. Working with this project in your development environment will not affect any production deployment or identity tokens.

To learn more before you start working with DPlay, see the following documentation available online:

- [Quick Start](https://sdk.dfinity.org/docs/quickstart/quickstart-intro.html)
- [SDK Developer Tools](https://sdk.dfinity.org/docs/developers-guide/sdk-guide.html)
- [Motoko Programming Language Guide](https://sdk.dfinity.org/docs/language-guide/motoko.html)
- [Motoko Language Quick Reference](https://sdk.dfinity.org/docs/language-guide/language-manual.html)