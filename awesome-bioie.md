# awesome-bioie

🧫 A curated list of resources relevant to doing Biomedical Information Extraction (including BioNLP)

## Datasets

- [CORD-19](https://github.com/allenai/cord19) - A corpus of scholarly manuscripts concerning COVID-19. Articles are primarily from PubMed Central and preprint servers, though the set also includes metadata on papers without full-text availability.
- [CRAFT](https://github.com/UCDenver-ccp/CRAFT) - [paper](https://link.springer.com/chapter/10.1007/978-94-024-0881-2_53) - 67 full-text biomedical articles annotated in a variety of ways, including for concepts and coreferences. Now on version 5, including annotations linking concepts to the MONDO disease ontology.

## Tools, Platforms, and Services

- [DeepPhe](https://github.com/DeepPhe/DeepPhe-Release) - A system for processing documents describing cancer presentations. Based on cTAKES (see above).
- [Pubrunner](https://github.com/jakelever/pubrunner) - A framework for running text mining tools on the newest set(s) of documents from PubMed.
- [SemEHR](https://github.com/CogStack/CogStack-SemEHR) - [paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6019046/) - an IE infrastructure for electronic health records (EHR). Built on the [CogStack project](https://github.com/CogStack).
- [TabInOut](https://github.com/nikolamilosevic86/TabInOut) - [paper](https://link.springer.com/article/10.1007/s10032-019-00317-0) - a framework for IE from tables in the literature.
- [Anafora](https://github.com/weitechen/anafora) - [paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5657237/) - An annotation tool with adjudication and progress tracking features.

## Code Libraries

- [Bio-SCoRes](https://github.com/kilicogluh/Bio-SCoRes) - [paper](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0148538) - A framework for biomedical coreference resolution.
- [medaCy](https://github.com/NLPatVCU/medaCy) - A system for building predictive medical natural language processing models. Built on the [spaCy](https://spacy.io/) framework.
- [ScispaCy](https://github.com/allenai/SciSpaCy) - [paper](https://arxiv.org/abs/1902.07669) - A version of the [spaCy](https://spacy.io/) framework for scientific and biomedical documents.
- [rentrez](https://github.com/ropensci/rentrez) - R utilities for accessing NCBI resources, including PubMed.
- [mimic-code](https://github.com/MIT-LCP/mimic-code) - Code associated with the MIMIC-III dataset (see below). Includes some helpful [tutorials](https://github.com/MIT-LCP/mimic-code/tree/master/tutorials). [Back to Top](#contents)

## Techniques and Models

- [BioBERT](https://github.com/naver/biobert-pretrained) - [paper](https://arxiv.org/abs/1901.08746) - [code](https://github.com/dmis-lab/biobert) - A PubMed and PubMed Central-trained version of the [BERT language model](https://arxiv.org/abs/1810.04805).
- [Alsentzer et al Clinical BERT](https://github.com/EmilyAlsentzer/clinicalBERT) - [paper](https://www.aclweb.org/anthology/W19-1909/)
- [Huang et al ClinicalBERT](https://github.com/kexinhuang12345/clinicalBERT) - [paper](https://arxiv.org/abs/1904.05342)
- [SciBERT](https://github.com/allenai/scibert) - [paper](https://arxiv.org/abs/1903.10676) - A BERT model trained on >1M papers from the Semantic Scholar database.
- [BlueBERT](https://github.com/ncbi-nlp/bluebert) - [paper](https://arxiv.org/abs/1906.05474) - A BERT model pre-trained on PubMed text and MIMIC-III notes.
- [BioGPT](https://github.com/microsoft/BioGPT) - [paper](https://doi.org/10.1093/bib/bbac409) - A GPT-2 model pre-trained on 15 million PubMed abstracts, along with fine-tuned versions for several biomedical tasks.

## Data Models

- [OMOP Common Data Model](https://github.com/OHDSI/CommonDataModel) - a standard for observational healthcare data. [Back to Top](#contents) [Credits](./CREDITS.md) for curators and sources. [![CC0](https://mirrors.creativecommons.org/presskit/buttons/88x31/svg/cc-zero.svg)](https://creativecommons.org/publicdomain/zero/1.0) [License](./LICENSE)
