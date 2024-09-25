# Pandoc Utils

This is a set of customised pandoc commands in zsh functions.

## Dependencies

- [Pandoc](https://pandoc.org)
- [Inliner](https://github.com/remy/inliner)
- [fswatch](https://emcrisostomo.github.io/fswatch/) (If you want to use monitor features)

## How to use

- Clone the repository (you need to add `--recursive` to clone submodules together)

```
git clone --recursive git@github.com:handk85/pandoc_utils.git
```

- Make a symbolic link

```
ln -s PATH_TO_REPO ~/.pandoc_utils
```

- Add the below line in your `.zshrc`

```
source ~/.pandoc_utils/functions.sh
```

- Run `source ~/.zshrc`, then you can use the functions
