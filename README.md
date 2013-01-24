# Real World Git

The idea of this repo is to teach you a few basic concepts when using git, with
a real github repository and the whole workflow.

## NOTE

This is a WIP! - NOT YET COMPLETE

## Disclaimer

As I see it, there is no *right* workflow. Some of them are better suited for
some teams, some are better for others. This is one of the workflows I like and
it seems to me that is the one that provides great benefits for most of the
cases.

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

First, get a [github][github] account, they're cheap (free) if you're just using
them for open source projects. For this tutorial, it's ok to just use a free
account.

Once you have your account ready, you need to decide a path: this tutorial will
offer always two explanations: using the github client (for mac and windows,
qwhen there's a difference) and *only* using the CLI git client, which is
included by default for mac os x and shipped with the
[windows client][gh-windows] for github. Bottom line: if you're under windows,
and unless you really know what you're doing, for now it would be best if you
just install the [github windows client][gh-windows]. It will install everything
required to complete this tutorial. If you're on mac os x or linux, you can use
just the command line if you feel comfortable, or a GUI client, like
[GitX (L)][gitx-l].

There are some things that are either too cumbersome to do in the current GUI
clients, so we will use the CLI client for some parts.

### Forking

Ok, now that you're ready, it's time to fork your first project, this particular
project. So go ahead and point your browser to the [repo url][rwg], sign in with
your account and fork the project to your account, using the `Fork` button on
the top right. If you belong to an organization, then Github will ask you to
which account you want to fork it, for our case, just pick your username and
you're done.

![Repo][rwg-img]

Now you should have a new fork of the project, under your name. The url is the
same but instead of `funkaster` it should say your username.

![Fork][fork-img]

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

For the github client, just open the client, refresh the list of projects under
the github section and click the clone button (it appears only when you hover
your mouse over the project name). After that, github should place a local clone
in your computer in a special place under your home directory. For windows, the
default is in the Documents directory.

![GH-clone][gh-clone-img]

Whichever way you did it, you should end with a local clone, which you can start
hacking into :) - Good job!

### Before hacking - Setting upstream

Before start hacking, we need to tell our local clone to keep an eye on the main
project (the original project from which you forked). To do this, you need to go
to the shell/terminal and cd into the project. One good thing about the shell
installed by github, is that it will open by default on the right directory. So
you should just do something like this:

NOTE: through here on, the `$` character represents the prompt in your shell.

```sh
$ cd realworldgit # or wherever you placed your local clone
$ git remote add upstream git://github.com/funkaster/realworldgit.git
$ git remote -v
origin  git@github.com:yourusername/realworldgit.git (fetch)
origin  git@github.com:yourusername/realworldgit.git (push)
upstream      git://github.com/funkaster/realworldgit.git (fetch)
upstream      git://github.com/funkaster/realworldgit.git (push)
```

The last command shows that you have the two remotes, the first is `origin`, which
represents your fork and the upstream, which represents the original clone.

The URL I used there is the url given in the [main page][rwg] of the project,
when you click in the `Git Read-Only` tab. It's always a good idea to have
upstream as read-only unless you really know what you're doing :)

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

### CLI version (recommended)

*NOTE*: if you intend to perform these steps in the github client, don't execute
the commands in this section, because you will leave your repo in a _clean_
state and you won't be able to commit from the github client unless you make
another change.

Go back the your terminal/shell and make sure you're on the root of your repo.

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

For the commit message, if needed I try to use [Markdown][markdown] syntax: they
look good on github.

### Github client version

Although we're going to do the same as before, for simple commits the workflow
is highly simplified with the github client. Even if you intend to use only
the github client, I recommend you read the CLI version to understand what we're
doing.

NOTE: if you already did the CLI version, you might not be able to perform the
following steps, because you already commited your changes and now your repo
should be _clean_.

If you go to the github client, and click in your local clone (the blue arrow
next to the repo name), github will show you that you have 1 file "to be
commited".  If you followed the instructions above, this means that you have 1
file that has not been staged.

If the changes are small, github client will show you the _diff_ together with a
commit pane to the right. Go ahead and write a commit message *following the
best practices* described in the previous sections and click the commit button.

![GH-commit][gh-commit-img]

Easy, right? Sure it is :)

While tempting, if you plan to be really serious about using git, I highly
recommend using the CLI as much as you can. There are several things that are
not yet able to be done in the GUI. There are, however, other clients that are
more powerful, but those are outside the scope of this tutorial. Having said
that, I encourage you to go ahead and explore them all if you can/want, but my
personal opinion is that using the cli will give you enough control and
flexibility.

In my day-to-day work, I use a mix of GitX(L) and the cli. The only reason I use
GitX(L) is to be able to make commits by hunks easier (more on that later), but
for pushing, pulling, merging, rebasing, etc. I relly solely on the cli.

