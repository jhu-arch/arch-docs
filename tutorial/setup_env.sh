#!/bin/bash

# This is an How to do Reproducible Research into The Rockfish cluster.

# NOTE:
#      1. singularity containers cannot run from a scratch folder
#      2. Volume path (singularity BIND) must be absolute

salloc -J interact -N 1-1 -n 4 --time=1:00:00 -p defq srun --pty bash

ml python/3.9.0
python3 -m venv ~/venvs/rf_snakemake_trainning

source ~/venvs/rf_snakemake_trainning/bin/activate

python3 -m pip install --upgrade pip

pip3 install git+https://github.com/ricardojacomini/rf.git --upgrade --force
pip3 install graphviz --upgrade

curl -s https://raw.githubusercontent.com/ricardojacomini/rf/master/scripts/install_tree_non_root.sh | bash

cat > ~/.local/bin/rc << EOF
#!/bin/bash
if [ ! \$# -eq 0  ]; then
    echo "\$1" | tr "[ATGCatgc]" "[TACGtacg]" | rev
else
    echo ""
    echo "usage: rc DNASEQUENCE"
    echo ""
fi
EOF

chmod +x ~/.local/bin/rc

mkdir $HOME/snakemake_rf_training/; cd $HOME/snakemake_rf_training/

git init
git remote add -f origin https://github.com/ricardojacomini/arch-tutorial.git

# sparse checkouts
git config --global core.sparsecheckout true

echo "tutorial/*" >> .git/info/sparse-checkout

# fetch the files from the remote Git repository
git pull origin main

# How to do Reproducible Research,
# see more details used in this tutorial in:

# http://marcc.rtfd.io

https://marcc.rtfd.io/RF.html
https://marcc.rtfd.io/Snakemake.html

https://snakemake.readthedocs.io/en/stable/tutorial/basics.html
https://snakemake.readthedocs.io/en/v3.10.1/getting_started/examples.html
