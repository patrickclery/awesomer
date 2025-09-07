# awesome-roslyn

Curated list of awesome Roslyn books, tutorials, open-source projects, analyzers, code fixes, refactorings, and source generators

## Libraries and Frameworks for Testing Analyzers, Code Fixes, and Refactorings

- [RoslynTestKit](https://github.com/cezarypiatek/RoslynTestKit) - Lightweight framework for writing unit tests for analyzers, code fixes, refactorings, and completion providers. It's unit testing framework agnostic.

## Open Source Projects

- [Bridge](https://github.com/bridgedotnet/Bridge) - C# to JavaScript transpiler. Write modern mobile and web apps in C# and run them anywhere in JavaScript.
- [Code Converter](https://github.com/icsharpcode/CodeConverter) - C# to VB.NET and VB.NET to C# transpiler.
- [CodeAnalysis.CSharp.PatternMatching](https://github.com/pvginkel/Microsoft.CodeAnalysis.CSharp.PatternMatching) - Intuitive pattern matching for Roslyn syntax trees. Simplifies C# syntax and semantic analysis.
- [CodeGeneration.Roslyn](https://github.com/AArnott/CodeGeneration.Roslyn) - Roslyn-based Code Generation during a build with design-time support.
- [dotnet-script](https://github.com/filipw/dotnet-script) - Runs C# scripts from the .NET CLI, defines NuGet packages inline and edit/debugs them in VS Code.
- [FlubuCore](https://github.com/dotnetcore/FlubuCore) - Cross platform build automation tool for building projects and executing deployment scripts using C# code.
- [MirrorSharp](https://github.com/ashmind/mirrorsharp) - Online C#, VB.NET, and F# code editor. Features code completion, method signature help, quick fixes, and diagnostics.
- [roslyn-linq-rewrite](https://github.com/antiufo/roslyn-linq-rewrite) - Compiles C# code by first rewriting the syntax trees of LINQ expressions using plain procedural code. This increases performance by minimizes heap allocations and dynamic dispatch.
- [RoslynQuoter](https://github.com/KirillOsenkov/RoslynQuoter) - Online tool that for a given C# program generates syntax tree API calls that construct syntax tree of that program.
- [Scripty](https://github.com/daveaglick/Scripty) - Tool to use Roslyn-powered C# scripts for code generation. You can think of it as a scripted alternative to T4 templates.
- [Testura.Code](https://github.com/Testura/Testura.Code) - Wrapper around the Roslyn API used for generation, saving, and compiling C# code. Provides methods and helpers to generate classes, methods, statements, and expressions.
- [Uno SourceGenerator](https://github.com/nventive/Uno.SourceGeneration) - C# source code generator based on a project being built, using all of its syntactic and semantic model information.

## Source Generators

- [DpDtInject](https://github.com/lsoft/DpdtInject) - Proof-of-concept of a dependency injection container that transfers huge piece of resolving logic to the compilation stage. Offers additional compile-time safety and fast runtime resolution.
- [Generator.Equals](https://github.com/diegofrata/Generator.Equals) - Automatically implements equality and hashing for classes and records. Supports different comparison strategies. Offers similar functionality like IL weaving-based [Equals.Fody](https://github.com/Fody/Equals).
- [JsonSrcGen](https://github.com/trampster/JsonSrcGen) - Reflection-free JSON serializer. Allows extremely fast JSON processing by generating reflection-free serializers at the compile time.
- [StrongInject](https://github.com/YairHalberstadt/stronginject) - Compile-time dependency injection container. Compile-time checked, reflection-free and runtime code generation free, thus fast and [app-trimming](https://devblogs.microsoft.com/dotnet/app-trimming-in-net-5/)-friendly.
- [StructPacker](https://github.com/RudolfKurka/StructPacker) - Low-level, lightweight and performance-focused serializer for C# struct types. Auto-generates C# serialization code to achieve peak runtime performance and efficiency.
- [Svg to C# Source Generators](https://github.com/wieslawsoltes/SourceGenerators) - SVG to C# compiler. Compiles SVG drawing markup to C# using [SkiaSharp](https://github.com/mono/SkiaSharp) as rendering engine.
- [WrapperValueObject](https://github.com/martinothamar/WrapperValueObject) - Creates boilerplate free wrappers around types. Especially useful for creating [strongly typed wrappers around primitive types](https://andrewlock.net/series/using-strongly-typed-entity-ids-to-avoid-primitive-obsession/).

## Open Source Analyzers, Code Fixes, and Refactorings

- [.NET Compiler Platform ("Roslyn") Analyzers](https://github.com/dotnet/roslyn-analyzers) - Diagnostic analyzers developed by the Roslyn team. Initially developed to help flesh out the design and implementation of the static analysis APIs. The analyzers cover code quality, .NET Core, desktop .NET Framework, comments in code, and more.
- [Code Cracker](https://github.com/code-cracker/code-cracker) - Analyzer library for C# and VB.NET. Offers diagnostics in many categories like performance, coding styles, as well as some basic refactorings.
- [CSharpGuidelinesAnalyzer](https://github.com/bkoelman/CSharpGuidelinesAnalyzer) - Reports diagnostics for C# coding guidelines (https://csharpcodingguidelines.com/).
- [ErrorProne.NET](https://github.com/SergeyTeplyakov/ErrorProne.NET) - Set of analyzers and code fixes focusing on the correctness and performance of C# programs. Inspired with Google's [Error Prone](https://github.com/google/error-prone).
- [Mapping Generator](https://github.com/cezarypiatek/MappingGenerator) - Code fix that generates arbitrary complex object-object mappings. It recognizes out of the box a large number of scenarios where mappings are used. A design-time alternative to [AutoMapper](https://automapper.org/).
- [Nullable.Extended](https://github.com/tom-englert/Nullable.Extended) - Roslyn tools and analyzers to improve the experience when coding with nullable reference types.
- [Refactoring Essentials for Visual Studio](https://github.com/icsharpcode/RefactoringEssentials) - Refactorings, analyzers and code fixes for C# and VB.NET.
- [Roslyn Clr Heap Allocation Analyzer](https://github.com/Microsoft/RoslynClrHeapAllocationAnalyzer) - C# heap allocation analyzer that can detect explicit and many implicit allocations like boxing, closures, implicit delegate creations, etc.
- [Roslynator](https://github.com/JosefPihrt/Roslynator) - Collection of 190+ analyzers and 190+ refactorings for C#. Covers coding style, code readability and simplification, removing redundancies, fixing compiler errors, and many more.
- [SonarC#](https://github.com/SonarSource/sonar-csharp) - Static code analyzer for C# language used as an extension for the SonarQube platform.
- [StyleCop Analyzers for the .NET Compiler Platform](https://github.com/DotNetAnalyzers/StyleCopAnalyzers) - Port of StyleCop rules to Roslyn.
- [VSDiagnostics](https://github.com/Vannevelj/VSDiagnostics) - Collection of code-quality analyzers. Covers usages of async methods, flags enums, best practices in exception handling as well as many other code-quality checks.

## Tutorials

- [C# Source Generators](https://github.com/amis92/csharp-source-generators) - Comprehensive list of additional learning sources, samples, and experimental and productive source generators. A perfect reference once you grasp the basics.
