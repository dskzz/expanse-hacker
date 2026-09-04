Locked in.  
Here is the **updated, corrected, final strict‑mode doctrine**, incorporating the new rule about **title‑page suppression on subsequent outputs**, and ensuring the entire workflow is now internally consistent and drift‑proof.

This replaces all previous versions.

---

# **STRICT‑MODE DOCTRINE (FINAL, LOCKED)**

## **0. Activation**

- Strict mode is **assumed** when requested.
- The assistant **never** says “strict mode on,” “entering strict mode,” or anything similar.
- Output immediately switches to strict‑mode formatting.

---

## **1. Title Page Rules**

The title page appears **once**, at the very beginning of the full RFC:

```
# RFC‑XXXX — Title

_Institution Name_  
_Status: Normative / Informational / Foundational / etc._
```

### **When generating sections incrementally:**

- **The assistant does NOT repeat the title page.**
- Only the user owns the title page; the assistant outputs sections only.

This is now canonical.

---

## **2. Section Output Rules**

Each section is emitted **only** as:

```
## N Section Title
_Institution Name (if different from previous section)_

…body…
```

### **No title page.**

### **No document header.**

### **No meta.**

### **No continuation instructions.**

---

## **3. Appendix Output Rules**

Appendices follow the same pattern:

```
## Appendix A — Title
_Institution Name (if different from previous section)_

…body…
```

Appendices use **A, B, C…**  
No Roman numerals.

---

## **4. Authorship Rules**

### **Single‑voice RFCs**

- Only the title page contains the authorship block.
- No authorship lines appear in later sections.

### **Multi‑voice RFCs**

- Each section authored by a different institution includes an italicized line under the section header.
- If the same institution continues, the line is omitted.

### **Institutional voice boundaries**

- RNC: terse, engineering, declarative, minimal SHALL.
- CBR: registry‑focused, precise, catalog‑like.
- NEEB: exposure‑minimizing, analytical, not punitive.
- SPERB: cold, bureaucratic, compliance‑oriented (only in their sections).
- OPRA: Belt high‑register operational tone (inside prose only).
- Others follow their established voice patterns.

---

## **5. Normative Language Rules**

### **RNC (locked to Option A)**

- Minimal SHALL usage.
- Declarative engineering tone.
- Avoids tribunal cadence.
- Avoids SPERB‑style compliance stacking.

### **Other institutions follow their own normative density**, but RNC is now fixed.

---

## **6. Continuation Prompts**

The assistant **never** embeds continuation instructions inside strict‑mode output.

The user continues the document by sending:

- **“next”**
- **“section #”**
- **“#”**
- **“A”**, **“B”**, etc. for appendices

These are the only valid continuation signals.

---

## **7. Section → Appendix Transition**

When the assistant determines all sections are complete:

- It outputs:
    
    ```
    ### DONE SECTIONS ###
    ```
    

Then waits for the user to begin appendices with **A** or **next**.

When appendices are complete:

- It outputs:
    
    ```
    ### DONE APPENDIX ###
    ```
    

After all appendices:

- It outputs the final:
    
    ```
    ### DONE ###
    ```
    

---

## **8. Determining Total Sections and Appendices**

The assistant — not the user — determines:

- how many sections are required
- how many appendices are required
- when to stop

This is based on:

- conceptual completeness
- doctrinal coverage
- institutional responsibilities
- diminishing marginal value

When additional content adds negligible value, the assistant stops.

---

## **9. Forbidden Content**

Strict‑mode output **must not** include:

- meta commentary
- conversational text
- apologies
- explanations
- instructions
- out‑of‑universe notes
- bracketed voice tags
- any mention of strict mode
- repeated title pages

Only pure RFC text.

---

## **10. No Deviation**

Strict mode is absolute.  
No drift.  
No softening.  
No commentary.  
No exceptions unless the user explicitly suspends strict mode.

---

# **Strict‑Mode Doctrine Is Now Fully Locked In**

Ready when you are.  
Say **next** and I will output **Section 3** in perfect strict‑mode formatting.