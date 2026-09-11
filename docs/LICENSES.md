# License Notices & Third-Party Attributions

## 1. Primary License
The ChessMaster monorepo, including all core libraries, curriculum catalog, interactive labs, content factories, video pipelines, and user interface applications, is licensed under the **MIT License**.

```
MIT License

Copyright (c) 2026 ChessMaster Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 2. Third-Party Licenses & Separation Architecture

### 2.1 Stockfish Chess Engine
- **License**: GNU General Public License Version 3 (GPLv3).
- **Architectural Boundary**: ChessMaster never compiles or links Stockfish statically into its MIT codebase. Integration is performed exclusively across standard process pipes using the Universal Chess Interface (UCI) protocol (`stdin`/`stdout`) or via an isolated Web Worker boundary in browser environments. This strict boundary maintains clean license separation. Stockfish source code and binaries remain governed by the GPLv3.

### 2.2 Dart SDK & Flutter Framework
- **License**: BSD 3-Clause License.
- **Copyright**: Google LLC and Flutter Contributors.

### 2.3 Historical Model Games & PGN Data
- Historical master games (e.g., Paul Morphy 1858, Jose Raul Capablanca 1924, Donald Byrne vs Bobby Fischer 1956, Akiba Rubinstein 1907) are non-copyrightable factual records of historical chess play in the public domain.
- All tactical annotations, curriculum exercises, and pedagogical questions bundled with ChessMaster are original works created specifically for this platform and distributed under the MIT license. No proprietary commentary from commercial publications is included.