## Pushing your changes and preparing a patch

Ok, now you have your first commit ready, but if you go to your fork page, you
won't see the log for your first commit, why? As I mentioned before, `git` is a
distributed VCS, and as such, changes occuring in your local clone are
independent of what is in the fork (the remote clone). But fear not, you can
synchronize them both in a safe manner: git provides the commands `push` and
`pull` to easily send your changes to a remote clone and to _fetch_ the changes
from the remote repo and _merge_ them into your changes. So let's do that.

### CLI version

Go back to your shell/terminal. Again, don't execute this code if you intend to
follow the github client version:

```sh
$ git push origin master
```

What this command is doing is: push the changes that are in my repo, in the
current branch to the branch `master` of the `origin` repo. By default, when you
clone a repo git creates a default remote branch, the `origin`. We saw that when
we executed the `git remote -v` command when adding the upstream remote.

Hopefully, everything went well. You can now reload your project page in github
and you should see that the last commit there is the one that you have just
created. Well done!

### Github client version

In your github client, in the realworld repo, just click the `sync` icon. This does
a few more things that the cli version. But we will skip over them for now.

### Preparing the patch

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
`0001-what-you-wrote-on-your-commit.patch`. We can now safely send this file to
the maintainer of the upstream repo so he can merge it (not without testing it
first!).

But this is a very simple case, most of the time you will send a patch with more
than one commit. In that case you can just concatenate the patches in one file
or do something more interesting, like _squashing_ all your commits in a single
commit. We will also see that technique later.

*NOTE*: to concatenate the patches from the shell/terminal, you can use the
`cat` utility, like so:

```sh
cat *.patch > single.patch
```

That will take all the files with a `.patch` extension and join them in the
`single.patch` file. That is one way to do it, but make sure first that there
are no unwanted files with a `.patch` extension before running this, otherwise
your concatenated patch might be corrupted.

The github way is really simple and is one of the facts that has made github so
popular: the pull request. Just open your browser and go to your fork, and click
the `Pull Request` button. That will take you to the Pull Request (PR) page and
you will be able to select which branch from your fork will be merged in which
branch of the upstream repo. In this case is master from your fork into master
of the upstream repo.

![Pull Request][pr-img]

In that interface, you can write a title for your pull request. Please try to be
as descriptive as possible, without writing an essay on the title :) Usually you
want to follow the same principles than in the commit message.  However, the
body of the PR can be very extensive if needed. The PR is, most of the time,
translated in a discussion between the maintener(s) and the contributor.
Allowing for code-review and checking the code quality before merging the
changes.

In that same interface you can also see what files are you changing and how is
actually changing. You might want to review that before clicking the send button
to see that you're not issuing a PR for something that you don't want to merge.

If everything looks good, then go ahead and click the `Send Pull Request`
button.  That should take a few moments and github should redirect you to the
original repo page, in the `Pull Request` section.

Congratulations! you just made your first Pull Request!

