# The Rockfish Cluster at The Advanced Research Computing at Hopkins (ARCH)

Introduction and How-to on the Rockfish Cluster to the Advanced Research Computing at Hopkins ( `ARCH` ) – formerly known as `MARCC` – is a shared computing facility at Johns Hopkins University that enables research, discovery, and learning, relying on the use and development of advanced computing. ARCH administers State-of-the-art high performance computing resources, manages highly reliable data storage, and provides outstanding collaborative scientific support to empower computational research, scholarship, and innovation.

`ARCH` is supported by:

![](images/NSF.png)
![](images/DOD.png)
![](images/jhu_logo.png)

This is a software guide and tutorials used in training sessions to The Rockfish cluster at `ARCH`, for more details:

* **`HELP`**: mail to help@rockfish.jhu.edu (ticketing system)
* Portal: https://coldfront.rockfish.jhu.edu/
* Website: https://www.arch.jhu.edu/
* User Guide: https://www.arch.jhu.edu/access/user-guide/
* Terms of Use: https://www.arch.jhu.edu/access/jhu-user-accounts/terms-of-use/
* Rockfish Citizen:  https://www.arch.jhu.edu/access/jhu-user-accounts/rockfish-citizen/

# Contributing Changes to the Repository

To clone, create a branch, push changes, and open a pull request targeting the `new_cluster` branch:

```bash
# Clone (or update) your fork and create a feature branch
git clone https://github.com/YOUR_USERNAME/arch-docs.git
cd arch-docs
git checkout -b my-feature-branch new_cluster

# Make your changes, then commit and push
git add <files>
git commit -m "Describe your changes"
git push origin my-feature-branch
```

Then open a pull request on GitHub from `my-feature-branch` to `etpalmer63:new_cluster`.

To keep your local `new_cluster` branch up-to-date:

```bash
git checkout new_cluster
git fetch origin
git pull origin new_cluster
```

# Building the Documentation

The documentation is built with Sphinx and uses a virtual environment in `.docs_env/`.


To build the virtual environment:

```bash
python -m venv .docs_env/
source .docs_env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

To build the HTML output:

```bash
cd arch-docs
source .docs_env/bin/activate
make html
```

This generates the documentation under `_build/html/`. View it by opening `_build/html/index.html` in a browser, for example:

In Ubuntu:

```bash
xdg-open _build/html/index.html
```

Or:

```bash
google-chrome _build/html/index.html
```
Alternatively, you can simply open `index.html` in a browser.



To rebuild from a clean state (removing previous output):

```bash
make clean
make html
```
