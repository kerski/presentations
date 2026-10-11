---
title: "Avoiding the Grey Box of Death: Automatically Checking For Broken Visuals in Power BI"
author: John Kerski
date: 2025-04-04
event: SQL Saturday Richmond 2025
---

# Avoiding the "Grey Box of Death"

---

## About Me

- 11+ years with Microsoft BI stack
- 8+ years with PowerPivot/Power BI
- 5+ years with Azure DevOps
- MCSE: Productivity | MS: PBI Data Analyst | PMP

::: notes
Brief intro — name, background, credentials. Keep it short so we can get to the problem.
:::

---

## Agenda

- Act I: The Challenge with Broken Visuals
- Act II: Microsoft Playwright
- Act III: Visual Error Testing
  - Locally
  - Automatically

::: notes
Frame the talk as a three-act play to match the PLAYBILL theme. Each act builds on the previous one.
:::

---

# Act I: The Challenge

---

## The Challenge

::: notes
Show examples of the "grey box of death" — the dreaded broken visual in Power BI. This is the problem we are solving today.
:::

---

## The Challenge (cont.)

- What do we do?
  - Manually check each workspace…
    - Each page…
    - Each bookmark…
    - Each report…
  - If RLS/OLS, manually check each workspace…
    - Each role
    - Each report
    - Each bookmark
    - Each page

::: notes
Emphasize how tedious and error-prone manual checking is. The number of combinations grows quickly — pages × bookmarks × roles. This is unsustainable at scale.
:::

---

## Other Ways Broken Visuals Occur

1. Power BI visuals have been disabled by your administrator
2. This visual has exceeded the available resources
3. Couldn't retrieve the data for this visual
4. Data shapes must contain at least one group or calculation that outputs data

::: notes
These are the most common error messages you'll see. Each has a different root cause but they all result in the same grey box for end users.
:::

---

# Act II: Microsoft Playwright

---

## Microsoft Playwright

::: notes
Introduce Playwright — an open-source browser automation framework from Microsoft. Explain that it can programmatically render Power BI reports and inspect the DOM for error states.
:::

---

# Act III: Visual Error Testing

---

## Visual Error Testing — Local Mode

::: notes
Transition to the hands-on section. Start with running tests locally before moving to CI/CD automation.
:::

---

## Prerequisites (Local Mode)

1. Node.js
2. Visual Studio Code
3. Premium-backed workspace
   - Will work with PPU (Premium Per User)
4. XMLA / Service Principals

::: notes
Walk through each prerequisite. Most attendees will have Node and VS Code already. The premium workspace and service principal setup may be new — point to documentation.
:::

---

## Local Mode Architecture

- **Playwright** runs test cases
- **CSV** files define test cases (embed URLs, parameters)
- **Power BI Service** renders the reports
- Playwright opens each embed URL, checks for visual errors, and generates a report

::: notes
Diagram walkthrough: CSV → Playwright → Embed → Power BI Service → Test & Report. Emphasize the CSV-driven approach makes it easy to add new test cases without code changes.
:::

---

## Visual Error Testing — CI Mode

::: notes
Now we move from local to automated — running the same tests in a CI/CD pipeline so broken visuals are caught automatically on every deployment.
:::

---

## Prerequisites (CI Mode)

1. Azure DevOps
2. XMLA / Service Principals
3. Premium-backed workspace
   - Will work with PPU

::: notes
CI mode adds Azure DevOps as a prerequisite. The service principal from local mode is reused. Mention that GitHub Actions could also be used.
:::

---

## CI Mode Architecture

- **Azure DevOps** pipeline triggers on deployment
- **Playwright** renders reports via embed URLs
- **Power BI Service** serves the reports
- Test results are published back to the pipeline

::: notes
Diagram walkthrough: Azure DevOps → Playwright → Embed → Power BI Service → Test & Report → Test Results. Highlight that failures block the pipeline, preventing broken visuals from reaching production.
:::

---

## Test Case — No Parameters

::: notes
Show a simple test case CSV row — just a workspace, report, and page. No RLS parameters. Walk through what Playwright does with this input.
:::

---

## Test Case — With Parameters

::: notes
Show a more complex test case with RLS role parameters. Playwright will test the same report under different security contexts to verify visuals render correctly for each role.
:::

---

## Questions?

::: notes
Open the floor for questions. Common questions: "Does this work with paginated reports?" "What about embedded analytics?" "How long do the tests take?"
:::