After issueing the PR, the maintainer needs to review your code, he can comment
it and if he decides to do so (and if it doesn't introduces conflicts) he can
merge the PR from the github interface. This is very powerful and has allowed
many Open Source projects to collaborate with different contributors from all
around the world.

NOTE: if you actually sent a pull request, I'll do my best to try to merge them
as they arrive, but don't hold your breath, it might take one day, it might take
more than that, depending on my load.

![PR Merged][pr-merged-img]

## Keeping your fork updated

Ok, it's time to update your fork. I'm going to assume that the maintainer has
merged your pull request and there are some other changes from the original repo
that you might want to _fetch_.

Unfortunately for this (AFAIK) the github client won't work, so we need to go
back to our shell/terminal.

Here, we have two options. We can use the `pull` command, which would make
something very similary to a `fetch` and then a `merge`, or we can execute both
commands ourselves. I will opt for the latter, just to be verbose. Please note,
that just doing `fetch` will not make any changes in your repo, it will only
take whatever is new in `upstream` and store it in the "git database". The
`merge` command is the one that's actually modifying your repo and taking the
changes in `upstream/master`, that is, the branch `master` in the remote
`upstream` and applying the changes on top of the _HEAD_ of your latest change.

*ED-NOTE* It would be interesting at this point to add references to some
internal parts of git. Reader: you might want to check the [git book][git-book-basics].

```sh
$ git fetch upstream
$ git merge upstream/master
```

## Branches

Being able to create and switch branches with ease is one of the biggest
advantages in git. Branches are something you should use all the time to keep
your work clean.

Let me explain a little bit what are branches, but before that I would like to
explain just briefly how git stores the data.

As opposed to other VCS, git stores its data as _snapshots_ of the current state
of your project. It's like git it's taking a picture of the state at the moment
of your commit and storing that in a mini-filesystem
([Git Book][git-book-basics]). Those snapshots (the commits) are identified by a
_hash_, a 40 characters string that uniquely identifies a commit in the repo.  A
branch, in the git parlance can be thought of different points of view for the
repo. However, in the real sense, they are actually _pointers_ to a specific
commit, that means they are actually a window to a particular point in time for
your repo. But why are they called branches when they act more like pointers?
Because they can actually _branch_ (split) the changesets of your repo at some
point. Let me explain this with a diagram.

*NOTE* we need a better diagram.

Let's assume you have your repo at some state, and you're only using one branch,
the default `master` branch, then your repo looks like this.

```
[ master ]
    ↓
[ 343ffd ]
```

Here, `343ffd` is the imaginary last commit in your repo. Now let's assume you
create a new branch, called `awesome`, which will hold a very awesome feature in
your project.

```
[ master ]
    ↓
[ 343ffd ]
    ↑
[ awesome ]
```

Now the awesome branch and the master branch point to the same commit. How does
git know which branch are you currently watching? Because there's a special
branch used by git that points to the one being used, and it's called the
`HEAD`. Usually when you create a branch in git, it will move the `HEAD` pointer
to that branch, so in our scenario, it would look somethinglike this.

```
[ master ]
    ↓
[ 343ffd ]
    ↑
[ awesome ]
    ↑
[ HEAD ]
```

If you change branches, using `git checkout <branch_name>` will switch the
`HEAD` pointer, and will also reflect any changes in the _working directory_.

Now, continuing with the assumptions, let's assume you are in the awesome branch
and you make a new commit, adding the new feature. Your repo would look like
this.

```
[ master ]
    ↓
[ 343ffd ] ← [ abd24a ]
                 ↑
             [ awesome ]
                  ↑
              [ HEAD ]
```

Both, the `awesome` pointer and the `HEAD` one are now shifted and pointing to
the last commit.  The `master` pointer, however is still on the old state.

To continue our story, you now got a patch from a contributor and need to apply
it, but you don't want to do that in the `awesome` branch, because it has
nothing to do with that feature and one thing you do know is that you want to
keep things clean. So in order to apply the patch, you need to switch to the
master branch and apply it there.

```sh
$ git checkout master
$ ...
```

So, what does your repo looks like now?

```
              [ master ]
                  ↓
            ↙ [ 823bfd ]
[ 343ffd ]  
            ↖ [ abd24a ]
                  ↑
             [ awesome ]
                  ↑
              [ HEAD ]
```

This is the split I talked about. At this point, you have `master` and `awesome`
that point to different states, but share a common ancestor, `343ffd`. You can
extrapolate this to more branches and spinning off branches from other branches.

What are branches used for? You can actually used them for whatever you want. My
workflow usually is: work on `master` and if you need to fix a bug, create a
branch, work there and then merge the branch back to master. Same with small
features.

If more than one developer are working on the same feature, they may want to work
on the same branch. You can do that by _publishing_ your branch on a remote repo
and then letting the other developers about that branch. We will cover that
later in the tutorial.

*ED-NOTE* need to remember to actually add that example.

Enough talk, this is *real world git*, so let's get our hands on it.

First, we're going to create a new branch.

```sh
$ git checkout -b awesome master
Switched to a new branch 'master'
```

The command to create a new branch, is the same command used to switch branches:
[checkout][git-checkout].  It is also used for other things, but for now, we can
live with that definition. The `-b` option tells git to create a new branch, and
the optional `master` argument, tells git to use that pointer as the
reference. If you omit the last argument, it will use whatever branch HEAD is
pointing to. As a bonus, git also changes HEAD to point to the newly created
branch.

```sh
$ git branch
* awesome
  master
```

The `branch` command lists the current local branches, and it shows you which
one HEAD is pointing to, by placing an asterisk ('*') before the name. In this
case, HEAD is pointing to `awesome`, as we expected to.

Ok, now let's add a new "feature". Inside the `branch_test` directory, create a
new file, with the following convention.

* The file should be named as your github username and have a .txt extension
* Inside the file, you can put whatever you want as long as it is less than 256
  bytes. Please try to avoid profanity :)

Now that you have the file, we can _stage_ it and _commit_ the changes to the
repo, just as we did before.

```sh
$ git add branch_test/yourusername.txt
$ git commit
(edit the commit message, save and exit the editor)
 1 file changed, 1 insertion (+)
 create mode 100644 branch_test/yourusername.txt
```

Great. Now we can run some more tests if necessary or just check that everything
is ok. If applies, you could even build a binary and send it to QA. If you find
out that everything is ok, then you are now ready to merge your changes into the
master branch.

```sh
$ git checkout master
$ git branch
  awesome
* master
```

As you can see, the asterisk marks the current branch (the branch to which HEAD
is pointing to) and we can safely bring over the changes from awesome to master.
But before doing so, you might want to make sure you have a fairly recent
version of master, in order to minimize the chances of a conflict.

