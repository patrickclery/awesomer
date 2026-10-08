# Awesome local LLM

> A curated list of awesome platforms, tools, practices and resources that helps run LLMs locally

[Home](../README.md) | [Live site ↗](https://patrickclery.com/awesomer/l/local-llm/) | [Source ↗](https://github.com/rafska/awesome-local-llm)

## Top 10 Trending

| # | Repo | Stars | 7d | 30d | 90d |
|---|------|-------|----|-----|-----|
| 1 | [pi](../r/earendil-works~pi.md) | 106,123 | +4,163 | +14,040 | +42,366 |
| 2 | [superpowers](../r/obra~superpowers.md) | 287,413 | +3,884 | +14,409 | +55,614 |
| 3 | [omlx](../r/jundot~omlx.md) | 21,795 | +1,421 | +2,963 | +5,008 |
| 4 | [llmfit](../r/alexsjones~llmfit.md) | 36,652 | +1,370 | +4,685 |  |
| 5 | [unsloth](../r/unslothai~unsloth.md) | 76,223 | +1,242 | +3,217 | +9,482 |
| 6 | [llama.cpp](../r/ggml-org~llama.cpp.md) | 128,403 | +1,069 | +4,110 | +11,277 |
| 7 | [browser-use](../r/browser-use~browser-use.md) | 114,779 | +866 | +5,297 | +15,367 |
| 8 | [Open WebUI](../r/open-webui~open-webui.md) | 152,260 | +732 | +3,275 | +10,151 |
| 9 | [OpenHands](../r/all-hands-ai~openhands.md) | 88,109 | +661 | +3,839 | +10,485 |
| 10 | [vllm](../r/vllm-project~vllm.md) | 91,905 | +627 | +2,653 | +8,660 |

## Table of Contents

- [Agent Frameworks](#agent-frameworks)
- [Agents](#agents)
- [Browser Automation](#browser-automation)
- [Coding Agents](#coding-agents)
- [Computer Use](#computer-use)
- [Context Engineering](#context-engineering)
- [Explorers, Benchmarks, Leaderboards](#explorers-benchmarks-leaderboards)
- [Hardware](#hardware)
- [Inference](#inference)
- [Inference engines](#inference-engines)
- [Inference platforms](#inference-platforms)
- [Memory Management](#memory-management)
- [Miscellaneous](#miscellaneous)
- [Model Context Protocol](#model-context-protocol)
- [Models](#models)
- [Prompt Engineering](#prompt-engineering)
- [Research](#research)
- [Retrieval-Augmented Generation](#retrieval-augmented-generation)
- [Security and Sandboxing](#security-and-sandboxing)
- [Testing, Evaluation and Observability](#testing-evaluation-and-observability)
- [Training and Fine-tuning](#training-and-fine-tuning)
- [User Interfaces](#user-interfaces)

## Agent Frameworks

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pi](../r/earendil-works~pi.md) | AI agent toolkit: unified LLM API, agent loop, TUI, coding agent CLI | 106,123 | +4,163 |
| [langchain](../r/langchain-ai~langchain.md) | The agent engineering platform. | 146,434 | +487 |
| [crewAI](../r/crewaiinc~crewai.md) | Framework for orchestrating role-playing, autonomous AI agents. By fostering collaborative intelligence, CrewAI empowers | 58,648 | +350 |
| [anything-llm](../r/mintplex-labs~anything-llm.md) | Stop renting your intelligence. Own it with AnythingLLM. Everything you need for a powerful local-first agent experience | 66,091 | +309 |
| [langflow](../r/langflow-ai~langflow.md) | Langflow is a powerful tool for building and deploying AI-powered agents and workflows. | 154,876 | +249 |
| [agent-framework](../r/microsoft~agent-framework.md) | A framework for building, orchestrating and deploying AI agents and multi-agent workflows with support for Python and .N | 13,547 | +237 |
| [openai-agents-python](../r/openai~openai-agents-python.md) | A lightweight, powerful framework for multi-agent workflows | 29,485 | +201 |
| [AutoGPT](../r/significant-gravitas~autogpt.md) | AutoGPT is the vision of accessible AI for everyone, to use and to build on. Our mission is to provide the tools, so tha | 187,380 | +192 |
| [agno](../r/agno-agi~agno.md) | Build, run, and manage agent platforms. | 42,196 | +144 |
| [llama_index](../r/run-llama~llama_index.md) | LlamaIndex is the document processing platform for AI | 52,184 | +141 |
| [autogen](../r/microsoft~autogen.md) | A programming framework for agentic AI | 61,004 | +138 |
| [pydantic-ai](../r/pydantic~pydantic-ai.md) | How Python does AI. Agents, realtime voice, image generation, embeddings. Every model, every interface, typed end to end | 19,978 | +126 |
| [sim](../r/simstudioai~sim.md) | Sim is the collaborative workspace to build, deploy, and monitor AI agents and workflows. Used by 100,000+ builders. | 29,648 | +47 |
| [camel](../r/camel-ai~camel.md) | 🐫 CAMEL: The first and the best multi-agent framework. Finding the Scaling Law of Agents. https://www.camel-ai.org | 17,726 | +37 |
| [genkit](../r/genkit-ai~genkit.md) | Open-source framework for building agentic apps in JavaScript, Go, Dart, and Python, built and used in production by Goo | 6,443 | +27 |
| [Flowise](../r/flowiseai~flowise.md) | Build AI Agents, Visually | 55,464 | +12 |
| [txtai](../r/neuml~txtai.md) | 💡 All-in-one AI framework for semantic search, LLM orchestration and language model workflows | 12,951 | +12 |
| [SuperAGI](https://github.com/TransformerOptimus/SuperAGI) | <⚡️> SuperAGI - A dev-first open source autonomous AI agent framework. Enabling developers to build, manage & run useful | 17,684 | +2 |
| [archgw](../r/katanemo~archgw.md) | Plano is an AI-native proxy server and data plane for agentic apps. Smart LLM routing, observability, agent orchestratio | 7,054 |  |
| [ClaraVerse](../r/badboysm890~claraverse.md) | Claraverse is a opesource privacy focused ecosystem to replace ChatGPT, Claude, N8N, ImageGen with your own hosted llm,  | 3,900 |  |
| [NeMo-Agent-Toolkit](../r/nvidia~nemo-agent-toolkit.md) | The NVIDIA NeMo Agent toolkit is an open-source library for efficiently connecting and optimizing teams of AI agents. | 2,634 |  |
| [NemoClaw](../r/nvidia~nemoclaw.md) | Run agents like Hermes, LangChain Deep Agents, and OpenClaw more securely inside NVIDIA OpenShell with managed inference | 22,474 |  |
| [ragbits](../r/deepsense-ai~ragbits.md) | Building blocks for rapid development of GenAI applications  | 1,667 |  |

[Back to top](#awesome-local-llm)

## Agents

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [superpowers](../r/obra~superpowers.md) | An agentic skills framework & software development methodology that works. | 287,413 | +3,884 |
| [Agent Skills](../r/agentskills~agentskills.md) | Specification and documentation for Agent Skills | 25,395 | +277 |
| [12-Factor Agents](../r/humanlayer~12-factor-agents.md) | What are the principles we can use to build LLM-powered software that is actually good enough to put in the hands of pro | 25,876 |  |
| [500+ AI Agent Projects](../r/ashishpatel26~500-ai-agents-projects.md) | The 500 AI Agents Projects is a curated collection of AI agent use cases across various industries. It showcases practic | 37,780 |  |
| [Agents towards production](../r/nirdiamant~agents-towards-production.md) | End-to-end, code-first tutorials for building production-grade GenAI agents. From prototype to enterprise deployment. | 21,462 |  |
| [agents.md](../r/agentsmd~agents.md.md) | AGENTS.md — a simple, open format for guiding coding agents | 24,405 |  |
| [GenAI Agents](../r/nirdiamant~genai_agents.md) | 50+ tutorials and implementations for Generative AI Agent techniques, from basic conversational bots to complex multi-ag | 24,300 |  |
| [LLM Agents & Ecosystem Handbook](../r/oxbshw~llm-agents-ecosystem-handbook.md) | One-stop handbook for building, deploying, and understanding LLM agents with 60+ skeletons, tutorials, ecosystem guides, | 549 |  |
| [skills](../r/huggingface~skills.md) | Give your agents the power of the Hugging Face ecosystem | 11,061 |  |

[Back to top](#awesome-local-llm)

## Browser Automation

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [browser-use](../r/browser-use~browser-use.md) | Agents that use the browser. | 114,779 | +866 |
| [playwright](../r/microsoft~playwright.md) | Playwright is a framework for Web Testing and Automation. It allows testing Chromium, Firefox and WebKit with a single A | 96,211 | +423 |
| [puppeteer](../r/puppeteer~puppeteer.md) | JavaScript API for Chrome and Firefox | 95,582 | +35 |
| [firecrawl](../r/mendableai~firecrawl.md) | The context API to search, scrape, and interact with the web at scale. 🔥 | 181,092 |  |
| [nanobrowser](../r/nanobrowser~nanobrowser.md) | Open-Source Chrome extension for AI-powered web automation. Run multi-agent workflows using your own LLM API key. Altern | 13,805 |  |
| [stagehand](../r/browserbase~stagehand.md) | The SDK For Browser Agents | 24,297 |  |

[Back to top](#awesome-local-llm)

## Coding Agents

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [OpenHands](../r/all-hands-ai~openhands.md) | 🙌 OpenHands: AI-Driven Development | 88,109 | +661 |
| [goose](../r/block~goose.md) | an open source, extensible AI agent that goes beyond code suggestions - install, execute, edit, and test with any LLM | 54,343 | +475 |
| [cline](../r/cline~cline.md) | Autonomous coding agent as an SDK, IDE extension, or CLI assistant. | 68,166 | +412 |
| [zed](../r/zed-industries~zed.md) | Code at the speed of thought – Zed is a high-performance, multiplayer code editor from the creators of Atom and Tree-sit | 90,299 | +368 |
| [aider](../r/aider-ai~aider.md) | aider is AI pair programming in your terminal | 48,991 | +169 |
| [kilocode](../r/kilo-org~kilocode.md) | Kilo is the all-in-one agentic engineering platform. Build, ship, and iterate faster with the most popular open source c | 27,323 | +100 |
| [continue](../r/continuedev~continue.md) | open-source coding agent | 35,930 | +93 |
| [tabby](../r/tabbyml~tabby.md) | Self-hosted AI coding assistant | 33,881 | +5 |
| [ProxyAI](../r/carlrobertoh~proxyai.md) | The leading open-source AI copilot for JetBrains. Connect to any model in any environment, and customize your coding exp | 1,934 | +1 |
| [99](../r/theprimeagen~99.md) | Neovim AI agent done right | 4,748 |  |
| [crush](../r/charmbracelet~crush.md) | Glamourous agentic coding for all 💘 | 28,122 |  |
| [humanlayer](../r/humanlayer~humanlayer.md) | The best way to get AI coding agents to solve hard problems in complex codebases. | 11,551 |  |
| [opencode](../r/sst~opencode.md) | The open source coding agent. | 207,797 |  |
| [Roo-Code](../r/roocodeinc~roo-code.md) | Roo Code gives you a whole dev team of AI agents in your code editor. | 24,304 | -3 |
| [void](../r/voideditor~void.md) | an open-source Cursor alternative, use AI agents on your codebase, checkpoint and visualize changes, and bring any model | 28,801 | -6 |

[Back to top](#awesome-local-llm)

## Computer Use

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [openwork](../r/different-ai~openwork.md) | The open-source alternative to Claude Cowork (powered by opencode) | 23,577 | +416 |
| [cua](../r/trycua~cua.md) | Scale computer-use 2.0 with open-source drivers, cross-OS fleets, and benchmarks for training, evaluation, and data gene | 22,709 | +414 |
| [open-interpreter](../r/openinterpreter~open-interpreter.md) | A coding agent for open models like Kimi K3 and GLM 5.3 | 68,342 | +89 |
| [OmniParser](../r/microsoft~omniparser.md) | A simple screen parsing tool towards pure vision based GUI agent | 25,389 | +27 |
| [Agent-S](../r/simular-ai~agent-s.md) | Agent S: an open agentic framework that uses computers like a human | 12,309 | +22 |
| [self-operating-computer](../r/othersideai~self-operating-computer.md) | A framework to enable a multimodal model to operate a computer. | 10,297 | +7 |
| [OpenRoom](../r/minimax-ai~openroom.md) | A browser-based desktop where AI Agent operates every app through natural language. | 1,261 |  |

[Back to top](#awesome-local-llm)

## Context Engineering

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Awesome-Context-Engineering](../r/meirtz~awesome-context-engineering.md) |  🔥 Comprehensive survey on Context Engineering: from prompt engineering to production-grade AI systems. hundreds of pap | 3,306 |  |
| [Context-Engineering](../r/davidkimai~context-engineering.md) | "Context engineering is the delicate art and science of filling the context window with just the right information for t | 9,251 |  |

[Back to top](#awesome-local-llm)

## Explorers, Benchmarks, Leaderboards

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [BullshitBench](../r/petergpt~bullshit-benchmark.md) | BullshitBench measures whether AI models challenge nonsensical prompts instead of confidently answering them, created by | 1,872 |  |
| [vakra](https://github.com/IBM/vakra) | A Benchmark for Evaluating Multi-Hop, Multi-Source Tool-Calling in AI Agents | 68 |  |

[Back to top](#awesome-local-llm)

## Hardware

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [ai-notes](https://github.com/paudley/ai-notes) | Random AI notes for working with local models or playing around with random machine learning bits. | 63 |  |
| [ZLUDA](../r/vosen~zluda.md) | CUDA on non-NVIDIA GPUs | 14,851 |  |

[Back to top](#awesome-local-llm)

## Inference

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [vLLM Production Stack](../r/vllm-project~production-stack.md) | vLLM’s reference system for K8S-native cluster-wide deployment with community-driven performance optimization | 2,574 | +12 |

[Back to top](#awesome-local-llm)

## Inference engines

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [omlx](../r/jundot~omlx.md) | LLM inference server with continuous batching & SSD caching for Apple Silicon — managed from the macOS menu bar | 21,795 | +1,421 |
| [llama.cpp](../r/ggml-org~llama.cpp.md) | LLM inference in C/C++ | 128,403 | +1,069 |
| [vllm](../r/vllm-project~vllm.md) | A high-throughput and memory-efficient inference and serving engine for LLMs | 91,905 | +627 |
| [ollama](../r/ollama~ollama.md) | Get up and running with Kimi, GLM, MiniMax, DeepSeek, gpt-oss, Qwen, Gemma and other models. | 181,113 | +541 |
| [sglang](../r/sgl-project~sglang.md) | SGLang is a high-performance serving framework for large language models and multimodal models. | 36,034 | +399 |
| [exo](../r/exo-explore~exo.md) | Run frontier AI locally. | 47,456 | +155 |
| [Nano-vLLM](../r/geeeekexplorer~nano-vllm.md) | Nano vLLM | 15,462 | +91 |
| [mini-sglang](../r/sgl-project~mini-sglang.md) | A compact implementation of SGLang, designed to demystify the complexities of modern LLM serving systems. | 5,077 | +86 |
| [koboldcpp](../r/lostruins~koboldcpp.md) | Run GGUF models easily with a KoboldAI UI. One File. Zero Install. | 11,727 | +71 |
| [TensorRT-LLM](../r/nvidia~tensorrt-llm.md) | TensorRT LLM provides users with an easy-to-use Python API to define Large Language Models (LLMs) and supports state-of- | 14,630 | +69 |
| [dynamo](../r/ai-dynamo~dynamo.md) | A Datacenter Scale Distributed Inference Serving Framework | 8,089 | +64 |
| [LiteRT-LM](../r/google-ai-edge~litert-lm.md) | LiteRT-LM is Google's production-ready, high-performance, open-source inference framework for deploying Large Language M | 6,458 | +56 |
| [flashinfer](../r/flashinfer-ai~flashinfer.md) | FlashInfer: Kernel Library for LLM Serving | 6,419 | +55 |
| [gpustack](../r/gpustack~gpustack.md) | A GPU cluster manager for high-performance AI model serving (vLLM, SGLang) and on-demand SSH-accessible GPU instances. | 5,702 | +44 |
| [BitNet](../r/microsoft~bitnet.md) | Official inference framework for 1-bit LLMs | 40,265 | +34 |
| [ik_llama.cpp](../r/ikawrakow~ik_llama.cpp.md) | llama.cpp fork with additional SOTA quants and improved performance | 3,229 | +29 |
| [executorch](../r/pytorch~executorch.md) | On-device AI across mobile, embedded and edge for PyTorch | 5,029 | +17 |
| [mistral.rs](../r/ericlbuehler~mistral.rs.md) | Fast, flexible LLM inference | 7,683 | +16 |
| [distributed-llama](../r/b4rtaz~distributed-llama.md) | Distributed LLM inference. Connect home devices into a powerful cluster to accelerate LLM inference. More devices means  | 3,059 | +9 |
| [FastFlowLM](../r/fastflowlm~fastflowlm.md) | Run LLMs on AMD Ryzen™ AI NPUs in minutes; purpose-built and deeply optimized for the AMD NPUs. | 1,878 |  |
| [krasis](../r/brontoguana~krasis.md) | Krasis is a Hybrid LLM runtime which focuses on efficient running of larger models on consumer grade VRAM limited hardwa | 521 |  |
| [LiteRT](../r/google-ai-edge~litert.md) | LiteRT, successor to TensorFlow Lite. is Google's On-device framework for high-performance ML & GenAI deployment on edge | 3,407 |  |
| [llm-scaler](../r/intel~llm-scaler.md) | run LLMs on Intel Arc™ Pro B60 GPUs | 530 |  |
| [mlx-lm](../r/ml-explore~mlx-lm.md) | Run LLMs with MLX | 7,025 |  |
| [mlx-vlm](../r/blaizzy~mlx-vlm.md) | MLX-VLM is a package for inference and fine-tuning of Vision Language Models (VLMs) on your Mac using MLX. | 5,504 |  |
| [sonar](../r/dphnai~sonar.md) | Large-scale LLM inference engine | 1,859 |  |
| [tokenspeed](../r/lightseekorg~tokenspeed.md) | TokenSpeed is a speed-of-light LLM inference engine. | 2,137 |  |
| [vllm-gfx906](../r/nlzy~vllm-gfx906.md) | vLLM for AMD gfx906 GPUs, e.g. Radeon VII / MI50 / MI60 | 434 |  |

[Back to top](#awesome-local-llm)

## Inference platforms

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [unsloth](../r/unslothai~unsloth.md) | Local UI to run and train LLMs and diffusion models. Supports GGUF, MLX, Qwen3.8, DeepSeek-V4, MiniMax-H3, Gemma 4, FLUX | 76,223 | +1,242 |
| [LocalAI](../r/mudler~localai.md) | LocalAI is the open-source AI engine. Run any model - LLMs, vision, voice, image, video - on any hardware. No GPU requir | 49,130 | +120 |
| [ChatBox](../r/chatboxai~chatbox.md) | Powerful AI Client | 41,783 |  |
| [jan](../r/menloresearch~jan.md) | Jan is an open source alternative to ChatGPT that runs 100% offline on your computer. | 44,491 |  |
| [lemonade](../r/lemonade-sdk~lemonade.md) | Lemonade helps users discover and run local AI apps by serving optimized LLMs right from their own GPUs and NPUs. Join o | 5,723 |  |

[Back to top](#awesome-local-llm)

## Memory Management

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [mem0](../r/mem0ai~mem0.md) | The Memory Layer for AI Agents - Drop-in memory infrastructure for AI agents and apps. Context that persists. Built for  | 65,395 | +484 |
| [cognee](../r/topoteretes~cognee.md) | Cognee is the open-source AI memory platform for agents. Give your AI agents persistent long-term memory across sessions | 30,711 | +159 |
| [LMCache](../r/lmcache~lmcache.md) | LMCache: Supercharge Your LLM with the Fastest KV Cache Layer | 11,822 | +158 |
| [letta](../r/letta-ai~letta.md) | Platform for stateful agents: AI with advanced memory that can learn and self-improve over time. | 24,763 | +137 |
| [supermemory](../r/supermemoryai~supermemory.md) | Memory and context engine + app that is extremely fast, scalable, and can be run fully locally. The Memory API for the A | 29,686 | +110 |
| [mempalace](../r/milla-jovovich~mempalace.md) | The best-benchmarked open-source AI memory system. And it's free. | 59,091 |  |
| [memU](../r/nevamind-ai~memu.md) | Personal memory across agents | 14,408 |  |
| [reasoning-bank](../r/google-research~reasoning-bank.md) | a memory mechanism for agents that learns from both successful and failed trajectories, with reasoning stored as memory  | 586 |  |

[Back to top](#awesome-local-llm)

## Miscellaneous

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [context7](../r/upstash~context7.md) | Context7 Platform -- Up-to-date code documentation for LLMs and AI code editors | 62,074 | +277 |
| [cai](../r/aliasrobotics~cai.md) | Cybersecurity AI (CAI), the framework for AI Security | 9,832 | +45 |
| [4o-ghibli-at-home](https://github.com/TheAhmadOsman/4o-ghibli-at-home) | The GPT-4o image generation we have at home. A powerful, self-hosted AI photo stylizer built for performance and privacy | 493 |  |
| [deepwiki-open](../r/asyncfuncai~deepwiki-open.md) | Open Source DeepWiki: AI-Powered Wiki Generator for GitHub/Gitlab/Bitbucket Repositories. Join the discord: https://disc | 17,988 |  |
| [gabber](../r/gabber-dev~gabber.md) | Build AI applications that can see, hear, and speak using your screens, microphones, and cameras as inputs. | 1,111 |  |
| [local-llm](../r/jamesob~local-llm.md) | Everything I know about running LLMs locally | 1,833 |  |
| [mobile-use](../r/minitap-ai~mobile-use.md) | AI agents can now use real Android and iOS apps, just like a human. | 3,018 |  |
| [Observer](../r/roy3838~observer.md) | Why observe computer if computer can observe for you | 1,610 |  |
| [OmniGen2](../r/vectorspacelab~omnigen2.md) | OmniGen2: Exploration to Advanced Multimodal Generation. https://arxiv.org/abs/2506.18871 | 4,112 |  |
| [presenton](../r/presenton~presenton.md) | Open-Source AI Presentation Generator and API (Gamma, Canva, Beautiful AI, Decktopus, Presentations AI Alternative) | 10,232 |  |
| [promptcat](https://github.com/sevenreasons/promptcat) | A zero-dependency prompt manager/catalog/library in a single HTML file. Everything is stored locally in your browser. Me | 85 |  |
| [speakr](../r/murtaza-nasir~speakr.md) | Speakr is a personal, self-hosted web application designed for transcribing audio recordings | 3,747 |  |

[Back to top](#awesome-local-llm)

## Model Context Protocol

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [chrome-devtools-mcp](../r/chromedevtools~chrome-devtools-mcp.md) | Chrome DevTools for coding agents | 52,110 | +348 |
| [playwright-mcp](../r/microsoft~playwright-mcp.md) | Playwright MCP server | 37,164 | +212 |
| [github-mcp-server](../r/github~github-mcp-server.md) | GitHub's official MCP Server | 32,962 | +160 |
| [mindsdb](../r/mindsdb~mindsdb.md) | The unified workspace where open-source models get things done for you. | 39,739 | +36 |
| [mcp-atlassian](../r/sooperset~mcp-atlassian.md) | MCP server for Atlassian tools (Confluence, Jira) | 5,908 | +32 |
| [awslabs/mcp](../r/awslabs~mcp.md) | Open source MCP Servers for AWS | 9,696 | +22 |
| [dbhub](../r/bytebase~dbhub.md) | Token conscious database MCP server for Postgres, MySQL, SQL Server, MariaDB, SQLite. | 3,526 |  |
| [n8n-mcp](../r/czlonkowski~n8n-mcp.md) | A MCP for Claude Desktop / Claude Code / Windsurf / Cursor to build n8n workflows for you  | 22,895 |  |

[Back to top](#awesome-local-llm)

## Models

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [llmfit](../r/alexsjones~llmfit.md) | Hundreds of models & providers. One command to find what runs on your hardware. | 36,652 | +1,370 |
| [llama-swap](../r/mostlygeek~llama-swap.md) | Reliable model swapping for any local OpenAI/Anthropic compatible server - llama.cpp, vllm, etc | 5,672 | +69 |
| [outlines](../r/dottxt-ai~outlines.md) | Structured Outputs | 15,810 | +49 |
| [gguf-docs](https://github.com/iuliaturc/gguf-docs) | Docs for GGUF quantization (unofficial) | 515 |  |
| [llguidance](../r/guidance-ai~llguidance.md) | Super-fast Structured Outputs | 869 |  |
| [nanochat](../r/karpathy~nanochat.md) | The best ChatGPT that $100 can buy. | 58,066 |  |

[Back to top](#awesome-local-llm)

## Prompt Engineering

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Prompt Engineering Guide](../r/dair-ai~prompt-engineering-guide.md) | 🐙 Guides, papers, lessons, notebooks and resources for prompt engineering, context engineering, RAG, and AI Agents. | 78,364 | +231 |
| [Prompt Engineering by NirDiamant](../r/nirdiamant~prompt_engineering.md) | 22 prompt engineering techniques with hands-on Jupyter Notebook tutorials, from fundamental concepts to advanced strateg | 7,854 |  |
| [system_prompts_leaks](../r/asgeirtj~system_prompts_leaks.md) | Extracted system prompts from Anthropic - Claude Fable 5.1, Opus 5, Claude Design, Claude Code. OpenAI - ChatGPT GPT-6-A | 67,300 |  |
| [system-prompts-and-models-of-ai-tools](../r/x1xhlol~system-prompts-and-models-of-ai-tools.md) | FULL Augment Code, Claude Code, Cluely, CodeBuddy, Comet, Cursor, Devin AI, Junie, Kiro, Leap.new, Lovable, Manus, Notio | 143,655 |  |

[Back to top](#awesome-local-llm)

## Research

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [open-notebook](../r/lfnovo~open-notebook.md) | An Open Source implementation of Notebook LM with more flexibility and features | 38,973 | +569 |
| [Perplexica](../r/itzcrazykns~perplexica.md) | Vane is an AI-powered answering engine. | 36,940 | +234 |
| [gpt-researcher](../r/assafelovic~gpt-researcher.md) | An autonomous agent that conducts deep research on any data using any LLM providers | 29,479 | +121 |
| [SurfSense](../r/modsetter~surfsense.md) | Open-source NotebookLM alternative. Research the open web with live data(Reddit, YT, IG, TikTok, Indeed, Google Search,  | 16,157 | +56 |
| [local-deep-research](../r/learningcircuit~local-deep-research.md) |  ~95% on SimpleQA (e.g. Qwen3.6-27B on a 3090). Supports all local and cloud LLMs (llama.cpp, Ollama, Google, ...). 10+  | 9,097 | +48 |
| [local-deep-researcher](../r/langchain-ai~local-deep-researcher.md) | Fully local web research and report writing assistant | 9,344 |  |
| [maestro](../r/murtaza-nasir~maestro.md) | MAESTRO is an AI-powered research application designed to streamline complex research tasks. | 1,492 |  |
| [RD-Agent](../r/microsoft~rd-agent.md) | Research and development (R&D) is crucial for the enhancement of industrial productivity, especially in the AI era, wher | 14,648 |  |

[Back to top](#awesome-local-llm)

## Retrieval-Augmented Generation

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [graphiti](../r/getzep~graphiti.md) | Build Real-Time Knowledge Graphs for AI Agents | 30,923 | +247 |
| [LightRAG](../r/hkuds~lightrag.md) | [EMNLP2025] LightRAG: Simple and Fast Retrieval-Augmented Generation | 39,695 | +225 |
| [graphrag](../r/microsoft~graphrag.md) | A modular graph-based Retrieval-Augmented Generation (RAG) system | 35,992 | +112 |
| [onyx](../r/onyx-dot-app~onyx.md) | Open Source AI Platform - AI Chat with advanced features that works with every LLM | 32,119 | +109 |
| [haystack](../r/deepset-ai~haystack.md) | Open-source AI orchestration framework for building context-engineered, production-ready LLM applications. Design modula | 26,521 | +74 |
| [claude-context](../r/zilliztech~claude-context.md) | Code search MCP for Claude Code. Make entire codebase the context for any coding agent. | 12,531 |  |
| [Controllable RAG Agent](../r/nirdiamant~controllable-rag-agent.md) | This repository provides an advanced Retrieval-Augmented Generation (RAG) solution for complex question answering. It us | 1,626 |  |
| [LangChain RAG Cookbook](https://github.com/lokeswaran-aj/langchain-rag-cookbook) | a collection of modular RAG techniques, implemented in LangChain + Python | 38 |  |
| [Pathway AI Pipelines](../r/pathwaycom~llm-app.md) | Ready-to-run cloud templates for RAG, AI pipelines, and enterprise search with live data. 🐳Docker-friendly.⚡Always in s | 58,928 |  |
| [pipeshub-ai](../r/pipeshub-ai~pipeshub-ai.md) | PipesHub is an open-source platform for securely connecting enterprise knowledge to AI. Give AI agents trusted context a | 3,749 |  |
| [RAG Techniques](../r/nirdiamant~rag_techniques.md) | This repository showcases various advanced techniques for Retrieval-Augmented Generation (RAG) systems. Each technique h | 29,507 |  |
| [vanna](../r/vanna-ai~vanna.md) | 🤖 Chat with your SQL database 📊. Accurate Text-to-SQL Generation via LLMs using Agentic Retrieval 🔄. | 23,815 | -8 |
| [pathway](../r/pathwaycom~pathway.md) | Python ETL framework for stream processing, real-time analytics, LLM pipelines, and RAG. | 62,284 | -40 |

[Back to top](#awesome-local-llm)

## Security and Sandboxing

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [garak](../r/nvidia~garak.md) | the LLM vulnerability scanner | 9,265 | +181 |
| [CubeSandbox](../r/tencentcloud~cubesandbox.md) | Instant, Concurrent, Secure & Lightweight Sandbox for AI Agents. | 12,545 | +136 |
| [OpenShell](../r/nvidia~openshell.md) | OpenShell is the safe, private runtime for autonomous AI agents. | 8,632 | +111 |
| [Guardrails](../r/nvidia-nemo~guardrails.md) | NeMo Guardrails is an open-source toolkit for easily adding programmable guardrails to LLM-based conversational systems. | 7,138 | +45 |

[Back to top](#awesome-local-llm)

## Testing, Evaluation and Observability

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [langfuse](../r/langfuse~langfuse.md) | 🪢 Open source agent evals & observability: Trace, evaluate, and improve LLM applications with one open platform. | 34,680 | +354 |
| [opik](../r/comet-ml~opik.md) | Debug, evaluate, and monitor your LLM applications, RAG systems, and agentic workflows with comprehensive tracing, autom | 22,058 | +149 |
| [agenta](../r/agenta-ai~agenta.md) | Agenta is a workspace where you and your team build agents and automations. | 4,758 | +40 |
| [openllmetry](../r/traceloop~openllmetry.md) | Open-source observability for your GenAI or LLM application, based on OpenTelemetry | 7,433 | +17 |
| [Evaluator](../r/nvidia-nemo~evaluator.md) | Open-source library for scalable, reproducible evaluation of AI models and benchmarks. | 340 |  |
| [giskard](../r/giskard-ai~giskard.md) | 🐢 Open-Source Evaluation & Testing library for LLM Agents | 5,818 |  |

[Back to top](#awesome-local-llm)

## Training and Fine-tuning

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [heretic](../r/p-e-w~heretic.md) | Fully automatic censorship removal for language models | 31,542 | +304 |
| [slime](../r/thudm~slime.md) | slime is an LLM post-training framework for RL Scaling. | 8,484 | +122 |
| [trl](../r/huggingface~trl.md) | Train transformer language models with reinforcement learning. | 19,324 | +57 |
| [OpenRLHF](../r/openrlhf~openrlhf.md) | An Easy-to-use, Scalable and High-performance Agentic RL Framework based on Ray (PPO & DAPO & REINFORCE++ &  VLM & TIS & | 10,009 | +23 |
| [augmentoolkit](../r/e-p-armstrong~augmentoolkit.md) | Create Custom LLMs | 1,871 |  |
| [Gym](../r/nvidia-nemo~gym.md) | Evaluate and improve models and agents using environments | 1,189 |  |
| [Kiln](../r/kiln-ai~kiln.md) | Build, Evaluate, and Optimize AI Systems. Includes evals, RAG, agents, fine-tuning, synthetic data generation, dataset m | 5,072 |  |
| [miles](../r/radixark~miles.md) | Miles is an enterprise-facing reinforcement learning framework for LLM and VLM post-training, forked from and co-evolvin | 2,897 |  |
| [OpenEnv](../r/meta-pytorch~openenv.md) | An interface library for RL post training with environments.  | 2,585 |  |
| [RL](../r/nvidia-nemo~rl.md) | Scalable toolkit for efficient model reinforcement | 2,021 |  |
| [sentence-transformers](../r/huggingface~sentence-transformers.md) | State-of-the-Art Embeddings, Retrieval, and Reranking | 19,099 |  |
| [SpecForge](../r/sgl-project~specforge.md) | Train speculative decoding models effortlessly and port them smoothly to SGLang serving. | 1,175 |  |

[Back to top](#awesome-local-llm)

## User Interfaces

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Open WebUI](../r/open-webui~open-webui.md) | User-friendly AI Interface (Supports Ollama, OpenAI API, ...) | 152,260 | +732 |
| [SillyTavern](../r/sillytavern~sillytavern.md) | LLM Frontend for Power Users. | 33,413 | +336 |
| [Lobe Chat](../r/lobehub~lobe-chat.md) | 🤯 LobeHub is your Chief Agent Operator, organizing your agents into 7×24 operations by hiring, scheduling, and reportin | 82,522 | +181 |
| [Text generation web UI](../r/oobabooga~text-generation-webui.md) | Open-source desktop app for local LLMs. Text, vision, tool-calling, OpenAI/Anthropic-compatible API. 100% private. | 47,672 | +30 |
| [Page Assist](../r/n4ze3m~page-assist.md) | Use your locally running AI models to assist you in your web browsing | 8,213 |  |

[Back to top](#awesome-local-llm)

---
*Updated: 2026-09-17 | [View live site ↗](https://patrickclery.com/awesomer/l/local-llm/)*
