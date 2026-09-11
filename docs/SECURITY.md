# Security Model & Threat Mitigation

## 1. Security Architecture & Offline-First Privacy
ChessMaster is designed from the ground up as an offline-first platform. User game logs, diagnostic test results, self-analysis notes, and training metrics reside strictly on the user's local device (SQLite or browser IndexedDB). **No telemetry, user tracking, or unsolicited data transmission is ever executed.**

## 2. Threat Mitigation Matrix

| Vulnerability Vector | Threat Scenario | Mitigation Strategy in ChessMaster |
| :--- | :--- | :--- |
| **Malicious PGN Ingestion** | Stack overflow via deeply nested variations or regex denial-of-service (ReDoS) | Non-recursive token scanner; maximum variation depth capped at 30 levels; max PGN file size hard-capped at 25 MB. |
| **Malformed FEN Ingestion** | Memory corruption or array out-of-bounds via invalid rank counts | Strict character-by-character validation; rank count must equal exactly 8; square total must equal 64. |
| **FFmpeg Command Injection** | Arbitrary shell command execution via user-supplied profile names or metadata | FFmpeg CLI is invoked with explicit argument arrays (`Process.run(['ffmpeg', '-i', ...])`); never passed to a raw shell interpreter (`sh -c` or `cmd /c`). |
| **Directory Traversal** | Overwriting system files during video export or JSON backup import | All export paths are canonicalized and restricted strictly to the user's chosen directory or application sandbox; `../` patterns are stripped and rejected. |
| **Cross-Site Scripting (XSS)** | Injection of malicious scripts via PGN player headers or comments | All UI rendering uses Flutter's compiled Canvas/WASM pipeline; HTML interpretation is disabled; plain text strings are rendered via native canvas text painters. |
| **WASM Thread Isolation** | Spectre/Meltdown timing attacks in browser | Enforces Cloudflare Pages security headers: `Cross-Origin-Embedder-Policy: require-corp` and `Cross-Origin-Opener-Policy: same-origin`. |

## 3. Web Security Headers (`web/_headers`)
Deployed automatically on Cloudflare Pages Free:

```http
/*
  X-Frame-Options: DENY
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: camera=(), microphone=(), geolocation=()
  Cross-Origin-Embedder-Policy: require-corp
  Cross-Origin-Opener-Policy: same-origin
  Content-Security-Policy: default-src 'self'; script-src 'self' 'wasm-unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self' data:; connect-src 'self';
```

## 4. Secret & Dependency Auditing
- Monorepo dependencies are pinned to deterministic versions in `pubspec.yaml`.
- Automated CI workflows run `dart pub audit` to scan for known CVEs.
- Zero API keys or secrets are embedded into the client code.
