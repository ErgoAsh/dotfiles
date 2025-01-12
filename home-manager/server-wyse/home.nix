{
		inputs,
		lib,
		pkgs,
		shell,
		... 
}:

# https://nix-community.github.io/home-manager/options.xhtml
{
	home.username = "ergoash";
	home.homeDirectory = "/home/ergoash";
	home.stateVersion = "24.11";

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;

	fonts.fontconfig.enable = true;
	home.packages = [
		(pkgs.nerdfonts.override { fonts = [ "Hack" ]; })
	];

	nixpkgs = {
		config = {
			allowUnfree = true;
			allowUnfreePredicate = (_: true);
		};
	};

	systemd.user.sessionVariables = {
		EDITOR = "nvim";
		TERM = "fish";
	};

	imports = [
		#../packages/bat/bat.nix
		#../packages/brave/brave.nix
		#../packages/direnv/direnv.nix
		#../packages/erdtree/erdtree.nix
		#../packages/eza/eza.nix
		#../packages/fd/fd.nix
		#../packages/feh/feh.nix
		#../packages/fish/fish.nix
		#../packages/helix/helix.nix
		#../packages/htop/htop.nix
		#../packages/megasync/megasync.nix
		#../packages/nap/nap.nix
		#../packages/qbittorrent/qbittorrent.nix
		#../packages/rename/rename.nix
		#../packages/ripgrep/ripgrep.nix
		#../packages/signal-desktop/signal-desktop.nix
		#../packages/starship/starship.nix
		#../packages/tree/tree.nix
		#../packages/vlc/vlc.nix
		#../packages/wezterm/wezterm.nix
		#../packages/ytdlp/ytdlp.nix

		#../scripts/youtube_channel_archiver/youtube_channel_archiver.nix
		#../scripts/single_song_downloader/single_song_downloader.nix
	];

}
