#!/bin/bash

BRANCH="feature/login-system"

task1() {
  echo "Switching to branch $BRANCH..."
  git checkout $BRANCH

  echo "Enter the commit hash for D (or leave empty to use HEAD~1):"
  read COMMIT_D
  if [ -z "$COMMIT_D" ]; then
    COMMIT_D="HEAD~1"
  fi

  echo "Reverting commit $COMMIT_D..."
  git revert --no-edit $COMMIT_D
  echo "Done. Don't forget to push the changes."
}

task2() {
  echo "Switching to branch $BRANCH..."
  git checkout $BRANCH

  echo "Removing last commit but keeping changes..."
  git reset --mixed HEAD~1
  echo "Done. You can now modify the files and commit again."
}

task3() {
  echo "Switching to branch $BRANCH..."
  git checkout $BRANCH

  echo "Enter the commit hash for B (the one you want to go back to):"
  read COMMIT_B

  echo "Resetting to $COMMIT_B but keeping changes..."
  git reset --mixed $COMMIT_B
  echo "Done. The changes from C and D are now in your working directory."
}

task4() {
  echo "Switching to branch $BRANCH..."
  git checkout $BRANCH

  echo "Enter the commit hash for B (where you want to reset to):"
  read COMMIT_B

  echo "Are you sure you want to hard reset to $COMMIT_B? This will DELETE all changes after it. (yes/no)"
  read CONFIRM
  if [ "$CONFIRM" = "yes" ]; then
    git reset --hard $COMMIT_B
    echo "Done. Everything after $COMMIT_B is gone locally."
  else
    echo "Aborted."
  fi
}

echo "Git Fix Helper Script (Beginner Edition)"
echo "Branch: $BRANCH"
echo "1) Revert commit D with a new commit"
echo "2) Remove last commit E but keep changes"
echo "3) Temporarily undo C and D but keep changes"
echo "4) Hard reset to B and delete everything after it"
echo "Choose a task number:"
read TASK

case $TASK in
  1) task1 ;;
  2) task2 ;;
  3) task3 ;;
  4) task4 ;;
  *) echo "Invalid option." ;;
esac

echo "All done! Remember to test and push changes if needed."