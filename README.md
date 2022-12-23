# calc_infix2rpn, an Infix to Reverse Polish Notation (RPN) Compiler written in C++

[Original document location](https://jausoft.com/cgit/cs_class/calc_infix2rpn.git/about/).

## Git Repository
This project's canonical repositories is hosted on [Gothel Software](https://jausoft.com/cgit/cs_class/calc_infix2rpn.git/).

## Goals
This project demonstrates most elements of compiler design using C++
- lexigraphical scanner via `flex` producing a token stream for 
- grammar parser via `bison` producing the intermediate representation (IR), here the actual RPN 
- semantic optimization of the IR (RPN in our case)
- last but not least, allows to use the RPN - naturally

We test two lex-scanner generator in this little project, `flex` and `RE/flex`,
together with the `bison` parser generator.

## Supported Platforms
C++20 and better where [bison](https://www.gnu.org/software/bison/manual/) and 
[Re-flex](https://github.com/Genivia/RE-flex) or [flex](https://github.com/westes/flex) 
is supported.

## Building Binaries

### Build Dependencies
- CMake 3.13+ but >= 3.18 is recommended
- C++20 compiler
  - gcc >= 10
  - clang >= 15
- Parser generator
    - [bison >= 3.2](https://www.gnu.org/software/bison/manual/) 
      - using the C++ interface
      - small code footprint
- Lexer generator
    - [flex](https://github.com/westes/flex)
      - using the C-interface with our `prefix` and `reentrant`
      - smallest code footprint experience
    - [Re-flex >= 3.2.3](https://github.com/Genivia/RE-flex) **optional**
      - using the C++ interface (only option)
      - hacked RTTI away, i.e. `dynamic_cast` -> `static_cast`.
      - code footprint a bit excessive due to its library
- Optional for `lint` validation
  - clang-tidy >= 15
- Optional for `vscodium` integration
  - clangd >= 15
  - clang-tools >= 15
  - clang-format >= 15


Installing build dependencies on Debian (11 or better):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{.sh}
apt install git
apt install build-essential g++ gcc libc-dev libpthread-stubs0-dev 
apt install clang-15 clang-tidy-15 clangd-15 clang-tools-15 clang-format-15
apt install cmake cmake-extras extra-cmake-modules pkg-config
apt install bison flex
apt install doxygen graphviz
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Perhaps change the clang version-suffix of above clang install line to the appropriate version.

After complete clang installation, you might want to setup the latest version as your default.

Since [Re-flex](https://github.com/Genivia/RE-flex) (**optional**) 
is not yet provided in a Debian distribution, it must be manually installed as described in its repository (**easy**)
and will be picked up if found.

### Build Procedure
The following is covered with [a convenient build script](https://jausoft.com/cgit/cs_class/calc_infix2rpn.git/tree/scripts/build.sh).

For a generic build use:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{.sh}
CPU_COUNT=`getconf _NPROCESSORS_ONLN`
git clone --recurse-submodule git://jausoft.com/srv/scm/cs_class/calc_infix2rpn.git
cd calc_infix2rpn
mkdir build
cd build
cmake ..
make -j $CPU_COUNT install doc
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Our cmake configure has a number of options, *cmake-gui* or *ccmake* can show
you all the options. The interesting ones are detailed below:

Changing install path from /usr/local to /usr
~~~~~~~~~~~~~
-DCMAKE_INSTALL_PREFIX=/usr
~~~~~~~~~~~~~

Building debug build:
~~~~~~~~~~~~~
-DDEBUG=ON
~~~~~~~~~~~~~

Building with clang and clang-tidy `lint` validation
~~~~~~~~~~~~~
-DCMAKE_C_COMPILER=/usr/bin/clang 
-DCMAKE_CXX_COMPILER=/usr/bin/clang++ 
-DCMAKE_CXX_CLANG_TIDY=/usr/bin/clang-tidy;-p;$rootdir/$build_dir
~~~~~~~~~~~~~

To build documentation run: 
~~~~~~~~~~~~~
make doc
~~~~~~~~~~~~~

### IDE Integration

#### Eclipse 
IDE integration configuration files are provided for 
- [Eclipse](https://download.eclipse.org/eclipse/downloads/) with extensions
  - [CDT](https://github.com/eclipse-cdt/) or [CDT @ eclipse.org](https://projects.eclipse.org/projects/tools.cdt)
  - `CMake Support`, install `C/C++ CMake Build Support` with ID `org.eclipse.cdt.cmake.feature.group`

You can import the project to your workspace via `File . Import...` and `Existing Projects into Workspace` menu item.

For Eclipse one might need to adjust some setting in the `.project` and `.cproject` (CDT) 
via Eclipse settings UI, but it should just work out of the box.

#### VSCodium or VS Code

IDE integration configuration files are provided for 
- [VSCodium](https://vscodium.com/) or [VS Code](https://code.visualstudio.com/) with extensions
  - [vscode-clangd](https://github.com/clangd/vscode-clangd)
  - [twxs.cmake](https://github.com/twxs/vs.language.cmake)
  - [ms-vscode.cmake-tools](https://github.com/microsoft/vscode-cmake-tools)
  - [notskm.clang-tidy](https://github.com/notskm/vscode-clang-tidy)
  - [cschlosser.doxdocgen](https://github.com/cschlosser/doxdocgen)
  - [jerrygoyal.shortcut-menu-bar](https://github.com/GorvGoyl/Shortcut-Menu-Bar-VSCode-Extension)

For VSCodium one might copy the [example root-workspace file](https://jausoft.com/cgit/cs_class/calc_infix2rpn.git/tree/.vscode/calc_infix2rpn.code-workspace_example)
to the parent folder of this project (*note the filename change*) and adjust the `path` to your filesystem.
~~~~~~~~~~~~~
cp .vscode/calc_infix2rpn.code-workspace_example ../calc_infix2rpn.code-workspace
vi ../calc_infix2rpn.code-workspace
~~~~~~~~~~~~~
Then you can open it via `File . Open Workspace from File...` menu item.
- All listed extensions are referenced in this workspace file to be installed via the IDE
- The [local settings.json](.vscode/settings.json) has `clang-tidy` enabled
  - If using `clang-tidy` is too slow, just remove it from the settings file.
  - `clangd` will still contain a good portion of `clang-tidy` checks

