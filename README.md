repo-to-bitbucket
==========
A simple bash script for backing up local repositories to bitbucket private.

What does it do?
-----
The script runs over a directory and checks if each subfolder is a git repo. If it is; it will stash any local changes then pull ALL remote branches down locally. It then creates a new private bitbucket repository for each local one. Then it as a new remote called `bitbucket` to each project. Finally it pushes all branches and tags to new repository on bitbucket.

How to use this?
-----
1. Git clone the repo to somewhere sensible
2. Create a hidden `.r2b-credentials.sh` file in the `$HOME` dir of the user.
```
touch $HOME/.r2b-credentials.sh
```
3. Add the following to `.r2b-credentials.sh` replacing `<YOUR_USER>`, `<YOUR_PASSWORD>` and `<YOUR_TEAM>` to your BitBucket account credentials and Team name. Use the `.r2b-credentials.example.sh` as an example
```
export BITBUCKET_TEAM='<YOUR_TEAM>'
export BITBUCKET_USER='<YOUR_USER>'
export BITBUCKET_PASSWORD='<YOUR_PASSWORD>'
```
4. Symlink the full path to the scripts location to your bin directory so you can run the script from any dir.
```
sudo ln -s /full/path/to/repo-to-bitbucket/repo-to-bitbucket.sh /usr/local/bin/repo-to-bitbucket
```
5. Navigate to a folder containing a collection of other git repository and run the script using `repo-to-bitbucket`.
For example file structure below shows a folder called `my-git-projects` which contains a bunch of other repositories. To back those up, run the script from `my-git-projects`.

```
.
+-- my-git-projects
|   +-- some-cool-app
|       +-- .git
|   +-- other-fun-app
|       +-- .git
|   +-- also-fun-app
|       +-- .git
```
