import { OpensourceAiReadmeParser } from '../opensource-ai-readme-parser.js';

const MOCK_README = `# Awesome Open Source AI

A comprehensive list of open-source AI tools, frameworks, and models.

## Contents

- [Core Frameworks & Libraries](#1-core-frameworks--libraries)
- [NLP & Language](#2-nlp--language)
- [Contributing](#contributing)

### 1. Core Frameworks & Libraries

#### Deep Learning Frameworks

- **[PyTorch](https://github.com/pytorch/pytorch)** ![GitHub stars](https://img.shields.io/github/stars/pytorch/pytorch?style=social) - An open source machine learning framework.
- **[TensorFlow](https://github.com/tensorflow/tensorflow)** ![GitHub stars](https://img.shields.io/github/stars/tensorflow/tensorflow?style=social) - An end-to-end open source platform for machine learning.
- **[SomeRepo](https://github.com/owner/somerepo)** ![GitHub stars](https://img.shields.io/github/stars/owner/somerepo?style=social)
- **[NonGitHub](https://huggingface.co/some-model)** ![badge](https://img.shields.io/badge/foo) - A non-GitHub item that should be skipped.
- **[TreeLink](https://github.com/owner/repo/tree/main/subdir)** ![badge](https://img.shields.io/badge/foo) - A deep link that should be skipped.

#### Rust ML Frameworks

- **[Candle](https://github.com/huggingface/candle)** ![GitHub stars](https://img.shields.io/github/stars/huggingface/candle?style=social) - Minimalist ML framework for Rust.

### 2. NLP & Language

#### Transformers

- **[Transformers](https://github.com/huggingface/transformers)** ![GitHub stars](https://img.shields.io/github/stars/huggingface/transformers?style=social) - State-of-the-art Machine Learning for PyTorch, TensorFlow, and JAX.

#### Text Generation

- **[vLLM](https://github.com/vllm-project/vllm)** ![GitHub stars](https://img.shields.io/github/stars/vllm-project/vllm?style=social) - A high-throughput and memory-efficient inference engine.

### Contributing

Please read the contributing guidelines.

### License

MIT License
`;

// Today's upstream format (alvinreal/awesome-opensource-ai @ 51a67d5, CC0-1.0).
// Real lines are copied verbatim; the four lines after TensorFlow and the
// Contrib Bot line are synthetic edge cases.
const CURRENT_FORMAT_README = `# Awesome Open Source AI

## Contents

- [1. Core Frameworks & Libraries](#1-core-frameworks--libraries)

## About this list

Awesome Open Source AI is a curated list of open-source projects for people building with AI.

## 1. Core Frameworks & Libraries

> Core libraries and frameworks used to build, train, and run AI and machine learning systems.

#### Deep Learning Frameworks

- [PyTorch](https://github.com/pytorch/pytorch) - Dynamic computation graphs, Pythonic API, dominant in research and production. The current standard for most frontier AI work. ![GitHub stars](https://img.shields.io/github/stars/pytorch/pytorch?style=social)
- [TensorFlow](https://github.com/tensorflow/tensorflow) - End-to-end platform with excellent production deployment, TPU support, and large-scale serving tools. ![GitHub stars](https://img.shields.io/github/stars/tensorflow/tensorflow?style=social)
- [InlineBadge](https://github.com/owner/inline-badge) - Before badge ![GitHub stars](https://img.shields.io/github/stars/owner/inline-badge?style=social) after badge.
- [BadgeOnly](https://github.com/owner/badge-only) - ![GitHub stars](https://img.shields.io/github/stars/owner/badge-only?style=social)
- [NoDesc](https://github.com/owner/no-desc) ![GitHub stars](https://img.shields.io/github/stars/owner/no-desc?style=social)
- [Linked](https://github.com/owner/linked) - Linked badge text [![CI](https://img.shields.io/badge/ci-passing-green)](https://github.com/owner/linked/actions)

## 2. Model Codebases & Model Families

> Canonical model-family repositories with useful code, recipes, evaluation tools, or engineering context. This is not a complete model leaderboard; use Hugging Face and model hubs for up-to-date weight discovery.

#### Language Model Families

- [RWKV](https://github.com/BlinkDL/RWKV-LM) - Attention-free language model architecture with linear-time inference, training code, inference examples, and an active open-source ecosystem. ![GitHub stars](https://img.shields.io/github/stars/BlinkDL/RWKV-LM?style=social)

## Contributing

- [Contrib Bot](https://github.com/owner/contrib-bot) - Should never be imported.
`;

describe('current upstream format (51a67d5)', () => {
  const result = new OpensourceAiReadmeParser().parse(CURRENT_FORMAT_README);
  const byName = (name: string) => result.items.find((i) => i.name === name);

  it('strips the trailing star badge from the PyTorch description', () => {
    expect(byName('PyTorch')!.description).toBe(
      'Dynamic computation graphs, Pythonic API, dominant in research and production. The current standard for most frontier AI work.',
    );
  });

  it('strips the trailing star badge from the TensorFlow description', () => {
    expect(byName('TensorFlow')!.description).toBe(
      'End-to-end platform with excellent production deployment, TPU support, and large-scale serving tools.',
    );
  });

  it('strips an inline badge and keeps the text around it', () => {
    expect(byName('InlineBadge')!.description).toBe(
      'Before badge after badge.',
    );
  });

  it('sets description to null when the description is only badge markup', () => {
    expect(byName('BadgeOnly')!.description).toBeNull();
  });

  it('sets description to null when a badge follows the link with no separator', () => {
    expect(byName('NoDesc')).toBeDefined();
    expect(byName('NoDesc')!.description).toBeNull();
  });

  it('strips a linked badge', () => {
    expect(byName('Linked')!.description).toBe('Linked badge text');
  });
});

