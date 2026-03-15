# Multipl Spend Calculator — Calculation Logic

**Version:** 1.0
**Last updated:** March 2026
**Applies to:** `spend-calculator.html` (full) and `spend-calculator-lite.html` (onboarding)

---

## What the calculator answers

> *"How much more money would I have each year if I kept my spending balance in Multipl instead of a regular savings account?"*

The answer has two components:
1. **Yield uplift** — extra interest earned (7% Multipl vs 2.5% typical savings account)
2. **Brand savings** — cashback/discounts at partner brands (Swiggy, Amazon, Myntra, etc.)

---

## Part 1 — Inputs

### Full calculator (5 inputs)
| Input | Options |
|---|---|
| Income bracket | `<6L / 6–10L / 10–18L / 18–30L / >30L` per year |
| Age bucket | `18–23 / 24–30 / 31–35 / 35+` |
| Marital status | `Single / Married` |
| Spend style | `UPI_SMALL_CC_BIG / ALL_CC / ALL_UPI` |
| Favourite brands | Multi-select (optional) |

### Lite / onboarding calculator (2 inputs)
| Input | Options |
|---|---|
| Monthly income | `<₹30k / ₹30–50k / ₹50–1.25L / ₹1.25–2L / >₹2L` |
| Age bucket | `18–23 / 24–30 / 31–35 / 35+` |

**Fixed assumptions for lite version:**
Marital = Single · Spend style = UPI for daily, card for big buys · No brand preferences

---

## Part 2 — Fixed Constants

```js
const INCOME_MONTHLY = {
  i1: 35_000,   // < ₹30k bracket midpoint
  i2: 65_000,   // ₹30–50k
  i3: 1_10_000, // ₹50–1.25L
  i4: 2_00_000, // ₹1.25–2L
  i5: 3_00_000, // > ₹2L
};

const BASE_SPEND_RATIO = {
  i1: 0.70,  // spends 70% of income
  i2: 0.62,
  i3: 0.55,
  i4: 0.48,
  i5: 0.42,
};

// Yield math
const MULTIPL_RATE  = 0.07;   // 7% annualised liquid fund yield
const BANK_RATE     = 0.025;  // 2.5% typical savings account rate
const RATE_DIFF     = 0.045;  // MULTIPL_RATE - BANK_RATE
const HOLDING_FACTOR = 0.5;   // avg balance held = 50% of annual spend (≈ 6 months)
```

---

## Part 3 — Step-by-Step Logic

### Step 1: Adjust spend ratio by persona

```js
let ratio = BASE_SPEND_RATIO[incomeBracket];

if (marital === 'married') ratio += 0.03;   // households spend slightly more
if (age === '18-23')       ratio -= 0.03;   // younger users spend less
if (age === '35+')         ratio += 0.02;   // older users spend more on groceries/family

ratio = clamp(ratio, 0.38, 0.72);           // hard bounds

const spendingBudgetMonthly = incomeMontly * ratio;
```

### Step 2: Subtract rent (where applicable)

Rent is included **only if** the user is:
- Not in the highest income bracket (`> ₹2L / month`), **AND**
- Not married (married users are assumed to have shared or owned housing)

```js
const includeRent = incomeBracket !== 'i5' && marital !== 'married';

if (includeRent) {
  // Seeded random between 15%–28% of spending budget
  const rentPct = 0.15 + seededRandom() * 0.13;
  rentMonthly   = round(spendingBudgetMonthly * rentPct, 'monthly');
  remainingMonthly = spendingBudgetMonthly - rentMonthly;
}
```

### Step 3: Allocate remaining budget to spend categories

```js
// Raw proportional shares (seeded random within bounds)
let foodShare   = 0.08 + rng() * 0.04;  // 8–12%  food delivery
let grocShare   = 0.10 + rng() * 0.06;  // 10–16% groceries / q-com
let shopShare   = 0.10 + rng() * 0.08;  // 10–18% shopping
let uberShare   = 0.04 + rng() * 0.04;  // 4–8%   rides
let travelShare = 0.03 + rng() * 0.05;  // 3–8%   flights / hotels

// Age & marital adjustments
if (age === '18-23') { foodShare *= 1.15; travelShare *= 0.80; }
if (age === '35+')   { grocShare *= 1.15; foodShare   *= 0.90; }
if (marital === 'married') { grocShare *= 1.15; shopShare *= 0.85; }

// Normalise so shares sum to 1
normalize(foodShare, grocShare, shopShare, uberShare, travelShare);
```

