import { AiAgentsReadmeParser } from '../ai-agents-readme-parser.js';

// Mock README simulating the awesome-ai-agents format with 10+ representative entries
const MOCK_README = `<h1 align="center">Awesome AI Agents</h1>
<h3 align="center">A curated list of AI agents</h3>

Some intro text about the list.

# Open-source projects

## [Adala](https://github.com/HumanSignal/Adala)
Adala: Autonomous Data (Labeling) Agent framework

<details>

![Image](https://github.com/HumanSignal/Adala/raw/master/docs/src/img/logo-dark-mode.png)

### Category
General purpose, Build your own, Multi-agent

### Description

- **Reliable agents**: Built on ground truth data for consistent, trustworthy results.
- **Controllable output**: Tailor output with flexible constraints to fit your needs.

### Links
- [Documentation](https://humansignal.github.io/Adala/)
- [Discord](https://discord.gg/QBtgTbXTgU)
- [GitHub](https://github.com/HumanSignal/Adala)
</details>

## [AgentGPT](https://agentgpt.reworkd.ai/)
Browser-based no-code version of AutoGPT

<details>

### Category
General purpose, Web

### Description
AgentGPT allows you to configure and deploy Autonomous AI agents.

### Links
- [Website](https://agentgpt.reworkd.ai/)
- [GitHub](https://github.com/reworkd/AgentGPT)
- [Discord](https://discord.gg/gcmNyAAFfV)
</details>

## [AutoGPT](https://agpt.co/?utm_source=awesome-ai-agents)
An experimental open-source attempt to make GPT-4 fully autonomous

<details>

### Category
General purpose, Autonomous

### Description
AutoGPT is one of the first examples of GPT-4 running fully autonomously.

### Links
- [GitHub](https://github.com/Significant-Gravitas/AutoGPT)
- [Documentation](https://docs.agpt.co/)
</details>

## [Clippy](https://github.com/ennucore/clippy/)
A coding assistant

<details>

### Category
Coding

### Description
Clippy is a code-writing assistant.

### Links
- [GitHub](https://github.com/ennucore/clippy)
</details>

## [NoDescProject](https://github.com/testorg/no-desc)

<details>

### Category
General purpose

### Links
- [GitHub](https://github.com/testorg/no-desc)
</details>

## [WebsiteOnlyNoGitHub](https://example.com/some-tool)
A tool with no GitHub link at all

<details>

### Category
General purpose

### Links
- [Website](https://example.com/some-tool)
- [Twitter](https://twitter.com/sometool)
</details>

## [BabyFoxAGI](https://github.com/yoheinakajima/babyagi/tree/main/classic/babyfoxagi)
A task management framework

<details>

### Category
General purpose

### Description
BabyFoxAGI is a task management framework.

### Links
- [GitHub](https://github.com/yoheinakajima/babyagi/tree/main/classic/babyfoxagi)
</details>

## [DuplicateCatProject](https://github.com/testorg/dup-cat)
A project with duplicate category headers

<details>

### Category
General purpose

### Category
Multi-agent

### Links
- [GitHub](https://github.com/testorg/dup-cat)
</details>

## [ReactAgentAnomalyProject](https://github.com/testorg/react-agent)
A project with ## Links instead of ### Links

<details>

## Description
Uses H2 instead of H3 for Description.

## Links
- [GitHub](https://github.com/testorg/react-agent)
</details>

## [MultiLinkProject](https://projectsite.io)
A project with multiple GitHub links in details

<details>

### Category
Tools

### Links
- [Website](https://projectsite.io)
- [GitHub (Main)](https://github.com/testorg/multi-link)
- [GitHub (Docs)](https://github.com/testorg/multi-link-docs)
</details>

# Closed-source projects and companies

## [ClosedSourceTool](https://closedsource.ai)
An AI tool that is closed-source

<details>

### Category
Productivity

### Description
This is a closed-source tool.

### Links
- [Website](https://closedsource.ai)
</details>

## [AnotherClosed](https://anotherclosed.io)
Another closed-source product

<details>

### Links
- [Website](https://anotherclosed.io)
</details>

# Build your agent with E2B

### :eight_pointed_black_star: [E2BTool](https://e2b.dev)
E2B integration tool

<details>

### Links
- [GitHub](https://github.com/e2b-dev/e2b)
</details>
`;

