# Awesome local LLM

> A curated list of awesome platforms, tools, practices and resources that helps run LLMs locally

[Home](../README.md) | [Live site ↗](https://patrickclery.com/awesomer/l/local-llm/) | [Source ↗](https://github.com/rafska/awesome-local-llm)

## Top 10 Trending

| # | Repo | Stars | 7d | 30d | 90d |
|---|------|-------|----|-----|-----|
| 1 | [t3code](../r/pingdotgg~t3code.md) | 50,414 | +17,046 | +24,132 | +32,946 |
| 2 | [Strata](../r/niko1221~strata.md) | 41,261 | +4,506 |  |  |
| 3 | [superpowers](../r/obra~superpowers.md) | 313,828 | +4,135 | +17,251 | +44,307 |
| 4 | [paperclip](../r/paperclipai~paperclip.md) | 111,865 | +2,736 | +13,207 | +35,875 |
| 5 | [heretic](../r/p-e-w~heretic.md) | 39,824 | +2,567 | +5,836 | +12,599 |
| 6 | [firecrawl](../r/mendableai~firecrawl.md) | 199,377 | +2,125 | +9,709 |  |
| 7 | [opencode](../r/sst~opencode.md) | 225,154 | +1,714 | +12,844 |  |
| 8 | [zed](../r/zed-industries~zed.md) | 94,015 | +1,562 | +2,571 | +5,703 |
| 9 | [pi](../r/earendil-works~pi.md) | 120,571 | +1,475 | +7,161 | +34,772 |
| 10 | [nanochat](../r/karpathy~nanochat.md) | 60,348 | +1,209 | +1,870 |  |

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
| [t3code](../r/pingdotgg~t3code.md) | an agent harness control surface that enables control of the agents on your machine with a best-in-class mobile app | 50,414 | +17,046 |
| [paperclip](../r/paperclipai~paperclip.md) | The open-source app everyone uses to manage agents at work | 111,865 | +2,736 |
| [pi](../r/earendil-works~pi.md) | AI agent toolkit: unified LLM API, agent loop, TUI, coding agent CLI | 120,571 | +1,475 |
| [langchain](../r/langchain-ai~langchain.md) | The agent engineering platform. | 149,148 | +387 |
| [superset](../r/superset-sh~superset.md) | Paradev is an open-source Codex App and Conductor alternative. Orchestrate an army coding agents in parallel with your o | 16,060 | +285 |
| [crewAI](../r/crewaiinc~crewai.md) | Framework for orchestrating role-playing, autonomous AI agents. By fostering collaborative intelligence, CrewAI empowers | 60,600 | +267 |
| [anything-llm](../r/mintplex-labs~anything-llm.md) | Stop renting your intelligence. Own it with AnythingLLM. Everything you need for a powerful local-first agent experience | 68,026 | +242 |
| [langflow](../r/langflow-ai~langflow.md) | Langflow is a powerful tool for building and deploying AI-powered agents and workflows. | 156,400 | +214 |
| [agent-framework](../r/microsoft~agent-framework.md) | A framework for building, orchestrating and deploying AI agents and multi-agent workflows with support for Python and .N | 14,570 | +174 |
| [openai-agents-python](../r/openai~openai-agents-python.md) | A lightweight, powerful framework for multi-agent workflows | 30,543 | +137 |
| [sim](../r/simstudioai~sim.md) | Sim is the collaborative workspace to build, deploy, and monitor AI agents and workflows. Used by 100,000+ builders. | 30,061 | +111 |
| [pydantic-ai](../r/pydantic~pydantic-ai.md) | How Python does AI. Agents, realtime voice, image generation, embeddings. Every model, every interface, typed end to end | 21,070 | +102 |
| [agno](../r/agno-agi~agno.md) | The self-driving agent platform | 43,092 | +98 |
| [autogen](../r/microsoft~autogen.md) | A programming framework for agentic AI | 61,738 | +94 |
| [AutoGPT](../r/significant-gravitas~autogpt.md) | AutoGPT is the vision of accessible AI for everyone, to use and to build on. Our mission is to provide the tools, so tha | 187,933 | +93 |
| [emdash](../r/generalaction~emdash.md) | Emdash is the Open-Source Agentic Development Environment (🧡 YC W26). Run multiple coding agents in parallel. Use any p | 6,210 | +82 |
| [llama_index](../r/run-llama~llama_index.md) | LlamaIndex is the document processing platform for AI | 52,839 | +80 |
| [NemoClaw](../r/nvidia~nemoclaw.md) | Run agents like Hermes, LangChain Deep Agents, and OpenClaw more securely inside NVIDIA OpenShell with managed inference | 22,973 | +76 |
| [Flowise](../r/flowiseai~flowise.md) | Build AI Agents, Visually | 55,563 | +27 |
| [camel](../r/camel-ai~camel.md) | 🐫 CAMEL: The first and the best multi-agent framework. Finding the Scaling Law of Agents. https://www.camel-ai.org | 18,016 | +17 |
| [SuperAGI](https://github.com/TransformerOptimus/SuperAGI) | <⚡️> SuperAGI - A dev-first open source autonomous AI agent framework. Enabling developers to build, manage & run useful | 17,738 | +17 |
| [txtai](../r/neuml~txtai.md) | 💡 All-in-one AI framework for semantic search, LLM orchestration and language model workflows | 13,066 | +14 |
| [genkit](../r/genkit-ai~genkit.md) | Open-source framework for building agentic apps in JavaScript, Go, Dart, and Python, built and used in production by Goo | 6,572 | +11 |
| [archgw](../r/katanemo~archgw.md) | Plano is an AI-native proxy server and data plane for agentic apps. Smart LLM routing, observability, agent orchestratio | 7,110 | +7 |
| [NeMo-Agent-Toolkit](../r/nvidia~nemo-agent-toolkit.md) | The NVIDIA NeMo Agent toolkit is an open-source library for efficiently connecting and optimizing teams of AI agents. | 2,692 | +4 |
| [ClaraVerse](../r/badboysm890~claraverse.md) | Claraverse is a opesource privacy focused ecosystem to replace ChatGPT, Claude, N8N, ImageGen with your own hosted llm,  | 3,903 | +1 |
| [ragbits](../r/deepsense-ai~ragbits.md) | Building blocks for rapid development of GenAI applications  | 1,681 | +1 |

[Back to top](#awesome-local-llm)

## Agents

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [superpowers](../r/obra~superpowers.md) | An agentic skills framework & software development methodology that works. | 313,828 | +4,135 |
| [Agent Skills](../r/agentskills~agentskills.md) | Specification and documentation for Agent Skills | 27,034 | +216 |
| [500+ AI Agent Projects](../r/ashishpatel26~500-ai-agents-projects.md) | The 500 AI Agents Projects is a curated collection of AI agent use cases across various industries. It showcases practic | 39,365 | +192 |
| [agents.md](../r/agentsmd~agents.md.md) | AGENTS.md — a simple, open format for guiding coding agents | 25,373 | +135 |
| [GenAI Agents](../r/nirdiamant~genai_agents.md) | 50+ tutorials and implementations for Generative AI Agent techniques, from basic conversational bots to complex multi-ag | 24,857 | +112 |
| [12-Factor Agents](https://github.com/humanlayer/12-factor-agents) | What are the principles we can use to build LLM-powered software that is actually good enough to put in the hands of pro | 27,015 | +85 |
| [skills](../r/huggingface~skills.md) | Give your agents the power of the Hugging Face ecosystem | 11,290 | +51 |
| [Agents towards production](../r/nirdiamant~agents-towards-production.md) | End-to-end, code-first tutorials for building production-grade GenAI agents. From prototype to enterprise deployment. | 21,846 | +46 |
| [LLM Agents & Ecosystem Handbook](../r/oxbshw~llm-agents-ecosystem-handbook.md) | One-stop handbook for building, deploying, and understanding LLM agents with 60+ skeletons, tutorials, ecosystem guides, | 558 | +1 |

[Back to top](#awesome-local-llm)

## Browser Automation

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [firecrawl](../r/mendableai~firecrawl.md) | Supercharge your AI agents with data from the web and beyond. Building the library for superintelligence. 🔥 | 199,377 | +2,125 |
| [browser-use](../r/browser-use~browser-use.md) | Open-source Python library for AI browser agents, plus Browser Use Cloud: stealth browsers and a hosted agent API. | 120,237 | +609 |
| [playwright](../r/microsoft~playwright.md) | Playwright is a framework for Web Testing and Automation. It allows testing Chromium, Firefox and WebKit with a single A | 99,504 | +575 |
| [BrowserSkill](../r/tencent~browserskill.md) | Let AI agents use your real, logged-in browser without interrupting your work. CLI + extension for browser automation ac | 10,144 | +305 |
| [stagehand](../r/browserbase~stagehand.md) | The SDK to extract data and interact with any site on the web. Get started with Claude Code, Codex, Eve, Mastra, and mor | 25,977 | +92 |
| [nanobrowser](../r/nanobrowser~nanobrowser.md) | Open-source AI agent for web automation. Use your real, logged-in browser to automate daily tasks. | 14,256 | +47 |
| [puppeteer](../r/puppeteer~puppeteer.md) | JavaScript API for Chrome and Firefox | 95,809 | +34 |

[Back to top](#awesome-local-llm)

## Coding Agents

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [opencode](../r/sst~opencode.md) | The open source coding agent. | 225,154 | +1,714 |
| [zed](../r/zed-industries~zed.md) | Code at the speed of thought – Zed is a high-performance, multiplayer code editor from the creators of Atom and Tree-sit | 94,015 | +1,562 |
| [OpenHands](../r/all-hands-ai~openhands.md) | 🙌 OpenHands: AI-Driven Development | 92,859 | +538 |
| [cline](../r/cline~cline.md) | Autonomous coding agent as an SDK, IDE extension, or CLI assistant. | 71,439 | +345 |
| [goose](../r/block~goose.md) | an open source, extensible AI agent that goes beyond code suggestions - install, execute, edit, and test with any LLM | 56,319 | +294 |
| [openchamber](../r/openchamber~openchamber.md) | Agentic Development Environment based on OpenCode AI agent | 12,657 | +263 |
| [aider](../r/aider-ai~aider.md) | aider is AI pair programming in your terminal | 50,002 | +157 |
| [humanlayer](../r/humanlayer~humanlayer.md) | The best way to get AI coding agents to solve hard problems in complex codebases. | 12,826 | +98 |
| [crush](../r/charmbracelet~crush.md) | Glamourous agentic coding for all 💘 | 28,984 | +90 |
| [kilocode](../r/kilo-org~kilocode.md) | Kilo is the all-in-one agentic engineering platform. Build, ship, and iterate faster with the most popular open source c | 27,890 | +75 |
| [continue](../r/continuedev~continue.md) | open-source coding agent | 36,427 | +45 |
| [99](../r/theprimeagen~99.md) | Neovim AI agent done right | 4,750 | +1 |
| [ProxyAI](../r/carlrobertoh~proxyai.md) | The leading open-source AI copilot for JetBrains. Connect to any model in any environment, and customize your coding exp | 1,942 | +1 |
| [tabby](../r/tabbyml~tabby.md) | Self-hosted AI coding assistant | 33,923 | -1 |
| [void](../r/voideditor~void.md) | an open-source Cursor alternative, use AI agents on your codebase, checkpoint and visualize changes, and bring any model | 28,714 | -12 |
| [Roo-Code](../r/roocodeinc~roo-code.md) | Roo Code gives you a whole dev team of AI agents in your code editor. | 24,241 | -13 |

[Back to top](#awesome-local-llm)

## Computer Use

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [cua](../r/trycua~cua.md) | Scale computer-use 2.0 with open-source drivers, cross-OS sandboxes, and benchmarks for training, evaluation, and data g | 31,925 | +530 |
| [openwork](../r/different-ai~openwork.md) | The open-source alternative to Claude Cowork (powered by opencode) | 24,434 | +93 |
| [open-interpreter](../r/openinterpreter~open-interpreter.md) | A coding agent for open models like Kimi K3 and GLM 5.3 | 68,824 | +72 |
| [Agent-S](../r/simular-ai~agent-s.md) | Agent S: the state-of-the-art open source computer use agents | 12,897 | +63 |
| [OmniParser](../r/microsoft~omniparser.md) | A simple screen parsing tool towards pure vision based GUI agent | 25,610 | +13 |
| [self-operating-computer](../r/othersideai~self-operating-computer.md) | A framework to enable a multimodal model to operate a computer. | 10,304 | +6 |
| [OpenRoom](../r/minimax-ai~openroom.md) | A browser-based desktop where AI Agent operates every app through natural language. | 1,273 | +1 |

[Back to top](#awesome-local-llm)

## Context Engineering

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Context-Engineering](../r/davidkimai~context-engineering.md) | "Context engineering is the delicate art and science of filling the context window with just the right information for t | 9,277 | +6 |
| [Awesome-Context-Engineering](../r/meirtz~awesome-context-engineering.md) |  🔥 Comprehensive survey on Context Engineering: from prompt engineering to production-grade AI systems. hundreds of pap | 3,336 | +3 |

[Back to top](#awesome-local-llm)

## Explorers, Benchmarks, Leaderboards

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [BullshitBench](../r/petergpt~bullshit-benchmark.md) | BullshitBench measures whether AI models challenge nonsensical prompts instead of confidently answering them, created by | 1,906 | +2 |
| [swe-serve](https://github.com/NVIDIA/swe-serve) | SWE-Serve: an agentic benchmark of 53 production inference-engineering tasks derived from merged SGLang pull requests, r | 23 | +2 |
| [vakra](https://github.com/IBM/vakra) | A Benchmark for Evaluating Multi-Hop, Multi-Source Tool-Calling in AI Agents | 78 | +1 |

[Back to top](#awesome-local-llm)

## Hardware

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [ZLUDA](../r/vosen~zluda.md) | CUDA on non-NVIDIA GPUs | 15,169 | +16 |
| [ai-notes](https://github.com/paudley/ai-notes) | Random AI notes for working with local models or playing around with random machine learning bits. | 63 | +0 |

[Back to top](#awesome-local-llm)

## Inference

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [vLLM Production Stack](../r/vllm-project~production-stack.md) | vLLM’s reference system for K8S-native cluster-wide deployment with community-driven performance optimization | 2,714 | +10 |

[Back to top](#awesome-local-llm)

## Inference engines

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Strata](../r/niko1221~strata.md) | Qwen3.8-Flash-Next on any consumer hardware: one-click install for Windows / Linux. Strata inference engine, OpenAI/Anth | 41,261 | +4,506 |
| [ollama](../r/ollama~ollama.md) | Get up and running with Kimi, GLM, MiniMax, DeepSeek, gpt-oss, Qwen, Gemma and other models. | 186,215 | +787 |
| [llama.cpp](../r/ggml-org~llama.cpp.md) | LLM inference in C/C++ | 133,615 | +679 |
| [vllm](../r/vllm-project~vllm.md) | A high-throughput and memory-efficient inference and serving engine for LLMs | 96,501 | +538 |
| [sglang](../r/sgl-project~sglang.md) | SGLang is a high-performance serving framework for large language models and multimodal models. | 38,552 | +235 |
| [omlx](../r/jundot~omlx.md) | LLM inference server with continuous batching & SSD caching for Apple Silicon — managed from the macOS menu bar | 23,431 | +211 |
| [mlx-vlm](../r/blaizzy~mlx-vlm.md) | MLX-VLM is a package for inference and fine-tuning of Vision Language Models (VLMs) on your Mac using MLX. | 5,815 | +112 |
| [BitNet](../r/microsoft~bitnet.md) | Official inference framework for 1-bit LLMs | 41,492 | +106 |
| [exo](../r/exo-explore~exo.md) | Run frontier AI locally. | 48,231 | +104 |
| [magnitude](../r/magnitudedev~magnitude.md) | Open source inference engine that tunes its kernels on your hardware to find the fastest way to run each model. 2x faste | 7,730 | +103 |
| [Nano-vLLM](../r/geeeekexplorer~nano-vllm.md) | Nano vLLM | 16,334 | +95 |
| [koboldcpp](../r/lostruins~koboldcpp.md) | KoboldCpp - Run GGUF AI models locally with a KoboldAI UI. One File. Zero Install. | 12,181 | +73 |
| [mlx-lm](../r/ml-explore~mlx-lm.md) | Run LLMs with MLX | 7,581 | +66 |
| [LiteRT-LM](../r/google-ai-edge~litert-lm.md) | LiteRT-LM is Google's production-ready, high-performance, open-source inference framework for deploying Large Language M | 6,840 | +56 |
| [tokenspeed](../r/lightseekorg~tokenspeed.md) | TokenSpeed is a speed-of-light LLM inference engine. | 2,885 | +55 |
| [gpustack](../r/gpustack~gpustack.md) | A GPU cluster manager for high-performance AI model serving (vLLM, SGLang) and on-demand SSH-accessible GPU instances. | 5,987 | +54 |
| [TensorRT-LLM](../r/nvidia~tensorrt-llm.md) | TensorRT LLM provides users with an easy-to-use Python API to define Large Language Models (LLMs) and supports state-of- | 15,032 | +50 |
| [mini-sglang](../r/sgl-project~mini-sglang.md) | A compact implementation of SGLang, designed to demystify the complexities of modern LLM serving systems. | 5,531 | +47 |
| [flashinfer](../r/flashinfer-ai~flashinfer.md) | FlashInfer: Kernel Library for LLM Serving | 6,867 | +43 |
| [dynamo](../r/ai-dynamo~dynamo.md) | A Datacenter Scale Distributed Inference Serving Framework | 8,453 | +41 |
| [LiteRT](../r/google-ai-edge~litert.md) | LiteRT, successor to TensorFlow Lite. is Google's On-device framework for high-performance ML & GenAI deployment on edge | 3,576 | +31 |
| [mistral.rs](../r/ericlbuehler~mistral.rs.md) | Fast, flexible LLM inference | 7,816 | +30 |
| [ik_llama.cpp](../r/ikawrakow~ik_llama.cpp.md) | llama.cpp fork with additional SOTA quants and improved performance | 3,379 | +25 |
| [executorch](../r/pytorch~executorch.md) | On-device AI across mobile, embedded and edge for PyTorch | 5,160 | +18 |
| [FastFlowLM](../r/fastflowlm~fastflowlm.md) | Run LLMs on AMD Ryzen™ AI NPUs in minutes; purpose-built and deeply optimized for the AMD NPUs. | 2,024 | +17 |
| [distributed-llama](../r/b4rtaz~distributed-llama.md) | Distributed LLM inference. Connect home devices into a powerful cluster to accelerate LLM inference. More devices means  | 3,132 | +9 |
| [sonar](../r/dphnai~sonar.md) | Large-scale LLM inference engine | 1,904 | +6 |
| [llm-scaler](../r/intel~llm-scaler.md) | run LLMs on Intel Arc™ Pro B60 GPUs | 589 | +2 |
| [krasis](../r/brontoguana~krasis.md) | Krasis is a Hybrid LLM runtime which focuses on efficient running of larger models on consumer grade VRAM limited hardwa | 526 | +1 |
| [vllm-gfx906](../r/nlzy~vllm-gfx906.md) | vLLM for AMD gfx906 GPUs, e.g. Radeon VII / MI50 / MI60 | 436 | +0 |

[Back to top](#awesome-local-llm)

## Inference platforms

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [jan](../r/menloresearch~jan.md) | Jan is an open source alternative to ChatGPT that runs 100% offline on your computer. | 45,544 | +350 |
| [unsloth](../r/unslothai~unsloth.md) | Local UI to run and train LLMs and diffusion models. Supports GGUF, MLX, Qwen3.8, DeepSeek-V4.1, MiniMax-H3, Gemma 4, FL | 79,142 | +298 |
| [LocalAI](../r/mudler~localai.md) | LocalAI is the open-source AI engine. Run any model - LLMs, vision, voice, image, video - on any hardware. No GPU requir | 50,240 | +153 |
| [lemonade](../r/lemonade-sdk~lemonade.md) | Lemonade helps users discover and run local AI apps by serving optimized LLMs right from their own GPUs and NPUs. Join o | 6,133 | +104 |
| [ChatBox](../r/chatboxai~chatbox.md) | Powerful AI Client | 42,267 | +58 |

[Back to top](#awesome-local-llm)

## Memory Management

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [mem0](../r/mem0ai~mem0.md) | The Memory Layer for AI Agents - Drop-in memory infrastructure for AI agents and apps. Context that persists. Built for  | 68,549 | +405 |
| [TencentDB-Agent-Memory](../r/tencentcloud~tencentdb-agent-memory.md) | TencentDB Agent Memory is a team-level memory hub for AI Agents — turning conversations, docs, and code into four reusab | 30,603 | +311 |
| [mempalace](../r/milla-jovovich~mempalace.md) | The best-benchmarked open-source AI memory system. And it's free. | 60,452 | +276 |
| [cognee](../r/topoteretes~cognee.md) | Cognee is the open-source AI memory platform for agents. Give your AI agents persistent long-term memory with small mode | 33,121 | +177 |
| [supermemory](../r/supermemoryai~supermemory.md) | Memory and context engine + app that is extremely fast, scalable, and can be run fully locally. The Memory API for the A | 31,559 | +84 |
| [letta](../r/letta-ai~letta.md) | Platform for stateful agents: AI with advanced memory that can learn and self-improve over time. | 25,373 | +71 |
| [LMCache](../r/lmcache~lmcache.md) | LMCache: Supercharge Your LLM with the Fastest KV Cache Layer | 12,303 | +55 |
| [memU](../r/nevamind-ai~memu.md) | Personal memory across agents | 14,605 | +21 |
| [reasoning-bank](../r/google-research~reasoning-bank.md) | a memory mechanism for agents that learns from both successful and failed trajectories, with reasoning stored as memory  | 640 | +8 |

[Back to top](#awesome-local-llm)

## Miscellaneous

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [context7](../r/upstash~context7.md) | Context7 Platform -- Up-to-date docs for AI agents | 64,311 | +314 |
| [presenton](../r/presenton~presenton.md) | Open-Source AI Presentation Generator and API (Gamma, Canva, Beautiful AI, Decktopus, Presentations AI Alternative) | 11,771 | +206 |
| [deepwiki-open](../r/asyncfuncai~deepwiki-open.md) | Open Source DeepWiki: AI-Powered Wiki Generator for GitHub/Gitlab/Bitbucket Repositories. Join the discord: https://disc | 18,372 | +41 |
| [mobile-use](../r/minitap-ai~mobile-use.md) | AI agents can now use real Android and iOS apps, just like a human. | 3,369 | +26 |
| [speakr](../r/murtaza-nasir~speakr.md) | Speakr is a personal, self-hosted web application designed for transcribing audio recordings | 4,160 | +20 |
| [local-llm](../r/jamesob~local-llm.md) | Everything I know about running LLMs locally | 1,884 | +8 |
| [Observer](../r/roy3838~observer.md) | The agent that monitors anything for you. Open-source, running completely locally. | 1,672 | +8 |
| [promptcat](https://github.com/sevenreasons/promptcat) | A zero-dependency prompt manager/catalog/library in a single HTML file. Everything is stored locally in your browser. Me | 88 | +0 |
| [4o-ghibli-at-home](https://github.com/TheAhmadOsman/4o-ghibli-at-home) | The GPT-4o image generation we have at home. A powerful, self-hosted AI photo stylizer built for performance and privacy | 489 | -1 |
| [gabber](../r/gabber-dev~gabber.md) | Build AI applications that can see, hear, and speak using your screens, microphones, and cameras as inputs. | 1,112 | -1 |
| [cai](../r/aliasrobotics~cai.md) | Cybersecurity AI (CAI), the framework for AI Security | 9,848 | -3 |
| [OmniGen2](../r/vectorspacelab~omnigen2.md) | OmniGen2: Exploration to Advanced Multimodal Generation. https://arxiv.org/abs/2506.18871 | 4,117 | -3 |

[Back to top](#awesome-local-llm)

## Model Context Protocol

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [playwright-mcp](../r/microsoft~playwright-mcp.md) | Playwright MCP server | 39,290 | +405 |
| [chrome-devtools-mcp](../r/chromedevtools~chrome-devtools-mcp.md) | Chrome DevTools for coding agents | 54,914 | +382 |
| [github-mcp-server](../r/github~github-mcp-server.md) | GitHub's official MCP Server | 34,296 | +183 |
| [n8n-mcp](../r/czlonkowski~n8n-mcp.md) | A MCP for Claude Desktop / Claude Code / Windsurf / Cursor to build n8n workflows for you  | 23,225 | +50 |
| [dbhub](../r/bytebase~dbhub.md) | Token conscious database MCP server for Postgres, MySQL, SQL Server, Oracle, MariaDB, SQLite. | 3,804 | +44 |
| [awslabs/mcp](../r/awslabs~mcp.md) | Open source MCP Servers for AWS | 9,890 | +36 |
| [mcp-atlassian](../r/sooperset~mcp-atlassian.md) | MCP server for Atlassian tools (Confluence, Jira) | 6,095 | +24 |
| [mindsdb](../r/mindsdb~mindsdb.md) | The unified workspace where open-source models get things done for you. | 39,847 | +12 |

[Back to top](#awesome-local-llm)

## Models

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [nanochat](../r/karpathy~nanochat.md) | The best ChatGPT that $100 can buy. | 60,348 | +1,209 |
| [llmfit](../r/alexsjones~llmfit.md) | Hundreds of models & providers. One command to find what runs on your hardware. | 38,734 | +229 |
| [llama-swap](../r/mostlygeek~llama-swap.md) | Reliable model swapping for any local AI server. Chosen by thousands of users.  Batteries included. If we don't have it, | 6,205 | +64 |
| [outlines](../r/dottxt-ai~outlines.md) | Structured Outputs | 16,005 | +18 |
| [llguidance](../r/guidance-ai~llguidance.md) | Super-fast Structured Outputs | 907 | +2 |
| [gguf-docs](https://github.com/iuliaturc/gguf-docs) | Docs for GGUF quantization (unofficial) | 524 | +1 |

[Back to top](#awesome-local-llm)

## Prompt Engineering

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [system_prompts_leaks](../r/asgeirtj~system_prompts_leaks.md) | Leaked system prompts of ChatGPT, Claude, Gemini and more. The hidden system prompt of every popular chatbot, in full, e | 70,967 | +457 |
| [Prompt Engineering Guide](../r/dair-ai~prompt-engineering-guide.md) | 🐙 Guides, papers, lessons, notebooks and resources for prompt engineering, context engineering, RAG, and AI Agents. | 79,880 | +189 |
| [system-prompts-and-models-of-ai-tools](../r/x1xhlol~system-prompts-and-models-of-ai-tools.md) | FULL Augment Code, Claude Code, Cluely, CodeBuddy, Comet, Cursor, Devin AI, Junie, Kiro, Leap.new, Lovable, Manus, Notio | 144,533 | +157 |
| [Prompt Engineering by NirDiamant](../r/nirdiamant~prompt_engineering.md) | 22 prompt engineering techniques with hands-on Jupyter Notebook tutorials, from fundamental concepts to advanced strateg | 7,925 | +8 |

[Back to top](#awesome-local-llm)

## Research

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [open-notebook](../r/lfnovo~open-notebook.md) | An Open Source implementation of Notebook LM with more flexibility and features | 41,719 | +683 |
| [Perplexica](../r/itzcrazykns~perplexica.md) | Vane is an AI-powered answering engine. | 38,057 | +176 |
| [gpt-researcher](../r/assafelovic~gpt-researcher.md) | An autonomous agent that conducts deep research on any data using any LLM providers | 30,534 | +137 |
| [RD-Agent](../r/microsoft~rd-agent.md) | Research and development (R&D) is crucial for the enhancement of industrial productivity, especially in the AI era, wher | 15,268 | +116 |
| [SurfSense](../r/modsetter~surfsense.md) | Air-gapped, privacy-focused, open-source NotebookLM alternative. AI agent that researches, transforms, and edits your do | 16,800 | +108 |
| [local-deep-research](../r/learningcircuit~local-deep-research.md) |  ~95% on SimpleQA (e.g. Qwen3.6-27B on a 3090). Supports all local and cloud LLMs (llama.cpp, Ollama, Google, ...). 10+  | 9,514 | +60 |
| [local-deep-researcher](../r/langchain-ai~local-deep-researcher.md) | Fully local web research and report writing assistant | 9,405 | +6 |
| [maestro](../r/murtaza-nasir~maestro.md) | MAESTRO is an AI-powered research application designed to streamline complex research tasks. | 1,500 | +2 |

[Back to top](#awesome-local-llm)

## Retrieval-Augmented Generation

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [graphiti](../r/getzep~graphiti.md) | Build Real-Time Knowledge Graphs for AI Agents | 32,616 | +232 |
| [onyx](../r/onyx-dot-app~onyx.md) | Open Source AI Platform - AI Chat with advanced features that works with every LLM | 33,270 | +153 |
| [LightRAG](../r/hkuds~lightrag.md) | [EMNLP2025] LightRAG: Simple and Fast Retrieval-Augmented Generation | 40,594 | +142 |
| [pipeshub-ai](../r/pipeshub-ai~pipeshub-ai.md) | The open-source context layer for AI agents. PipesHub turns your company's knowledge (Slack, Drive, Jira, GitHub, Micros | 4,036 | +139 |
| [RAG Techniques](../r/nirdiamant~rag_techniques.md) | This repository showcases various advanced techniques for Retrieval-Augmented Generation (RAG) systems. Each technique h | 30,262 | +107 |
| [graphrag](../r/microsoft~graphrag.md) | A modular graph-based Retrieval-Augmented Generation (RAG) system | 36,589 | +86 |
| [haystack](../r/deepset-ai~haystack.md) | Open-source AI orchestration framework for building context-engineered, production-ready LLM applications. Design modula | 26,941 | +47 |
| [claude-context](../r/zilliztech~claude-context.md) | Code search MCP for Claude Code. Make entire codebase the context for any coding agent. | 12,674 | +13 |
| [vanna](../r/vanna-ai~vanna.md) | 🤖 Chat with your SQL database 📊. Accurate Text-to-SQL Generation via LLMs using Agentic Retrieval 🔄. | 23,805 | +3 |
| [Controllable RAG Agent](../r/nirdiamant~controllable-rag-agent.md) | This repository provides an advanced Retrieval-Augmented Generation (RAG) solution for complex question answering. It us | 1,629 | +2 |
| [LangChain RAG Cookbook](https://github.com/lokeswaran-aj/langchain-rag-cookbook) | a collection of modular RAG techniques, implemented in LangChain + Python | 38 | +0 |
| [Pathway AI Pipelines](../r/pathwaycom~llm-app.md) | A no-code RAG server that keeps answers in sync with your documents. Works with 8 vector databases. Built on Pathway. | 58,724 | -27 |
| [pathway](../r/pathwaycom~pathway.md) | Python ETL framework for stream processing, real-time analytics, LLM pipelines, and RAG. | 62,013 | -28 |

[Back to top](#awesome-local-llm)

## Security and Sandboxing

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [OpenShell](../r/nvidia~openshell.md) | OpenShell is the safe, private runtime for autonomous AI agents. | 21,235 | +434 |
| [garak](../r/nvidia~garak.md) | the LLM vulnerability scanner | 9,914 | +104 |
| [CubeSandbox](../r/tencentcloud~cubesandbox.md) | Instant, Concurrent, Secure & Lightweight Sandbox for AI Agents. | 13,187 | +76 |
| [Guardrails](../r/nvidia-nemo~guardrails.md) | NeMo Guardrails is an open-source toolkit for easily adding programmable guardrails to LLM-based conversational systems. | 7,446 | +45 |
| [OpenAPPA](../r/archestra-ai~openappa.md) | Deterministic guardrails that don't break agents | 1,619 |  |

[Back to top](#awesome-local-llm)

## Testing, Evaluation and Observability

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [langfuse](../r/langfuse~langfuse.md) | 🪢 Open source agent evals & observability: Trace, evaluate, and improve LLM applications with one open platform. | 37,125 | +339 |
| [opik](../r/comet-ml~opik.md) | Debug, evaluate, and monitor your LLM applications, RAG systems, and agentic workflows with comprehensive tracing, autom | 23,239 | +179 |
| [openllmetry](../r/traceloop~openllmetry.md) | Open-source observability for your GenAI or LLM application, based on OpenTelemetry | 7,525 | +12 |
| [agenta](../r/agenta-ai~agenta.md) | Agenta is a workspace where you and your team build agents and automations. | 4,889 | +11 |
| [giskard](../r/giskard-ai~giskard.md) | 🐢 Open-Source Evaluation & Testing library for LLM Agents | 5,946 | +9 |
| [Evaluator](../r/nvidia-nemo~evaluator.md) | Open-source library for scalable, reproducible evaluation of AI models and benchmarks. | 359 | +1 |

[Back to top](#awesome-local-llm)

## Training and Fine-tuning

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [heretic](../r/p-e-w~heretic.md) | Training-free language model modification: Remove censorship, suppress slop, reduce sycophancy, and more | 39,824 | +2,567 |
| [trl](../r/huggingface~trl.md) | Train transformer language models with reinforcement learning. | 19,684 | +49 |
| [slime](../r/thudm~slime.md) | slime is an LLM training framework for RL Scaling. | 8,807 | +37 |
| [miles](../r/radixark~miles.md) | Miles is an enterprise-facing reinforcement learning framework for LLM and VLM post-training, forked from and co-evolvin | 3,277 | +32 |
| [sentence-transformers](../r/huggingface~sentence-transformers.md) | State-of-the-Art Embeddings, Retrieval, and Reranking | 19,266 | +28 |
| [RL](../r/nvidia-nemo~rl.md) | Scalable toolkit for efficient model reinforcement | 2,117 | +22 |
| [SpecForge](../r/sgl-project~specforge.md) | Train speculative decoding models effortlessly and port them smoothly to SGLang serving. | 1,269 | +18 |
| [Gym](../r/nvidia-nemo~gym.md) | Evaluate and improve models and agents using environments | 1,322 | +17 |
| [OpenEnv](../r/meta-pytorch~openenv.md) | An interface library for RL post training with environments.  | 2,836 | +17 |
| [OpenRLHF](../r/openrlhf~openrlhf.md) | An Easy-to-use, Scalable and High-performance Agentic RL Framework based on Ray (PPO & DAPO & REINFORCE++ &  VLM & TIS & | 10,144 | +13 |
| [Kiln](../r/kiln-ai~kiln.md) | Build, Evaluate, and Optimize AI Systems. Includes evals, RAG, agents, fine-tuning, synthetic data generation, dataset m | 5,259 | +12 |
| [augmentoolkit](../r/e-p-armstrong~augmentoolkit.md) | Create Custom LLMs | 1,876 | +5 |

[Back to top](#awesome-local-llm)

## User Interfaces

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Lobe Chat](../r/lobehub~lobe-chat.md) | 🤯 LobeHub - Super-Agents on Your Team. Add super-agents to the chats your team already uses.They take on work by themse | 84,290 | +657 |
| [Open WebUI](../r/open-webui~open-webui.md) | User-friendly AI Interface (Supports Ollama, OpenAI API, ...) | 157,985 | +640 |
| [SillyTavern](../r/sillytavern~sillytavern.md) | LLM Frontend for Power Users. | 35,365 | +218 |
| [Page Assist](../r/n4ze3m~page-assist.md) | Use your locally running AI models to assist you in your web browsing | 8,318 | +20 |
| [Text generation web UI](../r/oobabooga~text-generation-webui.md) | Open-source desktop app for local LLMs. Text, vision, tool-calling, OpenAI/Anthropic-compatible API. 100% private. | 47,736 | +6 |

[Back to top](#awesome-local-llm)

---
*Updated: 2026-11-07 | [View live site ↗](https://patrickclery.com/awesomer/l/local-llm/)*
