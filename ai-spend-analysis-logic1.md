# AI Spend Analyzer — Full Logic Spec (Master Reference)

## Purpose

Create a mobile-first web experience that:

1. Takes a few persona inputs (age/income/marital/gender/spend style + optional favorite brands)
2. Generates a realistic "typical spend mix" (editable)
3. Calculates how much the user could **save** by moving their **spending money** into Multipl's **Higher-Yield Spending Account** vs leaving it in a 2.5% bank account — combining:
   - **brand offers/discounts**, and
   - **extra yield uplift** from liquid mutual funds vs bank savings

Everything runs client-side; persist in localStorage.

---

# PART A — Inputs

### Required persona inputs

- Age bucket: `18–23`, `24–30`, `31–35`, `35+`
- Gender: `M/F`
- Marital status: `Single/Married`
- Income bracket (p.a.): `<6L`, `6–10L`, `10–18L`, `18–30L`, `>30L`
- Spend style (single choice):
  1. `UPI_SMALL_CC_BIG` — UPI for small ticket, CC for big ticket
  2. `ALL_CC`
  3. `ALL_UPI`

### Optional inputs

- Favorite brands (multi-select; optional)
- City (optional; if available on website; else omit)

---

# PART B — Spend-Mix Output (what AI generates)

### What the AI produces

A list of **6–10** spend lines by default, grouped by category:

- Q-Com / Food Delivery
- Shopping
- Travel
- Non-Brand Spends (Rent only by default under certain rules; CC bill not auto-added)

Each line has:

- Brand/Spend
- Amount
- Frequency (monthly / quarterly / yearly)

Users can:

- Edit amount
- Edit frequency
- Delete row
- Add a spend (Add Spend modal/bottom sheet)

All edits instantly recalculate totals.

---

# PART C — Critical Realism Rules (the "AI" part)

## C1) No double-counting CC Bill Payment

**Do NOT auto-generate "Credit Card Bill Payment".**
Reason: It double-counts the same shopping/travel spends (payment instrument, not category).

- Keep **Credit Card Bill Payment** only as a *manual add option* in the Add Spend list (for users who insist).
- Use spend style to tag rows as `paidBy: UPI` or `CC` (optional), but don't add a CC row.

## C2) Income midpoint (monthly)

Use midpoint monthly income estimates:

| Bracket | Monthly income |
|---------|---------------|
| `<6L`   | ₹35,000       |
| `6–10L` | ₹65,000       |
| `10–18L`| ₹1,10,000     |
| `18–30L`| ₹2,00,000     |
| `>30L`  | ₹3,00,000     |

## C3) Spend ratio (bounded, by income)

| Bracket  | Base ratio |
|----------|-----------|
| `<6L`    | 0.70      |
| `6–10L`  | 0.62      |
| `10–18L` | 0.55      |
| `18–30L` | 0.48      |
| `>30L`   | 0.42      |

Adjust:
- Married: +0.03
- Age 18–23: −0.03
- Age 35+: +0.02

Clamp to **[0.38, 0.72]**

```
spendingBudgetMonthly = incomeMonthly × spendRatio
```

## C4) Rent rule

Auto-include **Rent Payment** only if:
- `incomeBracket` is **not** `>30L`, **AND**
- `maritalStatus` is **not** `Married`

If rent is excluded, reallocate that money across Shopping/Travel/Other so the overall budget stays plausible.

If rent included:
- Single: rent = **15%–28%** of `spendingBudgetMonthly` (seeded within that range)

## C5) Category allocation (bounded + human)

Split the **remaining monthly budget (after rent)** into:

| Category               | Range      |
|------------------------|-----------|
| Food delivery          | 8%–12%    |
| Groceries / Q-com      | 10%–16%   |
| Shopping               | 10%–18%   |
| Commute (Uber)         | 4%–8%     |
| Travel (Flights/Hotels)| 3%–8%     |

Adjustments:
- Age 18–23 → slightly higher food, lower travel
- Age 35+ → slightly higher groceries, slightly lower food
- Married → slightly higher groceries, slightly lower shopping

Add tiny seeded variation but keep within bounds. Normalize non-rent shares to sum to 1.

## C6) Brand selection (avoid too many brands)

Unless the user has selected favorites:

- **Food delivery**: include **ONE** of Swiggy/Zomato (not both)
- **Groceries**: include **ONE** of Zepto/Amazon Fresh
- **Shopping**:
  - Always include Amazon as baseline (unless favorites override)
  - Include 1 additional brand (Myntra/Ajio/Nykaa/Decathlon/Flipkart/Tata Cliq) based on gender + seed
- **Travel**: Uber + optionally one of (MMT Flights or MMT Hotels), not always both
- **Non-brand**: Rent only when rule C4 says yes

If user selected favorites:
- Include favorites, cap at **max 2 per category**
- If user selected both Swiggy and Zomato, allow both (user-initiated)

## C7) Region hint without IP

Do not do IP lookup by default.

If City is available:
- Bengaluru / Chennai / Hyderabad → prefer Swiggy
- Delhi / Gurgaon / Noida / Jaipur → prefer Zomato
- Else: seeded pick

## C8) Frequency logic (fix "shopping monthly" inflation)

Defaults:
- Food delivery, Groceries, Uber → **Monthly**
- Flights/Hotels → **Yearly** (Quarterly only sometimes for higher income)

Shopping frequency by income (seeded probability):

| Bracket  | Monthly | Quarterly |
|----------|---------|-----------|
| `<10L`   | 20%     | 80%       |
| `10–18L` | 35%     | 65%       |
| `18–30L` | 50%     | 50%       |
| `>30L`   | 50%     | 50%       |

Travel frequency:
- Default yearly
- Quarterly only for `18–30L` / `>30L` sometimes (seeded, ~35%)

