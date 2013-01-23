# Real World Git

The idea of this repo is to teach you a few basic concepts when using git, with
a real github repository and the whole workflow.

## NOTE

This is a WIP! - NOT YET COMPLETE

## Disclaimer

There is no *the right* workflow. I would argue there is no right workflow in
git, some of them are better suited for some teams, some are better for
others. This is one of the workflows I like and it seems to me that is the one
that provides great benefits for most of the cases.

But please, feel free to change it to suit your needs.

## What you will learn

* To fork a project
* Use the command line interface to add a remote (`upstream`) repo
* To work on your own local fork, while updating the `upstream`
* Produce patches to be shared back
* The Pull Request
* How to merge patches and how to merge a pull request
* Working on different branches
* Merging and rebasing

## Forking a project

### Setup

First, get a [github](https://github.com) account, they're cheap (free) if
you're just using them for open source projects. For this tutorial, it's ok to
just use a free account.

Once you have your account ready, you need to decide a path: this tutorial will
offer always two explanations: using the github client (for mac and windows,
qwhen there's a difference) and *only* using the CLI git client, which is
included by default for mac os x and shipped with the
[windows client](http://windows.github.com/) for github. Bottom line: if you're
under windows, and unless you really know what you're doing, for now it would be
best if you just install the
[github windows client](http://windows.github.com/). It will install everything
required to complete this tutorial. If you're on mac os x or linux, you can use
just the command line if you feel comfortable, or a GUI client, like
[GitX (L)](http://gitx.laullon.com/).

There are some things that are either too cumbersome to do in the current GUI
clients, so we will use the CLI client for some parts.


### Forking

Ok, now that you're ready, it's time to fork your first project, this particular
project. So go ahead and point your browser to the repo url
(https://github.com/funkaster/realworldgit), sign in with your account and fork
the project to your account, using the `Fork` button on the top right. Github
will ask to to which account you want to fork it (if you belong to an
organization), just pick your username and it should fork it to your account.

Now you should have a new fork of the project, under your name. The url is the
same but instead of `funkaster` it should say your username.

### Understanding Forks

Git is a decentralized version control system, this means there is no real
"central" repo, and every copy of the repo is usually named a "fork". Every fork
is a complete clone of the original repo, with all its history. This might be a
good thing or not, depending on what you expect, but most of the time it's a
good thing: you can work offline, you don't need to worry about blocking other
developers, or making history dirty.

This also means, if you come from a centralized VC system, you might need to
change a little bit your mentality: it's a very good thing in git to commit as
often as possible, and make your commits as atomically as possible. Even if this
means splitting changes in one file in several commits. That is something I
highly recommend and I'll show you how to do it.

Back to forks. Forks in github are actually remote clones: clones of one repo
that reside in the github's servers. You then need a local clone of that clone
in your computer in order to make changes. So finally, what resides in your
computer is a clone of a remote clone, which in turn is also a clone from some
repo. That last part is only true if you're working on a fork. If you're just
working on a project of your own, then what you have is just a local clone of a
remote repo. In the end, it doesn't really matter.

Now that the picture is more or less clear, you have to clone your recent fork
of the main project in order to start working. If you have the github client,
then it's really easy, just select the project from your list and make a local
clone.

If you want to use the command line, then on the main page of your fork, click
the ssh tab next to the url of the repo (it should change to something like
`git@github.com:yourusername/realworldgit.git`), then go to your terminal, cd to
some place safe (like ~/projects, or whatever...) and clone the repo:

```sh
git clone git@github.com:yourusername/realworldgit.git
```

Whichever way you did it, you should end with a local clone, which you can start
hacking into :) - Good job!

### Before hacking - Setting upstream

Before start hacking, we need to tell our local clone to keep an eye on the main
project (the original project from which you forked). To do this, you need to go
to the shell/terminal and cd into the project:

```sh
cd ~/projects/realworldgit # or wherever you placed your local clone
git remote add upstream git://github.com/funkaster/realworldgit.git
```

The URL I used there is the url given in the
[main page](https://github.com/funkaster/realworldgit) of the project, when you
click in the `Git Read-Only` tab. It's always a good idea to have upstream as
read-only unless you really know what you're doing :)

Ok, now you have the upstream ready. We will see soon how to update your local
clone and how to update your remote clone (the fork).

## Hacking this

Now we're finally ready. Your first job is to add your name to the list of git
learners. In the root of the project, there is a file named `learners.txt`.  Add
your name to the end of the file, following the convention in that file:

```
Your Name - your.email@domain.com
```

You can skip your email if you want, or add a comment. It's not really relevant
:) After you add your name there, we can start the simplest git flow: the
commit.

NOTE: through here on, the `$` character represents the prompt in your shell.

```sh
$ git status
...
$ git add learners.txt
$ git commit -m "adding myself!"
```

First things first. `git status` will tell you what's happening on your
clone. In this case it should show that there are _unstaged_ changes in your
clone, in particular in the learners.txt file. If you're using the github
client, it should show GITHUB_CLIENT.

What you need to know, is that git have different _states_ that will help you
organize your code. The first one is the _working directory_. This state is what
you see reflected in your filesystem. The next state is the _staging area_, this
is the intermediate step where you can group things that you're about to
commit. Finally, there's the _git directory_ (or the _repository_), which is the
actual stored data.

It works like this: you make changes in your _working directory_, you pick the
changes you want and _add_ them to the _stating area_ and finally you _commit_
your changes to the _repository_. If you can understand that flow, you have
understood big part of how git is supposed to work.

So what we did with the last two commands is to modify the learners.txt file,
add that file to the staging area (with all the changes we did) and commit that
file to the repository.

Every commit needs a _message_. In this case, we passed the message in the
command line, with the `-m` argument. If we do not pass that argument, git will
open your evironment editor (vi, emacs, nano, etc.) and ask you to write the
comment.

Keep the comments clean. There are guidelines, but again, git is very
flexible. I follow this rule:

* First line max. 50 chars. Be concise, try to explain what you're doing. "fix
  bug" is not concise, it's dumb :)
* If I need to write something else (90% of the times you don't need to), skip a
  line and then write whatever you need, always staying at max 72 char width.

(Reference:
http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)

For the commit message, if needed I try to use
[Markdown](http://daringfireball.net/projects/markdown/) syntax: they look good
on github.

## Pushing your changes and preparing a patch

Ok, now you have your first commit ready, but if you go to your fork page, you
won't see the log for your first commit, why? As I mentioned before, `git` is a
distributed VCS, and as such, changes occuring in your local clone are
independent of what is in the fork (the remote clone). But fear not, you can
synchronize them both in a safe manner: git provides the command `push` and
`pull` to easily send your changes to a remote clone and to _fetch_ the changes
from the remote repo and _merge_ them into your changes. So let's do that.

```sh
$ git push origin master
```

What this command is doing is: push the changes that are in my repo, in the
current branch to the branch `master` of the `origin` repo. By default, when you
clone a repo git creates a default remote branch, the `origin`.

Hopefully, everything went well. You can now reload your project page in github
and you should see that the last commit there is the one that you have just
created. Well done!

Now, you want to add your name to the official repo, so other learners can see
that you know how to commit and push changes to your remote clone. There are two
roads: one is to do it the non-github-way and the github-way :)

First, the non-github way, as it is harder. What we are going to do, is to
compare our repo with the original one, the one that we prepared before, named
`upstream`. While comparing, we will tell git to prepare a _patch_ so we can
send it to the maintainer of that project and he can _merge_ the changes. We
will have the opportunity to do that ourselves, because it's a part of the flow
that we need to learn, but that we'll leave that out for now.

Ok, so first get need to make sure we have an updated copy of the upstream repo.

```sh
$ git fetch upstream
```

What that will do is to _fetch_ all the changes that we don't have from the
upstream repo and store them locally. That process *will not* change anything in
our repository, however, we need that information to create the patch and to
update our copy of the repo.

Now the patch is prepared.

```sh
$ git format-patch upstream/master
```

That will extract all the commits that are in our current branch (master) but
not in the master branch in the upstream repo. In our case, we know it's only
one commit, so we will end with one new file named something like
`0001-something.patch`. We can now safely send this file to the maintainer of
the upstream repo so he can merge it (not without testing it first!).

But this is a very simple case, most of the time you will send a patch with more
than one commit. In that case you can just concatenate the patches in one file
or do something more interesting, like _squashing_ all your commits in a single
commit. We will also see that technique later.

The github way is really simple and is one of the facts that has made github so
popular: the pull request. Just go to your fork, and click the `Pull Request`
button. That will take you to the Pull Request (PR) page and you will be able to
select which branch from your fork will be merged in which branch of the
upstream repo. In this case is master from your fork into master of the upstream
repo.

A very common pattern is to create a new branch to work on a particular
feature/bug fix and send a PR from that branch. We will see that also.

After issueing the PR, the maintainer needs to review your code, he can comment
it and if he decides to do so (and if it doesn't introduces conflicts) he can
merge the PR from the github interface. This is very powerful and has allowed
many Open Source projects to collaborate with different contributors from all
around the world.

NOTE: if you sent a pull request, I'll do my best to try to merge them as they
arrive, but don't hold your breath, it might take one day, it might take more
than that, depending on my load.
