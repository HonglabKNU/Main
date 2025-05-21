# Before start
### This repo is based on MacOS 
__You need to make new virtual environment on your computer.__   
[You can download anaconda3 from here](https://www.anaconda.com/download)

1. Make new directory for using project.
2. Download ``environment.yml`` in the project folder.
3. Turn on 'Terminal' from Mac. Then, enter this command to change directory.
 ```bash
 cd 'your folder name'
 ```

4. Create new environment. Enter this command.

```bash
conda env create -f environment.yml 
conda activate Honglab3.9
```

---
# MsigDB_search function is added

---
Please download ``MsigDB_search.R`` and copy-paste the script
> [!IMPORTANT]
> You need to install following packages
```R
install.packages(c("shiny", "DT","DBI", "RSQLite", "dplyr", "jsonlite"))
```
---

> [!NOTE]
> How to use.

1. ``msigdb.search()``
```R
msigdb.search("species")
```
``species`` must be text type. Enter "Hs" or "Mm" (human or mouse)

##### __Sequence__
1️⃣ Select → 2️⃣ Add → 3️⃣ Export

Then, the vector of gene sets' name will be exproted.
Also, you can export the list with .csv format.

2. ``msigdb.browse()``
```R
msigdb.browse("species", name)
```
``species`` must be text type. Enter "Hs" or "Mm" (human or mouse)
``name`` must be vector type. You can type your own gene sets or load gene sets by ``msigdb.search()``
