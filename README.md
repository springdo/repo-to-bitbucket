repo-to-bitbucket
==========
A simple bash script for backing up local repositories to bitbucket private.

What does it do?
-----
The script runs over a directory and checks if each subfolder is a git repo. If it is; it will stash any local changes then pull ALL remote branches down locally. It then creates a new private bitbucket repository for each local one. Then it as a new remote called `bitbucket` to each project. Finally it pushes all branches and tags to new repository on bitbucket.

How to use this?
-----
1. Git clone the repo to somewhere sensible
2. Change the following vars in `repo-to-bitbucket.sh` to your bitbucket account credentials and team name
```
export BITBUCKET_TEAM='<YOUR_TEAM_HERE>'
export BITBUCKET_USER='<YOUR_USER_HERE>'
export BITBUCKET_PASSWORD='<YOUR_PASSWORD_HERE>'
```
3. Symlink the script to your bin directory so you can run the script from any dir.
```
sudo ln -s /full/path/to/repo-to-bitbucket/repo-to-bitbucket.sh /usr/local/bin/repo-to-bitbucket
```
4. Navigate to a folder containing a collection of other git repository and run the script using `repo-to-bitbucket`
