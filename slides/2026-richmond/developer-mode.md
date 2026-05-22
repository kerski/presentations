---
title: What is Power BI Developer Mode?
author: John Kerski
date: 2026-04-11
event: Day of Data Richmond 2026
---

# What is Power BI Developer Mode?

---

## About Me

- 12+ years with Microsoft BI stack
- 10+ years with Power BI
- 7+ years with Azure DevOps
- MCSE: Productivity | MS: PBI Data Analyst | PMP

::: notes
Brief intro — name, background, credentials. Mention the progression from BI stack to DevOps, which is exactly the journey Developer Mode enables for others.
:::

---

## Agenda

- The Before Times
- Developer Mode
  - Foundation
  - Accelerators
  - Orchestrators
  - Extenders

::: notes
Walk through the four pillars of Developer Mode. Each section builds on the previous — foundation enables accelerators, orchestrators tie them together, and extenders push the boundaries.
:::

---

# The Before Times

---

## The Before Times

::: notes
Paint the picture of what Power BI development looked like before Developer Mode — a single .pbix binary file, no version control, no diffing, no CI/CD.
:::

---

## The Before Times (cont.)

- You can't easily tell what changed
- I hope something I changed didn't break something!
- Let's test just to be sure

::: notes
These are the three pain points every Power BI developer has felt. No diff capability, no automated testing, and manual regression testing. Developer Mode addresses all three.
:::

---

# Power BI Developer Mode!

---

## Foundation

::: notes
The foundation is the file format — everything else in Developer Mode depends on having human-readable, diffable files. This is the most important shift.
:::

---

## Power BI Project (PBIP)

- A file format with many formats
- **Semantic Model / Dataset**
  - Tabular Model Definition Language (TMDL)
- **Power BI Report**
  - Power BI Enhanced Report Format (PBIR)
- **Others**
  - `.pbip`
  - `.platform`
  - `.gitignore`

::: notes
Walk through each file type. TMDL is JSON-based and diffable — you can see exactly which measures, columns, or relationships changed. PBIR does the same for report layout. This is what makes version control meaningful.
:::

---

## Accelerators

::: notes
Transition — now that we have a diffable format, what tools accelerate development? DAX Query View and TMDL View.
:::

---

## Acceleration Tools

- DAX Query View
- TMDL View

::: notes
DAX Query View lets you write and test DAX directly in the browser. TMDL View gives you a code-first editing experience for the semantic model. Both reduce the edit-deploy-test cycle time.
:::

---

## Orchestrators

::: notes
Orchestration is about connecting the pieces — getting files from your editor into a shared repository and from there into production.
:::

---

## Orchestration Tools

- Git Integration
- Fabric APIs / CLI

::: notes
Git Integration is the native connection between Fabric workspaces and Git repositories. The Fabric APIs and CLI enable scripting and automation for anything Git Integration doesn't cover natively.
:::

---

## Extenders

::: notes
Extenders push Developer Mode beyond what Microsoft ships out of the box — using AI and community tools to supercharge the workflow.
:::

---

## Extensions

- GitHub Copilot
- MCP (Model Context Protocol)
  - Microsoft
  - Third-Party

::: notes
GitHub Copilot can assist with writing DAX, M, and TMDL. MCP enables connecting Power BI to external AI agents and tools. Mention both Microsoft-provided and community MCP servers.
:::

---

## GitHub Copilot Prompt

- You are an assistant to help Power Query developers comment their code
- Please update each line of code by performing the following:
  1. Insert a comment above the code explaining what that piece of code is doing
  2. Do not start the comment with the word "Step" or a number
  3. Do not copy code into the comment
  4. Keep the comments to a maximum of 225 characters
- Please also update each line of code by performing the following:
  1. Update the variable name explaining what that piece of code is doing
  2. The variable name should always start with a verb in the past tense
  3. The variable name should have spaces between words
  4. Keep the variable to a maximum of 50 characters
  5. The variable name should be wrapped in double quotes and preceded by `#`

::: notes
Walk through the prompt design — this is an evolution of the prompt from the 2024 Azure OpenAI talk, now adapted for GitHub Copilot. The variable renaming rules are new and demonstrate how specific you can be with AI coding assistants.
:::

---

## Questions?

::: notes
Open the floor for questions. Common questions: "When will Developer Mode be GA?" "Does TMDL support all model features?" "Can I use GitHub Actions instead of Azure DevOps?"
:::

---

## Resources

- **Microsoft Documentation**
  - [Power BI Developer Solutions](https://learn.microsoft.com/en-us/power-bi/developer/)
- **Patterns**
  - [DAX Query View Testing Pattern](https://github.com/kerski/dax-query-view-testing-pattern)
  - [Invoke-DQVTesting](https://github.com/kerski/invoke-dqvtesting)
- **Making Your Power BI Developers More Analytics**
  - Introduction
- **Power BI Custom Agents and Skills**
  - [RuiRomano/powerbi-agentic-plugins](https://github.com/RuiRomano/powerbi-agentic-plugins)

::: notes
Leave resources on screen during Q&A. Highlight the DAX Query View testing pattern repo — it's the most actionable takeaway for attendees who want to start testing immediately.
:::