describe('AiAgentsReadmeParser', () => {
  const parser = new AiAgentsReadmeParser();
  const result = parser.parse(MOCK_README);

  it('creates exactly one category: Open Source AI Agents', () => {
    expect(result.categories).toHaveLength(1);
    expect(result.categories[0]).toEqual({ name: 'Open Source AI Agents', order: 0 });
  });

  it('parses Adala with correct name', () => {
    const adala = result.items.find((i) => i.name === 'Adala');
    expect(adala).toBeDefined();
    expect(adala!.name).toBe('Adala');
  });

  it('parses Adala with correct githubRepo', () => {
    const adala = result.items.find((i) => i.name === 'Adala');
    expect(adala!.githubRepo).toBe('HumanSignal/Adala');
    expect(adala!.primaryUrl).toBe('https://github.com/HumanSignal/Adala');
  });

  it('parses Adala description containing "Autonomous Data (Labeling) Agent framework"', () => {
    const adala = result.items.find((i) => i.name === 'Adala');
    expect(adala!.description).toContain('Autonomous Data (Labeling) Agent framework');
  });

  it('extracts GitHub repo from ### Links when H2 URL is a website', () => {
    const agentgpt = result.items.find((i) => i.name === 'AgentGPT');
    expect(agentgpt).toBeDefined();
    expect(agentgpt!.githubRepo).toBe('reworkd/AgentGPT');
    expect(agentgpt!.primaryUrl).toBe('https://github.com/reworkd/AgentGPT');
    expect(agentgpt!.description).toBe('Browser-based no-code version of AutoGPT');
  });

  it('strips query params from URLs before parsing', () => {
    const autogpt = result.items.find((i) => i.name === 'AutoGPT');
    expect(autogpt).toBeDefined();
    expect(autogpt!.githubRepo).toBe('Significant-Gravitas/AutoGPT');
    expect(autogpt!.primaryUrl).toBe('https://github.com/Significant-Gravitas/AutoGPT');
  });

  it('handles trailing slashes in GitHub URLs', () => {
    const clippy = result.items.find((i) => i.name === 'Clippy');
    expect(clippy).toBeDefined();
    expect(clippy!.githubRepo).toBe('ennucore/clippy');
    expect(clippy!.primaryUrl).toBe('https://github.com/ennucore/clippy');
  });

  it('handles entries with no description line', () => {
    const noDesc = result.items.find((i) => i.name === 'NoDescProject');
    expect(noDesc).toBeDefined();
    expect(noDesc!.githubRepo).toBe('testorg/no-desc');
    expect(noDesc!.description).toBeNull();
  });

  it('skips entries with no valid GitHub repo URL', () => {
    const websiteOnly = result.items.find((i) => i.name === 'WebsiteOnlyNoGitHub');
    expect(websiteOnly).toBeUndefined();
  });

  it('skips entries with tree/blob paths (BabyFoxAGI-style)', () => {
    const babyFox = result.items.find((i) => i.name === 'BabyFoxAGI');
    expect(babyFox).toBeUndefined();
  });

  it('handles duplicate category headers inside details', () => {
    const dupCat = result.items.find((i) => i.name === 'DuplicateCatProject');
    expect(dupCat).toBeDefined();
    expect(dupCat!.githubRepo).toBe('testorg/dup-cat');
  });

  it('parses entries where H2 URL uses website but GitHub is in ### Links', () => {
    const multiLink = result.items.find((i) => i.name === 'MultiLinkProject');
    expect(multiLink).toBeDefined();
    expect(multiLink!.githubRepo).toBe('testorg/multi-link');
    expect(multiLink!.primaryUrl).toBe('https://github.com/testorg/multi-link');
  });

  it('does NOT include closed-source entries', () => {
    const closedTool = result.items.find((i) => i.name === 'ClosedSourceTool');
    const anotherClosed = result.items.find((i) => i.name === 'AnotherClosed');
    expect(closedTool).toBeUndefined();
    expect(anotherClosed).toBeUndefined();
  });

  it('does NOT include E2B section entries', () => {
    const e2b = result.items.find((i) => i.name === 'E2BTool');
    expect(e2b).toBeUndefined();
  });

  it('assigns all items to the open-source category (index 0)', () => {
    for (const item of result.items) {
      expect(item.categoryIndex).toBe(0);
    }
  });

  it('parses the correct total number of open-source items with valid GitHub repos', () => {
    // Expected: Adala, AgentGPT, AutoGPT, Clippy, NoDescProject, DuplicateCatProject,
    //           ReactAgentAnomalyProject, MultiLinkProject
    // Excluded: WebsiteOnlyNoGitHub (no GitHub), BabyFoxAGI (tree path),
    //           ClosedSourceTool, AnotherClosed (closed section), E2BTool (E2B section)
    expect(result.items).toHaveLength(8);
  });
});
