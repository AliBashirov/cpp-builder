# C++ Builder

A simple **C++ build tool** with a terminal-based interface (TUI) to compile and run C++ code quickly.  
Perfect for small projects, demos, or learning purposes.

---

## ⚡ Features

- **One-Command Compilation**: Compile and run C++ programs instantly.
- **Multi-Language Support**: Optional support for Java and Python.
- **TUI Interface**: Quick navigation for a smoother terminal experience.
- **Minimal Setup**: Lightweight and fast execution.
- **Command Flags**:
  - `-co` → **Compiler only**: Compiles your code but doesn’t run it.
  - `-case` → **Test Cases**: Uses input/output files (`in.case` / `in.out`) to test your program.

---

## 💻 Requirements

- Linux, macOS, or Windows (via WSL or terminal)
- `g++` (for C++ compilation)

---

## 🛠️ Installation

### 1. Clone the repository

```bash
git clone [https://github.com/AliBashirov/cpp-builder.git](https://github.com/AliBashirov/cpp-builder.git)
cd cpp-builder
```

### 2. Add the folder to PATH

Replace `/full/path/to/cpp-builder` with the actual path where you cloned the repository.

**Bash:**
```bash
echo 'export PATH="$PATH:/full/path/to/cpp-builder"' >> ~/.bashrc && source ~/.bashrc
```

**Zsh:**
```bash
echo 'export PATH="$PATH:/full/path/to/cpp-builder"' >> ~/.zshrc && source ~/.zshrc
```

**Fish:**
```bash
set -U fish_user_paths /full/path/to/cpp-builder $fish_user_paths
```

---

## ⚙️ Usage

**Note:** Flags must be placed **before** the filename.

### Basic usage
```bash
cpp-builder filename.cpp
```

### Using Flags

**Compile only (doesn’t run):**
```bash
cpp-builder -co filename.cpp
```

**Use test cases from files (`in.case` / `in.out`):**
```bash
cpp-builder -case filename.cpp
```
*Make sure you have `in.case` (input) and `in.out` (expected output) in the same directory when using `-case`.*

**Combine flags if needed:**
```bash
cpp-builder -co -case filename.cpp
