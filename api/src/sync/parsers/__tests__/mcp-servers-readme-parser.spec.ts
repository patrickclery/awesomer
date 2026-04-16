import { McpServersReadmeParser } from '../mcp-servers-readme-parser.js';

const MOCK_README = `# Awesome MCP Servers

[![awesome badge](https://awesome.re/badge.svg)](https://awesome.re)

A curated list of awesome MCP servers.

## What is MCP?

The Model Context Protocol lets you build servers that expose data and functionality to LLM applications.

- [MCP Specification](https://spec.modelcontextprotocol.io/) - The official specification

## Clients

| Client | Resources |
| --- | --- |
| Claude Desktop | Yes |

## Tutorials

- [Tutorial One](https://youtube.com/watch?v=abc) - A tutorial

## Community

- [Discord](https://discord.gg/mcp) - Community chat

## Legend

- 🤖 Emoji one
- 📇 Emoji two
- 🏠 Emoji three

## Server Implementations

> Servers are listed in the following categories.

- [Aggregators](#aggregators)
- [Cloud Platforms](#cloud-platforms)
- [Biology, Medicine and Bioinformatics](#bio)

### 🔗 <a name="aggregators"></a>Aggregators

MCP servers that aggregate multiple services.

- [acme/mcp-aggregator](https://github.com/acme/mcp-aggregator) 🤖 📇 - An aggregation tool for MCP servers.
- [acme/mcp-hub](https://github.com/acme/mcp-hub) [![Glama](https://glama.ai/mcp/servers/badge.svg)](https://glama.ai/mcp/servers/abc123) 🤖 - A central hub for MCP servers.
- [non-github-tool](https://gitlab.com/acme/non-github) - Should be skipped because not GitHub.
- [deep-link](https://github.com/acme/repo/blob/main/README.md) - Should be skipped because deep link.

### ☁️ <a name="cloud-platforms"></a>Cloud Platforms

Cloud platform integrations for MCP.

- [acme/cloud-mcp](https://github.com/acme/cloud-mcp) 🤖 - Cloud platform integration for MCP.

### <a name="bio"></a>Biology, Medicine and Bioinformatics

Biology-related MCP servers.

- [acme/bio-mcp](https://github.com/acme/bio-mcp) 🤖 📇 - A biology MCP server.

### 🔗 <a name="aggregators-2"></a>Aggregators

Duplicate aggregators section that should merge with the first one.

- [acme/mcp-collector](https://github.com/acme/mcp-collector) 🤖 - Collects MCP server data.

## Frameworks

MCP frameworks and SDKs.

- [acme/mcp-framework](https://github.com/acme/mcp-framework) 🤖 - A framework for building MCP servers.
- [acme/mcp-sdk](https://github.com/acme/mcp-sdk) [![Glama](https://glama.ai/mcp/servers/badge.svg)](https://glama.ai/mcp/servers/def456) 🤖 - An SDK for MCP.

## Tips and Tricks

### Official prompt to inform LLMs how to use MCP

Here is the official prompt for informing LLMs about MCP.

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=punkpeye/awesome-mcp-servers)](https://star-history.com/#punkpeye/awesome-mcp-servers)
`;

