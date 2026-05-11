# SdkBuilder — Agent Instructions

## Project

V-language tool that parses V source files via `v ast`, then generates native SDKs (C#, planned: V/Python/PHP) consuming the compiled `.dll`/`.so`/`.dylib`. Output drops into `projects_sdk/` (gitignored).

## Build & Run

```sh
v run . "<path>/sdkbuilder.json"
```

- The CLI takes a single argument: path to a `sdkbuilder.json` config file.
- The V compiler must be on PATH. The tool also calls `v ast` and `v -check` internally, so a working V installation is required.

## Project Structure

```
main.v               — CLI entrypoint, calls builder_sdk.construct()
builder_sdk/          — Orchestrator: reads config JSON → gets AST → dispatches to generator
  builder_sdk.v
ast_v/                — Calls `v ast` on the V source file, parses JSON into entities
  get_ast.v
entities/             — Data models: Ast, Stmts, Fields, SdkBuilderConfiguration
  ast.v, sdk_builder_configuration.v
contract/             — TypeGenerate enum (v, csharp)
  type_generate.v
generator/
  csharp_gen/         — C# SDK generator (the only working target)
    *.v               — Code generation logic (folders, delegates, structs, constructor, files)
    sdk_files/        — .cs template fragments used during generation
  v_gen/              — V target generator (stub, not yet implemented)
Example/MySimpleDll/ — Sample V project + sdkbuilder.json for testing
```

## Architecture Notes

- `ast_v.get()` shells out to `v ast -p ...` and `v -check` — these are external commands, not V library calls. Errors from them bubble up as V `!` errors.
- C# generator uses `@VMODROOT` to resolve the output path (see `csharp_gen.v:14`).
- The V source being SDK'd is compiled with `v -shared` to produce a shared library; the compiler is configurable per project (`gcc`/`tcc`).
- Template rendering uses `leafscale.veemarker` (FreeMarker syntax). `veemarker.Engine` is created in `csharp_gen.v` and passed `mut` through the generator pipeline. Template variables with `.` (like `_arg.prop`) must be passed as pre-computed strings (e.g., `arg_prefix`) because veemarker treats `.` as property access on maps.

## Style Conventions

- Tabs for `.v` files (`.editorconfig`).
- LF line endings globally (`.editorconfig` + `.gitattributes`).
- V module = directory name; public API uses `pub`.

## Testing

No test suite exists yet. Verify manually by running against the example project:

```sh
v run . "Example/MySimpleDll/sdkbuilder.json"
```

This generates output in `projects_sdk/csharp/` and compiles the `MySimpleDll.dll`.

## Gotchas

- `projects_sdk/` is gitignored — generated output won't appear in `git status`.
- `v_gen` is a stub; only `csharp` target is functional.
- `bin/` is gitignored; compiled binaries land there.
- The `sdkbuilder.json` `project.prod` field controls `v -prod` during shared-lib compilation.
- `leafscale.veemarker` is a V dependency listed in `v.mod`. It cannot be imported as just `veemarker` — use `import leafscale.veemarker` in `.v` files, but reference types as `veemarker.Engine`, `veemarker.Any`, etc.