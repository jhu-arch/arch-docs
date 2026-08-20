# ARCH Clusters Documentation at Johns Hopkins

Introduction and documentation for the clusters managed by the **Advanced Research Computing at Hopkins** (`ARCH`) — formerly known as `MARCC` — a shared computing facility at Johns Hopkins University that enables research, discovery, and learning through advanced computing. ARCH administers state-of-the-art high-performance computing resources, manages highly reliable data storage, and provides collaborative scientific support to empower computational research, scholarship, and innovation.

`ARCH` is supported by:

![](images/NSF.png)
![](images/DOD.png)
![](images/jhu_logo.png)

This repository contains the Sphinx documentation for all ARCH-managed clusters, used for user guides, training sessions, and internal reference:

| Cluster   | Status       | Portal                                           |
|-----------|--------------|--------------------------------------------------|
| Rockfish  | Live         | https://coldfront.rockfish.jhu.edu/               |
| DSAI      | Live         | https://ai-coldfront.arch.jhu.edu/                |
| EDU Cluster | Live       | —                                                |
| SkipJack  | **Draft**    | URL TBD                                          |

## Quick Links

* **HELP**: mail to [arch@jhu.edu](mailto:arch@jhu.edu) (ticketing system)
* ARCH Website: https://www.arch.jhu.edu/
* Terms of Use: https://www.arch.jhu.edu/access/jhu-user-accounts/terms-of-use/
* Citizen Guidelines: https://www.arch.jhu.edu/access/jhu-user-accounts/rockfish-citizen/

## Cluster Overview

Each cluster has its own documentation directory under `1_Clusters/`:

* **Rockfish** (`1_Clusters/Rockfish/`) — CPU and GPU resources for general HPC workloads
* **DSAI** (`1_Clusters/DSAI/`) — AI/ML-focused system with NVIDIA A100, H100, L40S GPUs
* **EDU Cluster** (`1_Clusters/EDU_Cluster/`) — Teaching and educational computing resources
* **SkipJack** (`1_Clusters/SkipJack/`) — **New cluster documentation (TODOs need filling)**

Shared content lives in:

* **Common Tasks** (`2_Common_Tasks/`) — Bash quickstart, VPN setup, GPU computing guides
* **Tutorials** (`3_Tutorials/`) — Software, containers, environments, interactive sessions
* **Support** (`4_Support/`) — Terminology, citizen guidelines, citing ARCH, FAQ

## Contributing Changes to the Repository

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

## Building the Documentation

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

## TODOs in SkipJack Documentation

The SkipJack cluster documentation (`1_Clusters/SkipJack/`) is a template with **TODO** markers for cluster-specific information that still needs to be filled in. To find all remaining TODOs:

```bash
grep -rn "TODO" 1_Clusters/SkipJack/
```
