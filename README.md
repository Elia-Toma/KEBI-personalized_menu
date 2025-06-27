# KEBI Personalized Menu

This repository contains the full implementation of a personalized meal recommendation system developed as part of the final project for the university course **Knowledge Engineering and Business Intelligence (KEBI)**.

The project explores multiple paradigms—decision tables, logic programming, ontology engineering, and semantic meta-modelling—to design a smart system capable of suggesting meals based on user-defined dietary constraints and preferences.

## Overview

The goal of the project was to develop a system capable of recommending suitable meals for restaurant customers based on their dietary restrictions (e.g., vegetarian, lactose intolerant, gluten intolerant) and preferences (e.g., calorie-conscious). The project was approached incrementally across four tasks:

1. Simple rule-based logic using **DMN** decision tables
2. Declarative and recursive reasoning using **Prolog**
3. Rich semantic modeling and querying using **OWL ontologies**, **SWRL**, **SPARQL**, and **SHACL**
4. Context-aware process modeling with **AOAME** and **BPMN 2.0** meta-modelling

## Technologies

* **DMN (Decision Model and Notation)** via Camunda Modeler
* **Prolog** (SWI-Prolog)
* **Ontology** using Protégé
* **GraphDB** for ontology storage and querying
* **SWRL** (Semantic Web Rule Language)
* **SPARQL** for querying the knowledge base
* **SHACL** for ontology validation
* **AOAME** framework for ontology-based BPMN 2.0 meta-modelling
* **Jena Fuseki** for triple store and semantic query execution

## Architecture

The system evolves through increasing expressiveness:

* From decision tables for rule encoding
* To logic programming for recursive inference
* To ontology-based reasoning for semantic richness and validation
* Finally to business process adaptation via semantic queries in AOAME

## Components

### 1. DMN Decision Tables

Trisotech Decision Modeler was used to design DMN decision tables that filter meals according to user preferences. While limited in complexity, this approach allowed quick iteration and testing.

### 2. Prolog-Based Reasoning

The Prolog module includes:

* Meal definitions with ingredients
* Calorie data
* Rules for checking compatibility with user profiles
* Recursive logic for calorie computation
* A recommendation engine matching meals to profile constraints

### 3. Ontology and Knowledge Graph

Developed in Protégé, the ontology models domain concepts like:

* `Meal`, `Ingredient`, `Guest`, and `GuestProfile`
* Object/Data properties like `hasIngredient`, `ingredientHasCalories`, etc.
* SWRL rules to infer meal compatibility
* SPARQL queries for meal suggestion and filtering
* SHACL shapes for ontology validation

The OWL ontology was exported in TTL format and imported into **GraphDB** and **Jena Fuseki**.

### 4. BPMN 2.0 Semantic Extension with AOAME

The final task used the AOAME platform to semantically extend BPMN tasks. A custom SPARQL query, launched via AOAME, selects suitable meals for a given guest. The ontology created in Protégé was loaded in Fuseki and queried to provide runtime suggestions.

## SPARQL Querying

Queries were defined to:

* Retrieve all ingredients and their calorie values
* Filter meals by dietary profiles (vegetarian, lactose/gluten intolerant)
* Select calorie-conscious meals
* Combine multiple constraints into a single query using `FILTER NOT EXISTS`

## Authors

This project was developed by Elia Toma and Sofia Scattolini as part of the KEBI exam project at the University of Camerino.
