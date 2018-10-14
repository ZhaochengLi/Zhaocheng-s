# Assignment 1: HIV Dataset Analysis
### Zhaocheng Li | Intructor: Xuekui Zhang | Fall-2018 | UVic

#### Background:
- HIV as a wirldwide disease has affected about 2 million people per year, and we usually use anti-troviral drugs to treat HIV-1 affection.
- The performance of the treatment is influenced by the ***drug resistance*** which is usually **caused by mutation** in molecular targets.
#### Our purpose:
> The first assignments will be using dataset to compare performance of prediction precision of linear regression models discussed in class.
> *Unravel the relationship between mutations and HIV-1 drug resistance is very helpful to design new drugs and optimize existing drugs*
#### Approach:
In order to achieve this, we aim to:
- Identify the HIV-1 drug resistance mutations, and
- Use it to **predict changes in drug susceptibility in future patients.**
#### Specific Terminologies:
1. *Wild type* or *Mutant Traits*: 
- Most population are *polymorphic for most phenotypic traits*, from fur color to blood type. The allele that encodes the phenotype most common in a particular natural population is known as the **wild type** allele. It is often designated as "+" in genetic shorthand. Any form of the allele other than the wild type is known as a **mutant** form of that allele.
- For example, for most penguins, they wear "tuxedox" as the one of their wild type. But Albino mutants look nekkid...
2. IC-50 Values: (referenced from wikipedia)
- *The half maximal inhibitory concentration (IC50)* is **a measure of the potency of a substance in inhibiting a specific biological or biochemical function**.
- This quantitative measure **indicates how much of a particular drug or other substance (inhibitor) is needed to inhibit a given biological process (or component of a process, i.e. an enzyme, cell, cell receptor or microorganism) by half.** The values are typically expressed as molar concentration.
- IC50 represents the concentration of a drug that is required for 50% inhibition in vitro.
