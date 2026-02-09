# Sentinel's Journal

## 2026-02-06 - Unsafe Update Sequence
**Vulnerability:** The macOS updater removed the existing application before verifying the integrity of the downloaded update. Furthermore, code signature verification failure was only logged as a warning, allowing installation of potentially compromised code.
**Learning:** Checking integrity *after* destructive actions leaves users vulnerable to denial-of-service (broken app) or compromise. Warnings are insufficient for critical security checks.
**Prevention:** Perform all integrity and security checks on the new artifact (e.g., inside the mounted DMG) *before* touching the existing installation. Enforce strict exit on verification failure. Use `ditto` for app bundles to preserve attributes and reject symlinked sources to prevent path traversal attacks.

## 2024-05-22 - Unsafe JSON Parsing via Eval
**Vulnerability:** The Bash updaters used `eval` on Python output (`PARSE_ASSIGNMENTS`) to set shell variables. This pattern allows Remote Code Execution (RCE) if the Python script is manipulated or if `shlex.quote` fails to properly escape certain inputs, or if the Python script errors and outputs unexpected content.
**Learning:** Generating shell assignments and `eval`-ing them is inherently risky because it executes arbitrary code. Relying on correct escaping in Python is fragile.
**Prevention:** Avoid `eval` for variable assignment. Instead, print raw values from the helper script (one per line or delimited) and read them directly into variables using `head`, `tail`, or `read`.
