---
title: Commenting Power Query with Azure OpenAI
author: John Kerski
date: 2024-05-18
event: SQL Saturday Richmond 2024
---

# Commenting Power Query with Azure OpenAI

---

## Agenda

- The Challenge
- Commenting Power Query
- Azure OpenAI
  - Demo
- Lessons Learned

::: notes
Walk through the agenda so the audience knows what to expect. Emphasize the practical demo component.
:::

---

## About Me

- 11+ years with Microsoft BI stack
- 8+ years with PowerPivot/Power BI
- 5+ years with Azure DevOps
- MCSE: Productivity | MS: PBI Data Analyst | PMP

::: notes
Brief intro — name, background, credentials. Keep it short and move to the problem statement.
:::

---

# The Challenge

---

## The Challenge

- What was the table this was merged with?
- What column was removed?
- What column was added?

::: notes
Show real examples of uncommented Power Query where it is difficult to tell what transformations were applied. The audience should feel the pain of reading opaque M code.
:::

---

## Comment Your Code

::: notes
Transition slide — everyone knows they *should* comment their code, but doing it in Power Query is tedious. Set up the question: can AI help?
:::

---

## Commenting Code to Technical Folks Is Like…

::: notes
Light humor slide — acknowledge that "comment your code" advice is as old as programming itself. The goal is not to lecture but to automate.
:::

---

# Can Artificial Intelligence Help?

---

## Prerequisites

- Premium, Premium Per User, or Fabric Workspace
  - Requires XMLA connection
- Azure OpenAI
  - A ChatGPT 4.0 model deployed
  - Instructions can be followed at [this link](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/create-resource)

::: notes
Walk through the prerequisites carefully — many attendees may not have Azure OpenAI set up. Emphasize the XMLA requirement for workspace connectivity.
:::

---

## Demo

- [github.com/kerski/pbi-pq-commenter-with-azure-openai](https://github.com/kerski/pbi-pq-commenter-with-azure-openai)

::: notes
Live demo — show the repository, walk through the code, and demonstrate how Power Query code is sent to Azure OpenAI for commenting. Highlight the before/after of the M code.
:::

---

# Lessons Learned

---

## Prompt Engineering

- You are an assistant to help Power Query developers comment their code
- Please take the code between the ``` marks and perform the following:
  1. Return a comment explaining what that piece of code is doing
  2. Do not start the comment with the word "Step" or a number
  3. Do not copy code into the comment
  4. Keep the comments to a maximum of 225 characters
- **Key principles:**
  - Use markers to indicate code boundaries
  - Set clear boundaries for output format

::: notes
Walk through the prompt design decisions. Emphasize that good prompts are specific and constrained — the numbered rules prevent common failure modes like parroting code back.
:::

---

## Token Limits

- 1 token ≈ 4 characters in English
  - Limits vary by model — see [Microsoft documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models)
- 8,000 token limit example:
  - Prompt + M Code ≈ 3,000 tokens
  - Response (M Code + verbose comments) ≈ 6,000 tokens
- Strategies: see [Greg Kamradt's techniques](https://github.com/gkamradt/langchain-tutorials)

::: notes
Token limits are a real constraint when commenting large Power Query scripts. Explain how to estimate token usage and strategies for chunking long scripts.
:::

---

## Security Considerations

- [Data, privacy, and security for Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/data-privacy)
- Protect the API key
  - Vote for Microsoft to make this easier
- Future direction: Power Query commenting with Copilot / Large Language Models

::: notes
Security is critical — data sent to Azure OpenAI stays within your tenant, but API key management is still a concern. Mention the feature request to integrate this natively.
:::

---

## Thank You

- @JKerski
- John Kerski — [Blog](https://johnkerski.com)
- Slides: [github.com/kerski/presentations](https://github.com/kerski/presentations)

::: notes
Leave contact info on screen. Encourage attendees to check out the GitHub repo for the demo code and slides.
:::