describe('McpServersReadmeParser', () => {
  const parser = new McpServersReadmeParser();
  const result = parser.parse(MOCK_README);

  it('strips HTML anchor tags from category names', () => {
    const categoryNames = result.categories.map((c) => c.name);
    expect(categoryNames).toContain('Aggregators');
    // Should not contain raw HTML
    for (const name of categoryNames) {
      expect(name).not.toMatch(/<[^>]*>/);
    }
  });

  it('strips emoji and variation selectors from category names', () => {
    const categoryNames = result.categories.map((c) => c.name);
    expect(categoryNames).toContain('Cloud Platforms');
    // No category name should start with emoji
    for (const name of categoryNames) {
      expect(name).not.toMatch(/^[\p{Emoji_Presentation}\uFE0F]/u);
    }
  });

  it('handles category without emoji prefix', () => {
    const categoryNames = result.categories.map((c) => c.name);
    expect(categoryNames).toContain('Biology, Medicine and Bioinformatics');
  });

  it('deduplicates categories with identical normalized names', () => {
    const aggregatorCategories = result.categories.filter((c) => c.name === 'Aggregators');
    expect(aggregatorCategories).toHaveLength(1);
  });

  it('merges items from duplicate category headers into the same categoryIndex', () => {
    const aggIndex = result.categories.findIndex((c) => c.name === 'Aggregators');
    const aggItems = result.items.filter((i) => i.categoryIndex === aggIndex);
    // Should have items from both Aggregators sections: mcp-aggregator, mcp-hub, mcp-collector
    expect(aggItems).toHaveLength(3);
    const names = aggItems.map((i) => i.name);
    expect(names).toContain('acme/mcp-aggregator');
    expect(names).toContain('acme/mcp-hub');
    expect(names).toContain('acme/mcp-collector');
  });

  it('only creates categories from Server Implementations and Frameworks sections', () => {
    const categoryNames = result.categories.map((c) => c.name);
    expect(categoryNames).not.toContain('What is MCP?');
    expect(categoryNames).not.toContain('Legend');
    expect(categoryNames).not.toContain('Star History');
    expect(categoryNames).not.toContain('Tips and Tricks');
    expect(categoryNames).not.toContain('Clients');
    expect(categoryNames).not.toContain('Tutorials');
    expect(categoryNames).not.toContain('Community');
    expect(categoryNames).not.toContain('Official prompt to inform LLMs how to use MCP');
  });

  it('creates a Frameworks category for items under ## Frameworks', () => {
    const categoryNames = result.categories.map((c) => c.name);
    expect(categoryNames).toContain('Frameworks');
  });

  it('assigns Frameworks items to the Frameworks category', () => {
    const fwIndex = result.categories.findIndex((c) => c.name === 'Frameworks');
    const fwItems = result.items.filter((i) => i.categoryIndex === fwIndex);
    expect(fwItems).toHaveLength(2);
    const names = fwItems.map((i) => i.name);
    expect(names).toContain('acme/mcp-framework');
    expect(names).toContain('acme/mcp-sdk');
  });

  it('parses standard items with name, URL, githubRepo, and description', () => {
    const item = result.items.find((i) => i.name === 'acme/mcp-aggregator');
    expect(item).toBeDefined();
    expect(item!.primaryUrl).toBe('https://github.com/acme/mcp-aggregator');
    expect(item!.githubRepo).toBe('acme/mcp-aggregator');
    expect(item!.description).toBe('An aggregation tool for MCP servers.');
  });

  it('parses items with Glama badge correctly (badge text is not the name)', () => {
    const item = result.items.find((i) => i.name === 'acme/mcp-hub');
    expect(item).toBeDefined();
    expect(item!.primaryUrl).toBe('https://github.com/acme/mcp-hub');
    expect(item!.githubRepo).toBe('acme/mcp-hub');
    expect(item!.description).toBe('A central hub for MCP servers.');
  });

  it('skips non-GitHub URLs', () => {
    const nonGitHub = result.items.find((i) => i.name === 'non-github-tool');
    expect(nonGitHub).toBeUndefined();
  });

  it('skips deep GitHub links via SKIP_URL', () => {
    const deepLink = result.items.find((i) => i.name === 'deep-link');
    expect(deepLink).toBeUndefined();
  });

  it('does NOT create a category for "Official prompt to inform LLMs how to use MCP"', () => {
    const categoryNames = result.categories.map((c) => c.name);
    expect(categoryNames).not.toContain('Official prompt to inform LLMs how to use MCP');
  });

  it('assigns sequential order to categories', () => {
    for (let i = 0; i < result.categories.length; i++) {
      expect(result.categories[i].order).toBe(i);
    }
  });

  it('parses the correct total number of valid GitHub items', () => {
    // Aggregators: mcp-aggregator, mcp-hub (from section 1) + mcp-collector (from section 2) = 3
    // Cloud Platforms: cloud-mcp = 1
    // Biology: bio-mcp = 1
    // Frameworks: mcp-framework, mcp-sdk = 2
    // Skipped: non-github-tool (non-GitHub), deep-link (/blob/ deep link)
    expect(result.items).toHaveLength(7);
  });

  it('creates the correct total number of categories', () => {
    // Aggregators (deduplicated), Cloud Platforms, Biology Medicine and Bioinformatics, Frameworks = 4
    expect(result.categories).toHaveLength(4);
  });

  it('does not include items from skipped sections', () => {
    // MCP Specification from "What is MCP?" section should not be imported
    const spec = result.items.find((i) => i.name === 'MCP Specification');
    expect(spec).toBeUndefined();
  });
});
