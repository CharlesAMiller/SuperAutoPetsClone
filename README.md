# Super Auto Pets Clone
![Unit Tests](https://github.com/CharlesAMiller/SuperAutoPetsClone/actions/workflows/elixir.yml/badge.svg)

This project is a work in progress to recreate the logic of the game [Super Auto Pets](https://teamwoodgames.com/), while learning more about Elixir and FP as a whole. 

Presently, things like a game client (e.g. graphics, UI's, audio) are considered out of scope of this project. 

## Getting Started
1. [Install Elixir](https://elixir-lang.org/install.html) (the project uses v1.13) and ensure the [Erlang OTP version](https://elixir-lang.org/install.html#installing-erlang) is at least version 24.
2. Clone the repository
3. Open the project using your desired editor (I use [VSCode](https://code.visualstudio.com/) with the [ElixirLS extension](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls))

## Testing 
From the root of the project, run `mix test`

Additionally, a test task is included for those using VSCode, within `.vscode/launch.json`