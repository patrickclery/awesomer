# machine-learning-with-ruby

Curated list: Resources for machine learning in Ruby

## Heroku buildpacks

- [GSL and Ruby buildpack](https://github.com/tomwolfe/heroku-buildpack-gsl-ruby)
- [OpenCV and Ruby buildpack](https://github.com/lilibethdlc/heroku-buildpack-ruby-opencv)
- [ImageMagick buildpack](https://github.com/mcollina/heroku-buildpack-imagemagick)

## Projects and Code Examples

- [Wine Clustering](https://github.com/hexgnu/wine_clustering) - Wine quality estimations clustered with different algorithms.
- [simple_ga](https://github.com/giuse/simple_ga) - Basic (working) demo of Genetic Algorithms in Ruby.
- [Handwritten Digits Recognition](https://github.com/jdrzj/handwritten-digits-recognition) - Handwritten digits recognition using Neural Networks and Ruby.

## Related Resources

- [Awesome Ruby](https://github.com/markets/awesome-ruby) - Among other awesome items a short list of NLP related projects.
- [Ruby NLP](https://github.com/diasks2/ruby-nlp) - State-of-Art collection of Ruby libraries for NLP.
- [Speech and Natural Language Processing](https://github.com/edobashira/speech-language-processing) - General List of NLP related resources (mostly not for Ruby programmers).
- [iRuby](https://github.com/SciRuby/iruby) - IRuby kernel for Jupyter (formerly IPython).
- [Kiba](https://github.com/thbar/kiba) - Lightweight [ETL](https://en.wikipedia.org/wiki/Extract,_transform,_load) (Extract, Transform, Load) pipeline.
- [Awesome OCR](https://github.com/kba/awesome-ocr) - Multitude of OCR (Optical Character Recognition) resources.
- [Awesome TensorFlow](https://github.com/jtoy/awesome-tensorflow) - Machine Learning with TensorFlow libraries.
- [rb-gsl](https://github.com/SciRuby/rb-gsl) - Ruby interface to the [GNU Scientific Library](https://www.gnu.org/software/gsl/).

## Machine Learning Libraries

- [LangChain.rb](https://github.com/andreibondarev/langchainrb) - Build ML/AI-supercharged applications with Ruby's LangChain.
- [weka](https://github.com/paulgoetze/weka-jruby) - JRuby bindings for Weka, different ML algorithms implemented through Weka.
- [ai4r](https://github.com/SergioFierens/ai4r) - Artificial Intelligence for Ruby.
- [classifier-reborn](https://github.com/jekyll/classifier-reborn) - General classifier module to allow Bayesian and other types of classifications. <sup>[[dep: GLS](#gls)]</sup>
- [scoruby](https://github.com/asafschers/scoruby) - Ruby scoring API for [PMML](http://dmg.org/pmml/v4-3/GeneralStructure.html) (Predictive Model Markup Language).
- [rblearn](https://github.com/himkt/rblearn) - Feature Extraction and Crossvalidation library.
- [data_modeler](https://github.com/giuse/data_modeler) - Model your data with machine learning. Ample test coverage, examples to start fast, complete documentation. Production ready since 1.0.0.
- [shogun](https://github.com/shogun-toolbox/shogun) - Polyfunctional and mature machine learning toolbox with [Ruby bindings](https://github.com/shogun-toolbox/shogun/tree/develop/src/interfaces/ruby).
- [aws-sdk-machinelearning](https://github.com/aws/aws-sdk-ruby) - Machine Learning API of the Amazon Web Services.
- [azure_mgmt_machine_learning](https://github.com/Azure/azure-sdk-for-ruby) - Machine Learning API of the Microsoft Azure.
- [machine_learning_workbench](https://github.com/giuse/machine_learning_workbench) - Growing machine learning framework written in pure Ruby, high performance computing using [Numo](https://github.com/ruby-numo/), CUDA bindings through [Cumo](https://github.com/sonots/cumo). Currently implementating neural networks, evolutionary strategies, vector quantization, and plenty of examples and utilities.
- [Deep NeuroEvolution](https://github.com/giuse/DNE) - Experimental setup based on the [machine_learning_workbench](https://github.com/giuse/machine_learning_workbench) towards searching for deep neural networks (rather than training) using evolutionary algorithms. Applications to the [OpenAI Gym](https://github.com/openai/gym) using [PyCall](https://github.com/mrkn/pycall.rb).
- [rumale](https://github.com/yoshoku/rumale) - Machine Learninig toolkit in Ruby with wide range of implemented algorithms (SVM, Logistic Regression, Linear Regression, Random Forest etc.) and interfaces similar to [Scikit-Learn][scikit] in Python.
- [eps](https://github.com/ankane/eps) - Bayesian Classification and Linear Regression with exports using [PMML](http://dmg.org/pmml/v4-3/GeneralStructure.html) and an alternative backend using [GSL][gsl].
- [ruby-openai](https://github.com/alexrudall/ruby-openai) - OpenAI API wrapper
- [Instruct](https://github.com/instruct-rb/instruct) - Inspired by Guidance; weave code, prompts and completions together to instruct LLMs to do what you want.
- [neural-net-ruby](https://github.com/gbuesing/neural-net-ruby) - Neural network written in Ruby.
- [ruby-fann](https://github.com/tangledpath/ruby-fann) - Ruby bindings to the [Fast Artificial Neural Network Library (FANN)](http://leenissen.dk/fann/wp/).
- [cerebrum](https://github.com/irfansharif/cerebrum) - Experimental implementation for Artificial Neural Networks in Ruby.
- [tlearn-rb](https://github.com/josephwilk/tlearn-rb) - Recurrent Neural Network library for Ruby.
- [brains](https://github.com/jedld/brains-jruby) - Feed-forward neural networks for JRuby based on [brains](https://github.com/jedld/brains).
- [rann](https://github.com/mikecmpbll/rann) - Flexible Ruby ANN implementation with backprop (through-time, for recurrent nets), gradient checking, adagrad, and parallel batch execution.
- [tensor_stream](https://github.com/jedld/tensor_stream) - Ground-up and standalone reimplementation of TensorFlow for Ruby.
- [red-chainer](https://github.com/red-data-tools/red-chainer) - Deep learning framework for Ruby.
- [tensorflow](https://github.com/somaticio/tensorflow.rb) - Ruby bindings for [TensorFlow](https://www.tensorflow.org/).
- [ruby-dnn](https://github.com/unagiootoro/ruby-dnn) - Simple deep learning for Ruby.
- [torch-rb](https://github.com/ankane/torch-rb) - Ruby bindings for [LibTorch](https://github.com/pytorch/pytorch) using [rice](https://github.com/jasonroelofs/rice).
- [mxnet](https://github.com/mrkn/mxnet.rb) - Ruby bindings for [mxnet](https://mxnet.apache.org/).
- [rb-libsvm](https://github.com/febeling/rb-libsvm) - Support Vector Machines with Ruby and the [LIBSVM](https://www.csie.ntu.edu.tw/~cjlin/libsvm/) library. <sup>[[dep: bundled](#bundled)]</sup>
- [simple_ga](https://github.com/giuse/simple_ga) - Simplest Genetic Algorithms implementation in Ruby.
- [linnaeus](https://github.com/djcp/linnaeus) - Redis-backed Bayesian classifier.
- [naive_bayes](https://github.com/reddavis/Naive-Bayes) - Simple Naive Bayes classifier.
- [nbayes](https://github.com/oasic/nbayes) - Full-featured, Ruby implementation of Naive Bayes.
- [decisiontree](https://github.com/igrigorik/decisiontree) - Decision Tree ID3 Algorithm in pure Ruby. <sup>[[dep: GraphViz](#graphviz) | [post](https://www.igvita.com/2007/04/16/decision-tree-learning-in-ruby/)]</sup>.
- [kmeans-clusterer](https://github.com/gbuesing/kmeans-clusterer) - k-means clustering in Ruby.
- [k_means](https://github.com/reddavis/K-Means) - Attempting to build a fast, memory efficient K-Means program.
- [knn](https://github.com/reddavis/knn) - Simple K Nearest Neighbour Algorithm.
- [liblinear-ruby-swig](https://github.com/tomz/liblinear-ruby-swig) - Ruby interface to LIBLINEAR (much more efficient than LIBSVM for text classification).
- [liblinear-ruby](https://github.com/kei500/liblinear-ruby) - Ruby interface to LIBLINEAR using SWIG.
- [rtimbl](https://github.com/maspwr/rtimbl) - Memory based learners from the Timbl framework.
- [lda-ruby](https://github.com/ealdent/lda-ruby) - Ruby implementation of the [LDA](https://en.wikipedia.org/wiki/Latent_Dirichlet_allocation) (Latent Dirichlet Allocation) for automatic Topic Modelling and Document Clustering.
- [maxent_string_classifier](https://github.com/mccraigmccraig/maxent_string_classifier) - JRuby maximum entropy classifier for string data, based on the OpenNLP Maxent framework.
- [omnicat](https://github.com/mustafaturan/omnicat) - Generalized rack framework for text classifications.
- [omnicat-bayes](https://github.com/mustafaturan/omnicat-bayes) - Naive Bayes text classification implementation as an OmniCat classifier strategy. <sup>[[dep: bundled](#bundled)]</sup>
- [xgboost](https://github.com/PairOnAir/xgboost-ruby) - Ruby bindings for XGBoost. <sup>[[dep: XGBoost](#xgboost)]</sup>
- [xgb](https://github.com/ankane/xgb) - Ruby bindings for XGBoost. <sup>[[dep: XGBoost](#xgboost)]</sup>
- [lightgbm](https://github.com/ankane/lightgbm) - Ruby bindings for LightGBM. <sup>[[dep: LightGBM](#lightgbm)]</sup>
- [flann](https://github.com/mariusmuja/flann) - Ruby bindings for the [FLANN](https://github.com/flann-lib/flann) (Fast Library for Approximate Nearest Neighbors). <sup>[[flann](#flann)]</sup>
- [annoy-rb](https://github.com/yoshoku/annoy.rb) - Ruby bindings for the [Annoy](https://github.com/spotify/annoy) (Approximate Nearest Neighbors Oh Yeah).
- [hnswlib.rb](https://github.com/yoshoku/hnswlib.rb) - Ruby bindings for the [Hnswlib](https://github.com/nmslib/hnswlib) that implements approximate nearest neighbor search with Hierarchical Navigable Small World graphs.
- [ngt-ruby](https://github.com/ankane/ngt-ruby) - Ruby bindings for the [NGT](https://github.com/yahoojapan/NGT) (Neighborhood Graph and Tree for Indexing High-dimensional data).
- [milvus](https://github.com/andreibondarev/milvus) - Ruby client for Milvus Vector DB.
- [pinecone](https://github.com/ScotterC/pinecone) - Ruby client for Pinecone Vector DB.
- [qdrant-ruby](https://github.com/andreibondarev/qdrant-ruby) - Ruby wrapper for the Qdrant vector search database API.
- [weaviate-ruby](https://github.com/andreibondarev/weaviate-ruby) - Ruby wrapper for the Weaviate vector search database API.

## Applications of machine learning

- [phashion](https://github.com/westonplatter/phashion) - Ruby wrapper around pHash, the perceptual hash library for detecting duplicate multimedia files. <sup>[[ImageMagick](#imagemagick) | [libjpeg](#libjpeg)]</sup>
