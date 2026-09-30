# bibliographies

A single [GNU refer](https://www.gnu.org/software/groff/) bibliography
database, maintained here so that every one of my writing projects draws
citations from **one** source instead of its own drifting copy.

The whole database is in plain-text files like **`references.text`** and **`language-function.text`**.
It is UTF-8, and it is meant to be readable and hand-editable — no tooling is required to add or fix an entry.

There is a Makefile here for indexing the bibliographies.
It is used in the repositories that use this bibliography.

---

## The refer format in one minute

A bibliography is a sequence of **records** separated by a blank line.
Each record is a set of **fields**, one per line, beginning with `%` and a
single letter:

```
%A Anderson, Roy M.
%A May, Robert M.
%T Vaccination and herd immunity to infectious diseases
%J Nature
%V 318
%N 6044
%D 1985
%P 323\[en]329
```

The field letters used in this database:

| Field | Meaning                                              |
|-------|------------------------------------------------------|
| `%A`  | Author — one line per author, in citation order      |
| `%E`  | Editor — one line per editor                          |
| `%T`  | Title of the work                                     |
| `%B`  | Title of the book an article/chapter appears in       |
| `%J`  | Journal                                               |
| `%V`  | Volume                                                |
| `%N`  | Number / issue                                        |
| `%P`  | Pages                                                 |
| `%I`  | Publisher (issuer)                                    |
| `%C`  | City of publication                                   |
| `%D`  | Date (year)                                           |
| `%S`  | Series                                                |
| `%@`  | ISBN / ISSN                                           |
| `%O`  | "Other" — used here for URLs and DOIs                 |
| `%Q`  | Corporate / institutional author                      |
| `%K`  | Keywords                                              |
| `%X`  | Annotation / abstract                                 |
| `%Z`  | Local catch-all: import leftovers, extra links, notes |

Two local conventions worth knowing:

- **`%O` carries the link** (a DOI or URL), not `%U`.
- **`%Z` is a drawer**, not a real bibliographic field. It holds RIS-import
  residue (`ID`, `DA`, `DO`, `SN` …), spare URLs, and stray notes. A record
  may have several `%Z` lines. My format settings (below) throw it away at
  typesetting time, so it never reaches the page — it is kept only as data.

### One rule that will save you grief

Keep author names in a **consistent format** — I use `Surname, Given`.
Mixing `Surname, Given` and `Given Surname` in the database is legal and
refer will format either correctly, but any tool that groups or de-duplicates
on the surname can be fooled by the natural-order form. (This database was
built by merging twelve diverged copies, and the only entries that slipped
through de-duplication were precisely the ones written `Given Surname`.)

---

## How a document uses it

Citation style is configured **in the document**, inside an `.R1 … .R2`
block, which also names the database. A minimal version:

```
.R1
accumulate
database ./bib/references.text
.R2
```

My own block additionally sorts the reference list, abbreviates author
initials, prints an `Author (Year)` label, and discards the `%N %X %Y %Z`
fields at format time.

You then cite in the text by placing selection keywords between `.[` and
`.]`; refer looks them up in the database and inserts the reference:

```
Herd immunity has an epidemic threshold
.[
anderson may vaccination
.]
```

Build with refer preprocessing enabled (`-R`):

```
groff -R -ms document.ms > document.ps
```

---

## Using this repo as a submodule

Projects include this repo as a git **submodule** in a folder called `bib/`,
so the `database ./bib/references.text` path is the same on every machine —
no absolute paths, no symlinks.

Add it to a project:

```
git submodule add -b main https://github.com/siglun/bibliographies.git bib
```

**The one thing to remember:** a plain `git clone` of a project leaves `bib/`
*empty*, and refer will then fail to find the database. So clone projects
with:

```
git clone --recurse-submodules <project-url>
```

Already cloned the plain way? Populate the submodule after the fact:

```
git submodule update --init
```

Pull a newer bibliography into a project when you want one (submodules stay
pinned to a commit until you bump them deliberately — a feature, not a bug:
an old paper's references can't shift under you unasked):

```
git submodule update --remote bib
git add bib && git commit -m "Bump bibliography"
```

---

## Provenance

This database was consolidated from twelve per-project `references.text`
files that had diverged over years of copying from directory to directory.
The original twelve, and the little `collect-data.pl` that gathered them
(`find ~ -name references.text`), are in this repo's git history for anyone
curious about how such a mess accretes — and how it gets cleaned up.