```sh
$ git fetch upstream
$ git merge upstream/master
```

Now, can we merge our awesome branch? Not yet. At this point, I would like to
open a small discussion around a very powerfull feature of git, the
[rebase][git-rebase]. Rebase is a very, very powerfull command in git, but also
very complex (you know what they say, "with great power, comes great
responsibility"). Basically what rebase allows you to do is to modify (rewrite)
history from your repo. You usually want to do this because:

1. You screw up, and need to fix some things.
2. Because you want to keep a clean history.

Number 2 is the reason I want to introduce here, for number 1 there are tons and
tons of discussions on the internet about that. According to what
[Linus says][linus-rebase], what we want is *clean* & *history*. So that means
for you, a very important rule:

*ONLY USE REBASE ON CODE THAT HAS NOT SEEN THE LIGHT*

Why? because if you publish your code (push it to your fork, for instance) and
then run rebase, you will alter your history tree, and what will happen is that
when you push again, the changes you will need to push will modify the version
that was published, potentially producing lots of headaches. It is ok to run
rebase on your local fork, as long as you are running it on un-published code,
or unless you really know what you're doing.

But let's explain what does rebase do. To do that, let's go back to our diagrams
for your repo.

```
                           [ master ]
                               ↓
            ↙ [ 823bfd ] ← [ aba665 ]
[ 343ffd ]  
            ↖ [ abd24a ]
                  ↑
             [ awesome ]
                  ↑
              [ HEAD ]
```

Let's assume now, that with the state in the diagram, you want to bring your
changes from the awesome branch to master. Once in the master branch, you would
run the `git rebase awesome` command (do not run it yet!).

What rebase does, is to _rewind_ your changes all the way until a common
ancestor in the tree, apply whatever changes you have in awesome and then it
applies the rest of the changes.  What happens is that your tree will look like
this.

```
                                         [ HEAD ]
                                            ↓
                                        [ master ]
                                            ↓
[ 343ffd ] ← [ abd24a ] ←  [ 00bf32 ] ← [ 882ac3 ]
                 ↑
            [ awesome ]
```

Truth be told, I've simplified *a lot* how things work, but you get the idea :),
which is that the tree got modified: `823bfd` (now `00bf32`) was previously
pointing to `343ffd` as a parent, now is pointing to the last commit in awesome,
which is `abd24a`. Since we rewrote history, commits also change their hash. You
can always read the whole (unrated & unedited) story in the
[official documentation][git-rebase].

Now, let's try to apply that to our repo.

```sh
$ git checkout awesome
$ git log --oneline -2 # shows only the last two commits
0dff283 adding my branch-test file
c0ac58b adds branch_test directory # this will be the common ancester
$ git checkout master
$ git log --oneline -2
c0ac58b adds branch_test directory # see? right here
1c96575 minor edit in text
$ git rebase awesome
...
$ git log --oneline -2
0dff283 adding my branch-test file
c0ac58b adds branch_test directory
```

So what happens here, is that it since our case was a bit simpler, we didn't
actually have to rewind, because we were already sitting in the point where the
two branches had split. What we can see however, is that master now shares the
same history than the awesome branch. At this point, we can run some more tests,
build another binary for QA and if all goes well, delete the awesome branch.

```sh
$ git branch -d awesome
```

The command `branch -d` will remove a branch, only if it was merged. This can be
considered a "safe" delete, since no change will be lost. If you really want to
delete an unmerged branch, use the `-D` flag.

Now you might want to send another pull request to publish your changes, or
another patch.

[github]: https://github.com
[gh-windows]: http://windows.github.com
[gitx-l]: http://gitx.laullon.com
[rwg]: https://github.com/funkaster/realworldgit
[markdown]: http://daringfireball.net/projects/markdown
[git-book-basics]: http://git-scm.com/book/en/Getting-Started-Git-Basics
[rwg-img]: https://raw.github.com/funkaster/realworldgit/master/images/realworldgit.png
[fork-img]: https://raw.github.com/funkaster/realworldgit/master/images/fork.png
[gh-clone-img]: https://raw.github.com/funkaster/realworldgit/master/images/clone.png
[gh-commit-img]: https://raw.github.com/funkaster/realworldgit/master/images/commit.png
[pr-img]: https://raw.github.com/funkaster/realworldgit/master/images/pullrequest.png
[pr-merged-img]: https://raw.github.com/funkaster/realworldgit/master/images/pr-merged.png
[git-checkout]: http://www.kernel.org/pub/software/scm/git/docs/git-checkout.html
[git-rebase]: http://www.kernel.org/pub/software/scm/git/docs/git-rebase.html
[linus-rebase]: http://www.mail-archive.com/dri-devel@lists.sourceforge.net/msg39091.html
