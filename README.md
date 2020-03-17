# packer-csgo
Packer config for Counter-Strike: Global Offensive

## Usage
Set the `RCON_PASSWORD`, `STEAM_TOKEN` and `STEAM_AUTHKEY` env
variables appropriately, then run `packer packer.json`

Pass `subnet_name` as a CLI variable if yours isn't named `public-2a`.

Edit/add files to `files/cfg/` to customize the game.