## C9) Amount assignment must respect frequency

For each category:
```
categoryMonthly = remainingMonthly × categoryShare
annualCategory  = categoryMonthly × 12
```

For each brand row:
```
annualBrand = annualCategory × shareWeight
amount      = annualBrand / periodsPerYear(freq)
```

Rounding:
- Monthly → nearest ₹100
- Quarterly → nearest ₹500
- Yearly → nearest ₹1,000

Minimums:
- Monthly ≥ ₹500
- Quarterly ≥ ₹2,000
- Yearly ≥ ₹5,000

## C10) Spend style affects payment tagging, not spend totals

| Style            | UPI rows                   | CC rows              |
|------------------|----------------------------|----------------------|
| `UPI_SMALL_CC_BIG` | Food, Grocery, Uber       | Shopping, Travel     |
| `ALL_CC`         | —                          | Everything except rent |
| `ALL_UPI`        | Everything                 | —                    |

Do not create a separate "CC Bill" spend row.

---

# PART D — High Income Upgrades (`>30L` profiles)

Shopping spend should be **distributed across 3–5 brands** (not concentrated on 1–2).

Add luxury brands to Shopping universe:
- Tata Cliq Luxury
- Ajio Luxe
- (Optionally Nykaa Luxe)

Add jewellery brand for females (AI-added):
- Choose one: Tanishq / Kalyan Jewellers / Malabar Gold
- Jewellery share of Shopping annual:
  - `>30L`: 5%–12%
  - `18–30L`: 4%–8%
- Frequency: yearly or quarterly (seeded by bracket)

Brand dominance caps per Shopping annual:

| Bracket  | Max single-brand share |
|----------|----------------------|
| `>30L`   | 35%                  |
| `18–30L` | 45%                  |
| `≤18L`   | 60%                  |

> **UX note:** Users don't need to pick luxury/jewellery brands in favorites. AI adds them to improve realism. They remain available in "Add Spend".

---

# PART E — Calculation Logic (Multipl benefit math)

## E1) Fixed constants

```js
const mfRate       = 0.07;   // Multipl liquid fund yield
const bankRate     = 0.025;  // Typical savings account rate
const rateDiff     = 0.045;  // mfRate - bankRate
const holdingFactor = 0.5;   // avg balance ≈ 6 months of annual spend
```

## E2) Helper

```js
function periodsPerYear(freq) {
  if (freq === "monthly")   return 12;
  if (freq === "quarterly") return 4;
  return 1; // yearly
}
```

## E3) Per-row computations

```js
annualSpend_i  = amount_i * periodsPerYear(freq_i)
brandSavings_i = annualSpend_i * discountRate_i
extraYield_i   = annualSpend_i * holdingFactor * rateDiff
               // = annualSpend_i * 0.5 * 0.045
               // = annualSpend_i * 0.0225
```

## E4) Totals

```js
totalAnnualSpend  = Σ annualSpend_i
totalBrandSavings = Σ brandSavings_i
totalYieldUplift  = Σ extraYield_i
totalSavings      = totalBrandSavings + totalYieldUplift
```

## E5) Recommended Spending Balance on Multipl

```js
recommendedBalance = totalAnnualSpend * holdingFactor
// "~6 months of typical spends held as average balance"
```

---

# PART F — Discount Rate Mapping

Internal rates — not displayed in UI. Replace with actual rates if/when available.

```js
const discountRates = {
  // Food & Q-Com
  "Swiggy":         0.05,
  "Zomato":         0.05,
  "Zepto":          0.05,
  "Amazon Fresh":   0.05,

  // Shopping — marketplace
  "Amazon":         0.02,
  "Flipkart":       0.02,

  // Shopping — fashion/beauty
  "Tata Cliq":      0.06,
  "Nykaa":          0.06,
  "Ajio":           0.06,
  "Myntra":         0.06,
  "Decathlon":      0.06,

  // Shopping — luxury (internal assumption; tune when live rates available)
  "Tata Cliq Luxury": 0.06,
  "Ajio Luxe":        0.06,

  // Jewellery (no discount currently; update when live)
  "Tanishq":           0.00,
  "Kalyan Jewellers":  0.00,
  "Malabar Gold":      0.00,

  // Travel
  "MakeMyTrip Flights": 0.06,
  "MakeMyTrip Hotels":  0.10,
  "Uber":               0.05,

  // Non-brand / payments
  "Rent Payment":              0.00,
  "Credit Card Bill Payment":  0.00,
};
```

---

# PART G — UI & Presentation

### Results screen order

1. Estimated yearly spends (₹X)
2. Spend mix list — editable amounts, frequency, delete, add
3. "What you could save with Multipl" — ₹/year and ₹/month breakdown, recommended balance, micro explainers
4. CTA: **"Activate my Spending Account"** → smart redirect to Play Store / App Store

### Disclaimer (required)

> *Illustrative estimates. Returns are market-linked and not guaranteed. Actual yields and discounts may vary.*

---

# PART H — Implementation Notes

### Seeded randomness
Use a deterministic seed (e.g. `hash(age + income + marital + gender)`) so the same persona always produces the same spend mix. Avoids jarring re-renders on re-open.

### localStorage persistence
Save the full spend rows array + persona inputs on every edit. Restore on page load if present.

### Add Spend modal
Show all brands (including "Credit Card Bill Payment") as manual-add options. Group by category. On add, immediately recalculate totals.

### Frequency display
Show amounts in the frequency they occur: `₹1,200/mo`, `₹4,500/qtr`, `₹18,000/yr`. Never convert to monthly for display (confusing for yearly travel spends).

### Editable rows
Tap on amount → inline number input. Tap on frequency → segmented control (Monthly / Quarterly / Yearly). Changes trigger instant recalc.
