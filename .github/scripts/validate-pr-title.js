const nlp = require('compromise');
const title = process.env.PR_TITLE || '';

let isValidTitle = true;

function logSuccess(message) {
  console.log(`✅ ${message}`);
}

function logFailure(message) {
  isValidTitle = false;
  console.error(`❌ ${message}`);
}

function capitalized(string) {
  if (!string) return '';
  return string[0].toUpperCase() + string.substring(1);
}

// Rule 1: PR title must not be empty
if (title) {
  logSuccess(`PR title is not empty`);
} else {
  logFailure(`PR title must not be empty`);
}

// Rule 2: PR title must be 72 characters or less
if (title.length <= 72) {
  logSuccess(`PR title is ${title.length} characters`);
} else {
  logFailure(`PR title must be 72 characters or less (currently ${title.length} characters)`);
}

// Rule 3: PR title must begin with a capital letter
if (/^[A-Z]/.test(title)) {
  logSuccess(`PR title begins with a capital letter`);
} else {
  logFailure('PR title must begin with a capital letter');
}

// Rule 4: PR title must end with a letter or number
if (/[A-Za-z0-9]$/.test(title)) {
  logSuccess(`PR title ends with a letter or number`);
} else {
  logFailure('PR title must end with a letter or number');
}

// Rule 5: PR title must be written in the imperative.
//
// The intent is to catch non-imperative conjugations ("Adds", "Added", "Adding",
// "Fixed") and steer them to the imperative ("Add", "Fix"). We use compromise's NLP to
// find the first word's infinitive and require the first word to match it.
//
// Two important details:
//   1. We parse the FULL title, not just the first word. compromise tags words far more
//      accurately with sentence context — e.g. in isolation it tags "Fixed" as an
//      adjective and misses it, but in "Fixed the bug" it correctly infinitives to "fix".
//      Parsing the whole title is what lets us catch past-tense forms.
//   2. When compromise cannot resolve an infinitive (empty result), the first word is a
//      verb it does not know (e.g. "Backfill", "Setup"). We give those the benefit of the
//      doubt rather than blocking a valid imperative the library simply doesn't recognize.
//
// IMPERATIVE_ALLOWLIST is an escape hatch for the rare verb compromise mangles (it turns
// "Embed" into "emb"). If a legitimate imperative verb is ever wrongly rejected, add its
// lowercase form here.
const IMPERATIVE_ALLOWLIST = ['embed'];

const firstWord = title.split(' ')[0];
const firstWordLowercased = firstWord.toLowerCase();
const firstWordCapitalized = capitalized(firstWord);
const firstWordAsImperativeVerb = nlp(title).terms().first().verbs().toInfinitive().out('text');
const firstWordAsImperativeVerbLowercased = firstWordAsImperativeVerb.toLowerCase();
const firstWordAsImperativeVerbCapitalized = capitalized(firstWordAsImperativeVerb);

if (
  IMPERATIVE_ALLOWLIST.includes(firstWordLowercased) ||
  !firstWordAsImperativeVerb ||
  firstWordLowercased === firstWordAsImperativeVerbLowercased
) {
  logSuccess(`PR title is written in the imperative`);
} else {
  logFailure(`PR title must be written in the imperative ("${firstWordAsImperativeVerbCapitalized}" instead of "${firstWordCapitalized}")`);
}

if (!isValidTitle) {
  process.exit(1);
}
