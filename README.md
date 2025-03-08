# Vexel

<div align="center">

![Zig Version](https://img.shields.io/badge/zig-v0.14.0-orange?style=flat&logo=zig)
![GitHub Tag](https://img.shields.io/github/v/tag/freitaseric/vexel?sort=semver&label=version)

</div>
<div align="center">

![GitHub Repo stars](https://img.shields.io/github/stars/freitaseric/vexel)
![GitHub forks](https://img.shields.io/github/forks/freitaseric/vexel)

</div>

> [!CAUTION]
> This project is for study purposes only, using it in real situations is not recommended or encouraged!

**Vexel** is a simple browser engine implemented in [Zig](https://ziglang.org) for learn about this concept.

<!-- omit in toc -->
## Table Of Contents
- [Vexel](#vexel)
  - [Contributing](#contributing)
  - [Development](#development)
    - [Prerequisites](#prerequisites)
    - [Building and Running](#building-and-running)
  - [License ](#license-)
  - [Contributors ](#contributors-)

## Contributing

You may contribute for this project by one of this way:

- Opening an issue and recommending some article, book or any content about _Browser Engining_.
- Opening a pull request adding some improvement for the project.

All such contributions are welcome, and respect and patience in issues or pr are required!
  
## Development

### Prerequisites

- A [zig compiler](https://ziglang.org/learn/getting-started/) in version 0.14.0.
- A text editor or an IDE of your choice. I recommend you to use [Visual Studio Code](https://code.visualstudio.com) with [Zig Language](https://marketplace.visualstudio.com/items?itemName=ziglang.vscode-zig) extension.
- Some knowledge in low-level programming and in the Zig programming language.

### Building and Running

To build this project you can use the command above:
```shell
$ zig build
```
Now all binaries of the project can be found at `zig-out/bin` and the main library can be found at `zig-out/lib`.

> [!TIP]
> After successfully build the project, you should run the main binary to check if all works.
> 
> ```shell
>  $ ./zig-out/bin/vexel
> ```

To run **Vexel** you may run the following command:
```shell
$ zig run src/main.zig
```
> [!NOTE]
> This command will print to the console the content of a struct `Node` containing a element named `html`.

> [!TIP]
> You also can run the project tests for grant all functions and structs are work correctly.
>
> ```shell
> $ zig test
> ```

## License ![GitHub License](https://img.shields.io/github/license/freitaseric/vexel)


This project is licensed by [GNU General Public License 3.0](https://spdx.org/licenses/GPL-3.0-or-later.html) that can be found on the [LICENSE](./LICENSE) file.

## Contributors ![GitHub contributors](https://img.shields.io/github/contributors/freitaseric/vexel)


- [@freitaseric](https://github.com/freitaseric) - `founder` and `maintainer`