### Step 4: Apply per-category caps (prevents unrealistic amounts for high earners)

Without caps, a ₹3L/month earner could get ₹50k/month in Zepto — obviously wrong.

```js
const CAP = { food: 10_000, groceries: 14_000, uber: 8_000 };
// (shopping and travel have no caps — they genuinely scale with income)

const foodMonthly  = Math.min(rawFood,  CAP.food);
const grocMonthly  = Math.min(rawGroc,  CAP.groceries);
const uberMonthly  = Math.min(rawUber,  CAP.uber);

// Redistribute capped surplus → shopping (70%) + travel (30%)
const surplus = (rawFood - foodMonthly) + (rawGroc - grocMonthly) + (rawUber - uberMonthly);
const shopMonthly   = rawShop  + surplus * 0.70;
const travelMonthly = rawTravel + surplus * 0.30;
```

### Step 5: Assign brands to each category

```js
// Food: one of Swiggy / Zomato (user preference, or seeded pick)
// Groceries: one of Zepto / Amazon Fresh
// Shopping: Amazon always + 1 fashion brand (Myntra/Ajio/Nykaa/Decathlon/etc.)
//   High income (i4/i5): 3–5 brands incl. Tata Cliq Luxury, Ajio Luxe
// Uber: always included
// Travel: MakeMyTrip Flights or Hotels (sometimes both for i4/i5)
```

**Shopping frequency by income** (seeded):

| Bracket | Monthly | Quarterly |
|---|---|---|
| `< ₹50k` | 20% chance | 80% chance |
| `₹50–1.25L` | 35% | 65% |
| `> ₹1.25L` | 50% | 50% |

Travel is yearly by default; quarterly ~35% of the time for `i4/i5`.

### Step 6: Amount rounding (keeps numbers human)

```js
function roundAmount(amount, frequency) {
  if (frequency === 'monthly')   return Math.max(500,  round(amount, 100));
  if (frequency === 'quarterly') return Math.max(2000, round(amount, 500));
  /* yearly */                   return Math.max(5000, round(amount, 1000));
}
```

### Step 7: Per-row calculation

```js
// For each spend row:
const annualSpend   = amount * periodsPerYear(frequency);
const brandSavings  = annualSpend * discountRate;          // brand-specific rate
const extraYield    = annualSpend * HOLDING_FACTOR * RATE_DIFF;
//                  = annualSpend * 0.5 * 0.045
//                  = annualSpend * 0.0225
```

### Step 8: Totals

```js
const totalAnnualSpend  = sum(annualSpend_i);
const totalBrandSavings = sum(brandSavings_i);
const totalYieldUplift  = sum(extraYield_i);
const totalSavings      = totalBrandSavings + totalYieldUplift;

const recommendedBalance = totalAnnualSpend * HOLDING_FACTOR;  // ≈ 6 months
const bankInterest       = recommendedBalance * BANK_RATE;
const multiplInterest    = recommendedBalance * MULTIPL_RATE;
```

---

## Part 4 — Brand Discount Rates

Internal rates. Replace with live rates when available.

| Brand | Discount |
|---|---|
| Swiggy, Zomato, Zepto, Amazon Fresh | 5% |
| Amazon, Flipkart | 2% |
| Tata Cliq, Nykaa, Ajio, Myntra, Decathlon | 6% |
| Tata Cliq Luxury, Ajio Luxe | 6% |
| MakeMyTrip Flights | 6% |
| MakeMyTrip Hotels | 10% |
| Uber | 5% |
| Tanishq, Kalyan Jewellers, Malabar Gold | 0% (no live rate yet) |
| Rent Payment, Credit Card Bill Payment | 0% |

---

## Part 5 — Seeded Randomness

The same persona always produces the same spend mix. This prevents the output changing on every page load and makes results feel stable and trustworthy.

