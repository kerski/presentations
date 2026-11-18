---
title: Leveraging Large Language Models with Power BI
author: Kerski
date: 2026-04-11
event: Day of Data Richmond 2026
---

# Introduction

---

## Who Am I?

- Power BI developer and architect
- Microsoft MVP
- Focused on DataOps and automated testing for Power BI

::: notes
Brief intro: name, background, why this topic matters. Mention that the goal is to show practical patterns — not just theory.
:::

---

## Agenda

- What are Large Language Models (LLMs)?
- LLMs in the Microsoft Ecosystem
- Integrating LLMs with Power BI
- Patterns: DAX Generation, Narrative Summaries, Q&A
- Guardrails and Governance
- Live Demo
- Key Takeaways

::: notes
Walk through each agenda item at a high level so attendees know what to expect. Emphasize the "practical patterns" angle.
:::

---

# What Are Large Language Models?

---

## LLMs in Plain Language

- Statistical models trained on vast amounts of text
- Predict the next most-likely token (word/subword)
- Emergent ability: reasoning, summarization, code generation
- Well-known examples: GPT-4, Llama 3, Mistral, Gemini

::: notes
Keep this accessible — assume mixed audience of analysts, developers, and business users. Avoid deep technical jargon. Use the "autocomplete on steroids" analogy.
:::

---

## Key Concepts

- **Prompt**: The instruction or question you send to the model
- **Completion**: The model's response
- **Context Window**: How much text the model can "see" at once
- **Temperature**: Controls creativity/randomness in responses
- **Tokens**: The unit of input/output the model charges and limits by

::: notes
These terms will come up repeatedly in demos. Briefly define each one so attendees can follow along later.
:::

---

## Capabilities Relevant to Analytics

- Natural language to code (DAX, SQL, M/Power Query)
- Summarizing data findings in plain language
- Classifying or tagging text columns
- Anomaly explanations in plain English
- Q&A over structured data

::: notes
Frame each capability in terms of a real analyst pain point. For example: "How often have you stared at a DAX error and wished you could just ask someone what it means?"
:::

---

# LLMs in the Microsoft Ecosystem

---

## Microsoft Copilot Services

| Service | Use Case |
|---|---|
| Microsoft 365 Copilot | Word, Excel, Teams, Outlook |
| GitHub Copilot | Code completion and review |
| Power Platform Copilot | Low-code automation and Power BI |
| Azure OpenAI Service | Custom LLM integrations via API |

::: notes
Audience may already be familiar with M365 Copilot. Emphasize that Power BI Copilot is a subset — and Azure OpenAI opens up custom scenarios beyond what the built-in copilot offers.
:::

---

## Copilot in Power BI

- Available in Fabric-enabled workspaces (F64+ or P1+)
- Features:
  - Natural language report creation
  - AI-generated narrative visuals
  - DAX query suggestions
  - Report summarization
- Limited to data already in the semantic model

::: notes
Licensing note is important — many attendees may not have access yet. Be honest about the capacity requirement. The "limited to data in the model" point sets up why custom Azure OpenAI integrations are valuable.
:::

---

# Integrating LLMs with Power BI

---

## Integration Architecture Options

1. **Power BI Copilot** – Built-in, no code required
2. **Power Automate + Azure OpenAI** – Trigger flows from reports
3. **Fabric Notebooks (Python)** – Call OpenAI API; write results to Lakehouse
4. **Custom Visuals** – Embed LLM calls inside a React/D3 visual
5. **Dataflow Gen2 + Power Query** – Call HTTP APIs inside M

::: notes
Show the spectrum from "no code" to "full code." Different roles in the room will gravitate toward different options. Briefly tease the demo approach (Fabric Notebooks).
:::

---

## Pattern 1 — DAX Generation

- Prompt the LLM with your schema (table names, column names, relationships)
- Ask it to write a DAX measure in plain English
- Paste the result into Power BI Desktop or validate via XMLA

**Example prompt:**
> "Given a Sales table with columns OrderDate, Revenue, and CustomerID, write a DAX measure for Month-over-Month revenue growth."

::: notes
Show a real before/after: the analyst's plain-English question vs. the generated DAX. Highlight that schema context in the prompt is the key to accuracy.
:::

---

## Pattern 2 — AI-Powered Narrative Summaries

- Serialize key metrics from your report as structured text
- Send to Azure OpenAI with a system prompt like: "You are a data analyst. Summarize these KPIs for an executive audience."
- Display the response in a Text visual or custom visual

