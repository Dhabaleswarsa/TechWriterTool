---
author:
  - Author Name
keyword:
  - Keyword1
workflow: review
---

# Sample Markdown File with Extensions used by DITA Open Toolkit {#topicID .outputclassValue audience=novice}

Examples are copied from: [DITA OT Docs](https://www.dita-ot.org/dev/reference/markdown/markdown-dita-syntax)

First paragraph.

Complicated Multi Markdown Table with spans:

| First Header | Second Header | Third Header |
| ------------ | :-----------: | -----------: |
| Content      |          _Long Cell_        ||
| Content      |   **Cell**    |         Cell |

HTML table with spans and block elements in cells:

<table>
    <thead>
    <tr>
        <th>First Header</th>
        <th align="center">Second Header</th>
        <th align="right">Third Header</th>
    </tr>
    </thead>
    <tbody>
        <tr>
        <td>Content</td>
            <td align="center" colspan="2">
                <p>Some other paragraph</p>
                <ul>
                  <li>List item here</li>
                  <li>List item there</li></ul>
            </td></tr>
        <tr>
            <td>Content</td><td align="center"><strong>Cell</strong></td>
            <td align="right">Cell</td></tr>
    </tbody>
</table>

!!! note

    Note content.
    
!!! info

    Information note content.
    
![Alternate text](image/carwash.jpg 'Figure Title')

Code block:

```json
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
}
```

## Sample Section {.section}

Paragraph in sample section.

## Sample Example {.example}

A paragraph in the example.

# Sample DITA Task {.task}

1. Step 1
1. Step 2

# Sample DITA Concept {.concept}

Some content.