```js
// Mulberry32 — fast, good distribution, deterministic
function mulberry32(seed) {
  return function () {
    seed |= 0;
    seed = (seed + 0x6D2B79F5) | 0;
    let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

// Seed = hash of (income + age + marital + spendStyle)
function hashPersona(p) {
  const s = `${p.income}${p.age}${p.marital}${p.spendStyle}`;
  let h = 0;
  for (let i = 0; i < s.length; i++) {
    h = Math.imul(31, h) + s.charCodeAt(i) | 0;
  }
  return Math.abs(h);
}
```

---

## Part 6 — Example Outputs

### ICP "Arjit" — Mid-career, single

| Input | Value |
|---|---|
| Income | ₹50–80k/mo (i3) |
| Age | 24–30 |
| Marital | Single |
| Spend style | UPI daily, card for big |

| Output | Value |
|---|---|
| Spending budget/mo | ~₹60,500 |
| Recommended balance | ~₹3.6L |
| Yield uplift/year | ~₹16,200 |
| Brand savings/year | ~₹8,400 |
| **Total extra/year** | **~₹24,600** |

### ICP "Priya" — Senior, married

| Input | Value |
|---|---|
| Income | ₹1.25–2L/mo (i4) |
| Age | 31–35 |
| Marital | Married |

| Output | Value |
|---|---|
| Spending budget/mo | ~₹1,02,000 |
| Recommended balance | ~₹6.1L |
| Yield uplift/year | ~₹27,500 |
| Brand savings/year | ~₹14,200 |
| **Total extra/year** | **~₹41,700** |

---

## Part 7 — Editable Spend Mix (full calculator only)

Users can edit any row after the analysis is shown:
- **Tap amount** → inline number input → blur/enter saves
- **Tap frequency badge** (`/mo`, `/qtr`, `/yr`) → cycles to next
- **× button** → deletes row
- **+ Add spend** → bottom sheet grouped by category

Every edit immediately recalculates all totals. State persists in `localStorage` so the same result is shown on page reload.

---

## Part 8 — Assumptions & Limitations

1. **7% yield is illustrative** — actual liquid fund returns vary. SEBI requires "market-linked and not guaranteed" disclaimer (shown on both calculators).
2. **Discount rates are internal estimates** — actual rates may differ when live brand partnerships are active.
3. **Holding factor = 0.5** — assumes the user's average balance is ~50% of annual spend (money flows in and out). This is conservative.
4. **No tax treatment** — liquid fund gains above ₹1L/year attract LTCG. The calculator shows gross uplift only.
5. **No credit card rewards modelled** — the calculator doesn't net out points/cashback the user currently earns on their CC. Conservative in Multipl's favour.
6. **Rent included by default for single users** — increases total spend (and therefore total yield) but earns 0% brand discount. Reflects reality but slightly inflates the recommended balance.

---

## Copy this engine

The complete JavaScript implementation (ready to drop into any project):

