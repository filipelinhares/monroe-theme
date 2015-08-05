# Monroe
> Minimal and useful terminal theme

![Terminal screen](./img/screenshot.png)

## Features
- Show the number of untracked files with ↭
- Show the number of commits unpusheds with ⇡
- Show the number of unmerged branchs with ♆
- Show if has unpulled changes with ⇣ `new feature` 
- Show the Ruby version
- Show the Node version

## Example
![Terminal screen](./img/example-screenshot.png)
![Terminal screen](./img/example2-screenshot.png)

`↭1` - 1 untrackef file  
`⇡1` - 1 commit to push  
`♆1` - 1 branch to merge  

The red color of branch name it's because the branch is dirty, and the green name of the branch is because is clean.


## Installation

#### wget
```bash
wget -O $HOME/.oh-my-zsh/themes/monroe.zsh-theme https://raw.githubusercontent.com/filipelinhares/monroe-theme/master/monroe.zsh-theme
```

#### cURL
```bash
curl https://raw.githubusercontent.com/filipelinhares/monroe-theme/master/monroe.zsh-theme > $HOME/.oh-my-zsh/themes/monroe.zsh-theme
```

## Configure
In your **~/.zshrc** file with this line:
```bash
ZSH_THEME="monroe"
```

## Customization
You can change the variables you own to just display things useful for you:

```bash
MONROE_RUBY_SHOW=true
MONROE_NVM_SHOW=true
MONROE_SHOW_UNPUSHED=true
MONROE_SHOW_UNMERGED=true
MONROE_SHOW_UNTRACKED=true
MONROE_SHOW_UNPULLED=true
```

## Simple version
You can use our [simple version](https://github.com/filipelinhares/monroe-theme/tree/simple-version) of Monroe Theme, it's more performatic.

## License
MIT © [Filipe Linhares](http://filipelinhares.com)