::: notes
This is the most immediately useful pattern for business users. The "executive summary" use case resonates well. Mention that you can bake guardrails into the system prompt (tone, length, forbidden topics).
:::

---

## Pattern 3 — Natural Language Q&A on Tabular Data

- Use Azure OpenAI's function-calling feature to translate questions to DAX
- Execute DAX via XMLA endpoint
- Return results to the LLM for a natural language answer
- Display in a chat interface inside the report

::: notes
This is the most complex pattern — save for the demo or a future deep-dive session. Key point: the LLM doesn't query the data directly; it generates the query, which keeps data governance intact.
:::

---

# Guardrails and Governance

---

## Why Guardrails Matter

- LLMs can "hallucinate" — generate plausible but incorrect information
- Sensitive data must not leave your tenant boundary
- Generated DAX or SQL must be validated before execution
- Cost can escalate without usage controls

::: notes
This is the section that separates "interesting demo" from "production-ready solution." Compliance and legal teams will ask these questions, so address them proactively.
:::

---

## Governance Checklist

- ✅ Use Azure OpenAI (data stays in your Azure tenant)
- ✅ Apply Row-Level Security before passing data to LLM
- ✅ Log all prompts and completions for audit
- ✅ Validate generated code in a sandbox before execution
- ✅ Set `max_tokens` and cost alerts in Azure
- ✅ Include data classification in your system prompt

::: notes
Walk through each item. Mention that Microsoft's Responsible AI principles apply here. If your org has a data governance framework, LLM usage should be an addendum to it.
:::

---

# Demo

---

## Demo: Fabric Notebook → Power BI

**Scenario:** An analyst wants an AI-generated executive summary of monthly sales KPIs, refreshed automatically with each dataset refresh.

**Steps:**
1. Fabric Notebook calls Azure OpenAI API with the current KPIs
2. Summary text is written to a Lakehouse Delta table
3. Power BI semantic model reads from the Lakehouse
4. A Text visual in the report displays the AI summary

::: notes
Walk through the notebook code live. Key things to highlight: the system prompt (controls tone and format), the API call (show the request payload), and the write-back to the Lakehouse.
:::

---

## Demo: DAX Generation with Schema Context

**Scenario:** Generate a complex time-intelligence DAX measure from plain English.

**Steps:**
1. Extract table/column names from the semantic model via XMLA
2. Build a prompt: "Given this schema, write a DAX measure for…"
3. Send to Azure OpenAI
4. Display and validate the generated measure

::: notes
Emphasize the schema extraction step — this is what makes the output accurate. Without context, the LLM guesses column names and usually gets them wrong.
:::

---

# Key Takeaways

---

## What We Covered

- LLMs generate text (including code) from probabilistic patterns
- Microsoft provides both built-in (Copilot) and API-based (Azure OpenAI) options
- Three practical integration patterns:
  - DAX Generation
  - Narrative Summaries
  - Natural Language Q&A
- Governance is not optional — plan for it from day one

::: notes
Reinforce the main message: "Start with the narrative summary pattern — it's the lowest risk and highest visible impact for stakeholders."
:::

---

## Next Steps

- Enable Fabric Copilot in your workspace (if licensed)
- Experiment with Azure OpenAI in a dev environment
- Review Microsoft's Responsible AI framework
- Follow the patterns in this repo: [github.com/kerski/presentations](https://github.com/kerski/presentations)

::: notes
Give attendees clear, actionable steps. Mention that the slide source and demo notebooks are available in the repository.
:::

---

## Resources

- [Microsoft Copilot for Power BI](https://learn.microsoft.com/en-us/power-bi/create-reports/copilot-introduction)
- [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/ai-services/openai/)
- [Microsoft Fabric Notebooks](https://learn.microsoft.com/en-us/fabric/data-engineering/how-to-use-notebook)
- [Responsible AI at Microsoft](https://www.microsoft.com/en-us/ai/responsible-ai)
- [github.com/kerski/presentations](https://github.com/kerski/presentations)

::: notes
Leave this slide on screen during Q&A. Encourage people to scan the GitHub link to get the demo files.
:::

---

## Q&A

Thank you!

*Kerski | Day of Data Richmond 2026*

::: notes
Open the floor for questions. If time allows, offer to do a quick live demo of any pattern that resonated most with the audience.
:::
