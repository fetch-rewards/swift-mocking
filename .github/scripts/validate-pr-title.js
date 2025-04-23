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

// Rule 5: PR title must be written in the imperative
const firstWord = title.split(' ')[0];
const firstWordLowercased = firstWord.toLowerCase();
const firstWordCapitalized = capitalized(firstWord);
const firstWordAsImperativeVerb = nlp(firstWord).verbs().toInfinitive().out('text');
const firstWordAsImperativeVerbLowercased = firstWordAsImperativeVerb.toLowerCase();
const firstWordAsImperativeVerbCapitalized = capitalized(firstWordAsImperativeVerb);

if (firstWordLowercased === firstWordAsImperativeVerbLowercased) {
  logSuccess(`PR title is written in the imperative`);
} else if (firstWordAsImperativeVerb) {
  logFailure(`PR title must be written in the imperative ("${firstWordAsImperativeVerbCapitalized}" instead of "${firstWordCapitalized}")`);
} else {
  logFailure(`PR title must begin with a verb and be written in the imperative`);
}

if (!isValidTitle) {
  process.exit(1);
}