```js
// ─────────────────────────────────────────────────
// MULTIPL SPEND CALCULATOR ENGINE  v1.0
// Copy this block. No dependencies.
// ─────────────────────────────────────────────────

const INCOME_MONTHLY  = { i1:35000, i2:65000, i3:110000, i4:200000, i5:300000 };
const BASE_RATIO      = { i1:0.70, i2:0.62, i3:0.55, i4:0.48, i5:0.42 };
const MULTIPL_RATE = 0.07, BANK_RATE = 0.025, RATE_DIFF = 0.045, HOLDING = 0.5;
const CAP = { food: 10000, groc: 14000, uber: 8000 };

const DISCOUNT = {
  'Swiggy':0.05, 'Zomato':0.05, 'Zepto':0.05, 'Amazon Fresh':0.05,
  'Amazon':0.02, 'Flipkart':0.02,
  'Tata Cliq':0.06, 'Nykaa':0.06, 'Ajio':0.06, 'Myntra':0.06, 'Decathlon':0.06,
  'Tata Cliq Luxury':0.06, 'Ajio Luxe':0.06,
  'Tanishq':0, 'Kalyan Jewellers':0, 'Malabar Gold':0,
  'MakeMyTrip Flights':0.06, 'MakeMyTrip Hotels':0.10, 'Uber':0.05,
  'Rent Payment':0, 'Credit Card Bill Payment':0,
};

function periodsPerYear(freq) {
  return freq === 'monthly' ? 12 : freq === 'quarterly' ? 4 : 1;
}

function roundAmount(amount, freq) {
  if (freq === 'monthly')   { return Math.max(500,  Math.round(amount / 100)  * 100); }
  if (freq === 'quarterly') { return Math.max(2000, Math.round(amount / 500)  * 500); }
  return                             Math.max(5000, Math.round(amount / 1000) * 1000);
}

// Deterministic RNG — same inputs always produce same spend mix
function mulberry32(seed) {
  return function () {
    seed |= 0; seed = (seed + 0x6D2B79F5) | 0;
    let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function hashPersona(p) {
  const s = `${p.income}${p.age}${p.marital}${p.spendStyle}`;
  let h = 0;
  for (let i = 0; i < s.length; i++) h = (Math.imul(31, h) + s.charCodeAt(i)) | 0;
  return Math.abs(h);
}

/**
 * Generate a realistic spend mix for the given persona.
 * @param {object} p  { income: 'i1'–'i5', age: '18-23'|'24-30'|'31-35'|'35+',
 *                      marital: 'single'|'married', spendStyle: string, brands: string[] }
 * @returns {Array<{ id, brand, amount, freq, discount }>}
 */
function generateSpendRows(p) {
  const rng = mulberry32(hashPersona(p));
  let ratio = BASE_RATIO[p.income];
  if (p.marital === 'married') ratio += 0.03;
  if (p.age === '18-23')       ratio -= 0.03;
  if (p.age === '35+')         ratio += 0.02;
  ratio = Math.min(0.72, Math.max(0.38, ratio));

  const spendMonthly = INCOME_MONTHLY[p.income] * ratio;
  let remaining = spendMonthly;
  const rows = [];
  let id = 0;

  // Rent
  const includeRent = p.income !== 'i5' && p.marital !== 'married';
  if (includeRent) {
    const rent = roundAmount(spendMonthly * (0.15 + rng() * 0.13), 'monthly');
    rows.push({ id: id++, brand: 'Rent Payment', amount: rent, freq: 'monthly', discount: 0 });
    remaining -= rent;
  }

  // Category shares
  let fs = 0.08 + rng()*0.04, gs = 0.10 + rng()*0.06,
      ss = 0.10 + rng()*0.08, us = 0.04 + rng()*0.04, ts = 0.03 + rng()*0.05;
  if (p.age === '18-23') { fs *= 1.15; ts *= 0.8; }
  if (p.age === '35+')   { gs *= 1.15; fs *= 0.9; }
  if (p.marital === 'married') { gs *= 1.15; ss *= 0.85; }
  const ct = fs+gs+ss+us+ts;
  fs/=ct; gs/=ct; ss/=ct; us/=ct; ts/=ct;

  // Caps + surplus redistribution
  const rawF = remaining*fs, rawG = remaining*gs,
        rawS = remaining*ss, rawU = remaining*us, rawT = remaining*ts;
  const capF = Math.min(rawF, CAP.food), capG = Math.min(rawG, CAP.groc), capU = Math.min(rawU, CAP.uber);
  const surplus = (rawF-capF) + (rawG-capG) + (rawU-capU);
  const shopM = rawS + surplus*0.7, travelM = rawT + surplus*0.3;

  // Food
  const favs = p.brands || [];
  const foodBrand = favs.includes('Swiggy') ? 'Swiggy'
                  : favs.includes('Zomato') ? 'Zomato'
                  : rng() < 0.5 ? 'Swiggy' : 'Zomato';
  rows.push({ id:id++, brand:foodBrand, amount:roundAmount(capF,'monthly'), freq:'monthly', discount:0.05 });

  // Groceries
  const grocBrand = favs.includes('Zepto') ? 'Zepto'
                  : favs.includes('Amazon Fresh') ? 'Amazon Fresh'
                  : rng() < 0.55 ? 'Zepto' : 'Amazon Fresh';
  rows.push({ id:id++, brand:grocBrand, amount:roundAmount(capG,'monthly'), freq:'monthly', discount:0.05 });

  // Shopping
  const hi = p.income === 'i4' || p.income === 'i5';
  const shopFreqChance = { i1:0.20, i2:0.20, i3:0.35, i4:0.50, i5:0.50 };
  const shopFreq = rng() < shopFreqChance[p.income] ? 'monthly' : 'quarterly';
  const fashionList = ['Myntra','Ajio','Nykaa','Decathlon','Tata Cliq','Flipkart'];
  if (hi) {
    const brands = ['Amazon','Tata Cliq Luxury','Ajio Luxe',
                    fashionList[Math.floor(rng()*fashionList.length)]];
    const maxShare = p.income === 'i5' ? 0.35 : 0.45;
    brands.forEach((b, i) => {
      const share = i === 0 ? maxShare : (1-maxShare) / (brands.length-1);
      rows.push({ id:id++, brand:b, amount:roundAmount(shopM*12*share/periodsPerYear(shopFreq), shopFreq), freq:shopFreq, discount:DISCOUNT[b]||0 });
    });
  } else {
    const amazonShare = 0.55 + rng()*0.05;
    const fashionPick = fashionList[Math.floor(rng()*fashionList.length)];
    rows.push({ id:id++, brand:'Amazon',    amount:roundAmount(shopM*12*amazonShare/periodsPerYear(shopFreq), shopFreq), freq:shopFreq, discount:0.02 });
    rows.push({ id:id++, brand:fashionPick, amount:roundAmount(shopM*12*(1-amazonShare)/periodsPerYear(shopFreq), shopFreq), freq:shopFreq, discount:DISCOUNT[fashionPick]||0 });
  }

  // Uber
  rows.push({ id:id++, brand:'Uber', amount:roundAmount(capU,'monthly'), freq:'monthly', discount:0.05 });

  // Travel
  const travelFreq = hi && rng()<0.35 ? 'quarterly' : 'yearly';
  const bothMMT = hi && rng()<0.4;
  if (bothMMT || favs.includes('MakeMyTrip')) {
    rows.push({ id:id++, brand:'MakeMyTrip Flights', amount:roundAmount(travelM*12*0.6/periodsPerYear(travelFreq), travelFreq), freq:travelFreq, discount:0.06 });
    rows.push({ id:id++, brand:'MakeMyTrip Hotels',  amount:roundAmount(travelM*12*0.4/periodsPerYear(travelFreq), travelFreq), freq:travelFreq, discount:0.10 });
  } else {
    const mmtBrand = rng()<0.6 ? 'MakeMyTrip Flights' : 'MakeMyTrip Hotels';
    rows.push({ id:id++, brand:mmtBrand, amount:roundAmount(travelM*12/periodsPerYear(travelFreq), travelFreq), freq:travelFreq, discount:DISCOUNT[mmtBrand] });
  }

  return rows;
}

/**
 * Calculate total savings from a spend rows array.
 * @param {Array} rows  Output from generateSpendRows()
 * @returns {{ totalAnnualSpend, totalBrandSavings, totalYieldUplift, totalSavings,
 *             recommendedBalance, bankInterest, multiplInterest }}
 */
function calculateTotals(rows) {
  let totalAnnualSpend = 0, totalBrandSavings = 0, totalYieldUplift = 0;
  for (const r of rows) {
    const ann = r.amount * periodsPerYear(r.freq);
    totalAnnualSpend  += ann;
    totalBrandSavings += ann * (r.discount || 0);
    totalYieldUplift  += ann * HOLDING * RATE_DIFF;
  }
  const totalSavings       = totalBrandSavings + totalYieldUplift;
  const recommendedBalance = totalAnnualSpend * HOLDING;
  const bankInterest       = recommendedBalance * BANK_RATE;
  const multiplInterest    = recommendedBalance * MULTIPL_RATE;
  return { totalAnnualSpend, totalBrandSavings, totalYieldUplift,
           totalSavings, recommendedBalance, bankInterest, multiplInterest };
}

// Usage example
const persona = { income:'i3', age:'24-30', marital:'single', spendStyle:'UPI_SMALL_CC_BIG', brands:[] };
const rows   = generateSpendRows(persona);
const totals = calculateTotals(rows);
console.log(`Estimated extra savings: ₹${totals.totalSavings.toLocaleString('en-IN')} / year`);
```

---

*Disclaimer: All figures are illustrative. Multipl liquid fund returns are market-linked and not guaranteed. Actual brand discount rates may differ from internal estimates used here.*
