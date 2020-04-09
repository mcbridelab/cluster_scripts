## McBride Lab scripts

To download this repository (e.g. in your home directory):
`git clone https://github.com/mcbridelab/cluster_scripts.git`

Then add it to the PATH in to your [bashrc](https://unix.stackexchange.com/questions/129143/what-is-the-purpose-of-bashrc-and-how-does-it-work) file to make sure you can use the scripts, as follows: 

Use nano to open the file
`nano ~/.bashrc`
and add 
`export PATH=~/cluster_scripts:$PATH`
to the end of the file (it may be empty if you've never edited it before). You'll have to press `CTRL-X` then `Y` to save your changes. This tells the system to look for scripts in the shared lab directory first.

Use [git](https://guides.github.com/introduction/git-handbook/) to upload any new scripts or track and modifications you make. Here's a quick [tutorial](https://www.katacoda.com/courses/git).

These are mostly bash scripts (.sh) that can be run on the cluster using slurm. That means they should generally start with `#!/bin/bash` often followed by instructions for the slurm scheduler e.g. `#SBATCH -N1 -c1 -t2:00:00`. After that, leave a line explaining how to use the script, and another with the name of the author. For example:
```
#!/bin/bash
#SBATCH -N1 -c1 -t2:00:00
#Usage hello.sh NAME
#by Noah Rose
echo "Hello $1"
```
Note: if you write a new script you will have to [make it executable](https://stackoverflow.com/questions/8779951/how-do-i-run-a-shell-script-without-using-sh-or-bash-commands) to run without calling bash directly

If you are putting together a more complicated pipeline involving multiple scripts, consider documenting it in a markdown file like this. Look at the code generating this README for examples of how to use markdown to document a series of steps, or use this [cheat sheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#links).
