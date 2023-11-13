# My dev enviroment configs - links dotfiles to currentfile , Main is maintained as macos branch now

<h3> Installation </h3>
<p>Just run ./install</p>
<p>If for some reason ./install doesn't work make sure you make it executable using chmod +x ./install</p>

<h2>Applications Used<p> - make sure you have installed you can install all by brew instructions must be in wiki</p></h2>
<ul>
    <li>Alacritty</li>
    <li>Neovim</li>
    <li>Tmux</li>
    <li>Yabai</li>
    <li>skhd</li>
</ul>

<h2>Dependenciees<p> - make sure you have installed you can install all by brew</p></h2>
<ul>
    <li>fzf</li>
    <li>ripgrep</li>
    <li>tmux</li>
    <li>xclip</li>
    <li>pngpaste</li>
    <li>lazy-git</li>
</ul>

<h2>Theme : Monokai<h2>

<h3> Fonts used </h3>
<p>JetBrainMono Nerd Font can be found here -> https://www.nerdfonts.com/font-downloads</p>
<p>In neovim use :TSUpdate to fix treesitter error</p>

### To make sure that t works

To ensure that your script `t` can be recognized as a command on macOS, you need to add `~/.local/bin` to your PATH if it's not already there. Here's how you can do that:

1. Open your shell profile file in a text editor. If you're using Bash, this file will typically be `~/.bash_profile`, `~/.bashrc`, or `~/.profile`. If you're using Zsh (which is the default as of macOS Catalina), the file will be `~/.zshrc`.

2. Add the following line to the file to include `~/.local/bin` in your PATH:

   ```sh
   export PATH="$HOME/.local/bin:$PATH"
   ```

3. Save the file and reload your shell configuration. For example, if you're using Bash, you can source your profile:

   ```sh
   source ~/.bash_profile
   ```

   Or if you're using Zsh _which you will be_:

   ```sh
   source ~/.zshrc
   ```

   Alternatively, you can just restart your terminal.
   After doing this, try running the `t` command again. It should now be recognized, provided that the script is executable. If it's not, you'll need to make it executable by running:

   ```sh
   chmod +x $HOME/.local/bin/t
   ```

Remember, when you create a symbolic link on macOS (or any Unix-like OS), the target of the link (in your case, `$DOTFILES/scripts/t`) must also be an executable file for the link to work as a command.
