#!/bin/bash

# set -o nounset
# set -o errexit
set -o pipefail
# enable for debug
# set -o xtrace

CURRENT_DIR=`pwd`

source $HOME/.r2b-credentials.sh

if [ -z "$BITBUCKET_USER" ];then
  echo -e "\n\n** Please ensure your BITBUCKET_USER is setup in $HOME/.r2b-credentials.sh **"
  exit 999
fi
if [ -z "$BITBUCKET_TEAM" ];then
  echo -e "\n\n** Please ensure your BITBUCKET_TEAM is setup in $HOME/.r2b-credentials.sh **"
  exit 999
fi
if [ -z "$BITBUCKET_PASSWORD" ];then
  echo -e "\n\n** Please ensure your BITBUCKET_PASSWORD is setup in $HOME/.r2b-credentials.sh **"
  exit 999
fi

function doGitMigrate(){
  for REPO in `ls "$CURRENT_DIR"`;do
    if [ -d "$CURRENT_DIR/$REPO" ];then
      echo -e "\n\n** Updating $REPO at `date` **"
      if [ -d "$CURRENT_DIR/$REPO/.git" ]; then
        cd "$CURRENT_DIR/$REPO"
        git status
        echo -e "Fetching"
        git fetch origin
        echo -e "Stashing changes for simplicity"
        git stash
        echo -e "Pulling down all "
        for REMOTE_BRANCH in `git branch -r`; do
          if [[ $REMOTE_BRANCH == *"HEAD"* ]];then
            echo 'NOT DOING STUFF TO HEAD; it complicates stuff'
          else
            git checkout --track ${REMOTE_BRANCH}
            # incase branch is local already; pull any changes
            git pull
          fi
        done

        # just incase ;)
        git checkout master
        git branch -D HEAD
        git remote remove bitbucket

        git remote add bitbucket ssh://git@bitbucket.org/${BITBUCKET_TEAM}/${REPO}
        # # create repositories on bitbucket for the repos
        createBitBucketRepos ${REPO}

        # push stuff
        git push bitbucket --all
        git push bitbucket --tags
      else
        echo -e "\n\nSkipping because it doesn't look like it has a .git folder."
      fi
    fi
  done
  echo -e "\n\nDone at `date`"
  return
}

function createBitBucketRepos() {
  #naming for niceness to people
  REPO=${1}
  echo "Creating BitBucket Repo:: ${REPO}"
  curl -X POST "https://${BITBUCKET_USER}:${BITBUCKET_PASSWORD}@api.bitbucket.org/2.0/repositories/${BITBUCKET_TEAM}/${REPO}" \
      -H "Content-Type: application/json" \
      -d '{"scm": "git", "is_private": "true", "fork_policy": "no_public_forks" }'
}

# call the doGitMigrate to kick this script off
# "$@"

doGitMigrate