describe('badge markup never survives in a description', () => {
  it.each([
    ['MOCK_README', MOCK_README],
    ['CURRENT_FORMAT_README', CURRENT_FORMAT_README],
  ])('%s', (_label, readme) => {
    const { items } = new OpensourceAiReadmeParser().parse(readme);
    expect(items.length).toBeGreaterThan(0);
    for (const item of items) {
      expect(item.description ?? '').not.toContain('![');
      expect(item.description ?? '').not.toContain('img.shields.io');
    }
  });
});

describe('OpensourceAiReadmeParser', () => {
  const parser = new OpensourceAiReadmeParser();
  const result = parser.parse(MOCK_README);

  it('parses bold-wrapped item with badge and extracts name, URL, githubRepo, AND description', () => {
    const pytorch = result.items.find((i) => i.name === 'PyTorch');
    expect(pytorch).toBeDefined();
    expect(pytorch!.primaryUrl).toBe('https://github.com/pytorch/pytorch');
    expect(pytorch!.githubRepo).toBe('pytorch/pytorch');
    expect(pytorch!.description).toBe(
      'An open source machine learning framework.',
    );
  });

  it('sets description to null when no description after badge', () => {
    const someRepo = result.items.find((i) => i.name === 'SomeRepo');
    expect(someRepo).toBeDefined();
    expect(someRepo!.githubRepo).toBe('owner/somerepo');
    expect(someRepo!.description).toBeNull();
  });

  it('skips non-GitHub URLs', () => {
    const nonGitHub = result.items.find((i) => i.name === 'NonGitHub');
    expect(nonGitHub).toBeUndefined();
  });

  it('skips /tree/ deep links via SKIP_URL', () => {
    const treeLink = result.items.find((i) => i.name === 'TreeLink');
    expect(treeLink).toBeUndefined();
  });

  it('skips h1 title heading as a category', () => {
    const categoryNames = result.categories.map((c) => c.name);
    expect(categoryNames).not.toContain('Awesome Open Source AI');
  });

  it('skips Contents and Contributing headers', () => {
    const categoryNames = result.categories.map((c) => c.name);
    expect(categoryNames).not.toContain('Contents');
    expect(categoryNames).not.toContain('Contributing');
  });

  it('skips License header', () => {
    const categoryNames = result.categories.map((c) => c.name);
    expect(categoryNames).not.toContain('License');
  });

  it('creates categories from h3 headings with number prefix stripped', () => {
    const categoryNames = result.categories.map((c) => c.name);
    expect(categoryNames).toContain('Core Frameworks & Libraries');
    expect(categoryNames).toContain('NLP & Language');
    // Should NOT contain the number prefix version
    expect(categoryNames).not.toContain('1. Core Frameworks & Libraries');
    expect(categoryNames).not.toContain('2. NLP & Language');
  });

  it('creates categories from h4 headings', () => {
    const categoryNames = result.categories.map((c) => c.name);
    expect(categoryNames).toContain('Deep Learning Frameworks');
    expect(categoryNames).toContain('Rust ML Frameworks');
    expect(categoryNames).toContain('Transformers');
    expect(categoryNames).toContain('Text Generation');
  });

  it('assigns items to their nearest h4 subcategory, not the parent h3', () => {
    const deepLearningIdx = result.categories.findIndex(
      (c) => c.name === 'Deep Learning Frameworks',
    );
    const pytorch = result.items.find((i) => i.name === 'PyTorch');
    const tensorflow = result.items.find((i) => i.name === 'TensorFlow');
    expect(pytorch!.categoryIndex).toBe(deepLearningIdx);
    expect(tensorflow!.categoryIndex).toBe(deepLearningIdx);

    const rustIdx = result.categories.findIndex(
      (c) => c.name === 'Rust ML Frameworks',
    );
    const candle = result.items.find((i) => i.name === 'Candle');
    expect(candle!.categoryIndex).toBe(rustIdx);
  });

  it('parses the correct total number of valid GitHub items', () => {
    // PyTorch, TensorFlow, SomeRepo, Candle, Transformers, vLLM = 6
    // Excluded: NonGitHub (non-GitHub URL), TreeLink (deep link)
    expect(result.items).toHaveLength(6);
  });

  it('assigns sequential order to categories', () => {
    for (let i = 0; i < result.categories.length; i++) {
      expect(result.categories[i].order).toBe(i);
    }
  });

  it('creates the correct total number of categories', () => {
    // h3: Core Frameworks & Libraries, NLP & Language
    // h4: Deep Learning Frameworks, Rust ML Frameworks, Transformers, Text Generation
    // Excluded: h1 title, h2 Contents, h3 Contributing, h3 License
    expect(result.categories).toHaveLength(6);
  });
});
