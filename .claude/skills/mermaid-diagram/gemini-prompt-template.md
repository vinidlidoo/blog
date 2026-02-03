# Gemini Diagram Prompt Template

Use this template when generating polished diagrams with `gemini-image.py`. Adapt as needed for the specific diagram.

---

## Prompt Structure

```
Transform this diagram into a hand-drawn Excalidraw style.

STRUCTURE (from Mermaid source):
[Paste the Mermaid code or describe the structure]

STYLE:
- Hand-drawn aesthetic with slightly wobbly lines, like Excalidraw sketches
- Soft pastel colors: [specify color scheme]
- White background
- Casual handwritten-style font for labels
- No gradients, flat sketch look
- No annotations or explanatory text — keep it clean, explanations go in the blog post

PEDAGOGICAL EMPHASIS (optional):
- [Highlight a specific element or path to draw attention to a key concept]
- [Use color contrast to show relationships or flow]

TECHNICAL REQUIREMENTS:
- All text must be crisp and readable
- Maintain the exact node relationships from the Mermaid source
- [Any specific layout preferences: left-to-right, top-down, etc.]
```

---

## Color Palettes

### Default (technical diagrams)

- Root/primary: light blue (#a8d4f0)
- Intermediate nodes: light green (#b8e6b8)
- Leaf/data nodes: cream/beige (#f5f5dc)
- Highlight/emphasis: orange (#f5a623)
- Connections: dark gray (#333)

### Warm (processes, flows)

- Primary: coral (#f5a8a8)
- Secondary: peach (#f5d4a8)
- Tertiary: cream (#f5f0dc)
- Highlight: red (#e05050)

### Cool (systems, architecture)

- Primary: sky blue (#a8d4f5)
- Secondary: mint (#a8f5d4)
- Tertiary: lavender (#d4a8f5)
- Highlight: deep blue (#5080e0)

---

## Example: Merkle Tree

```
Transform this Merkle tree diagram into a hand-drawn Excalidraw style.

STRUCTURE (from Mermaid):
flowchart TD
    Root[Merkle Root] --> HAB[H_AB]
    Root --> HCD[H_CD]
    HAB --> HA[H_A] --> A[Tx A]
    HAB --> HB[H_B] --> B[Tx B]
    HCD --> HC[H_C] --> C[Tx C]
    HCD --> HD[H_D] --> D[Tx D]

STYLE:
- Hand-drawn aesthetic with slightly wobbly lines
- Colors: light blue root, light green hash nodes, cream transactions
- White background, no gradients
- No annotations — keep it clean

PEDAGOGICAL EMPHASIS:
- Color Tx B and its path to root in orange to show change propagation
- Use upward arrows to show hash flow direction

TECHNICAL:
- All labels readable
- Maintain binary tree structure
```

---

## Tips

1. **Always feed the Mermaid-rendered image** as reference (`-i`) — it ensures correct structure
2. **Keep annotations minimal** — explanations belong in the blog post, not the diagram
3. **Specify exact colors** if brand consistency matters
4. **Request 2K resolution** (`-s 2K`) with pro model for readable text
5. **Iterate** — first generate, then refine with follow-up prompts referencing the output
