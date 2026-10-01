const fs = require('fs');
const path = require('path');
const vm = require('vm');

const stateCode = fs.readFileSync(path.join(__dirname, '../js/state.js'), 'utf8');
const appCode = fs.readFileSync(path.join(__dirname, '../js/app.js'), 'utf8');
const custCode = fs.readFileSync(path.join(__dirname, '../js/customer.js'), 'utf8');
const ownerCode = fs.readFileSync(path.join(__dirname, '../js/owner.js'), 'utf8');
const adminCode = fs.readFileSync(path.join(__dirname, '../js/admin.js'), 'utf8');
const dataCode = fs.readFileSync(path.join(__dirname, '../js/data.js'), 'utf8');

const context = {
  addEventListener: () => {},
  window: { addEventListener: () => {} },
  document: {
    addEventListener: (evt, fn) => { if (evt === 'DOMContentLoaded') fn(); },
    getElementById: () => ({ value: '1', style: {}, classList: { toggle: () => {} } }),
    querySelectorAll: () => [],
    createElement: () => ({ setAttribute: () => {}, appendChild: () => {}, style: {} }),
    body: {
      appendChild: () => {},
      setAttribute: () => {},
      removeAttribute: () => {},
      classList: { add: () => {}, remove: () => {} },
      insertAdjacentHTML: () => {}
    }
  },
  localStorage: {
    getItem: () => null,
    setItem: () => {}
  },
  console: console,
  setTimeout: setTimeout,
  clearTimeout: clearTimeout,
  alert: (msg) => console.log('Alert:', msg),
  confirm: () => true
};
context.window = context;

vm.createContext(context);
vm.runInContext(dataCode, context);
vm.runInContext(stateCode, context);
vm.runInContext(custCode, context);
vm.runInContext(ownerCode, context);
vm.runInContext(adminCode, context);
vm.runInContext(appCode, context);

const app = context.window.appCoordinator;
const admin = app.adminApp;
const cust = app.customerApp;
const owner = app.ownerApp;

console.log('Testing all sections rendering...');
const sections = admin.getSidebarMenuItems().map(m => m.id);

sections.forEach(secId => {
  admin.activeSection = secId;
  const html = admin.getSectionHTML();
  if (!html || html.length === 0) {
    console.error(`❌ Section ${secId} returned empty HTML!`);
  } else {
    console.log(`✅ Section ${secId} rendered (${html.length} chars)`);
  }
});

console.log('\nTesting Customer tabs rendering...');
['home', 'search', 'saved', 'rentals', 'profile'].forEach(tab => {
  cust.currentTab = tab;
  const html = cust.getTabContentHTML();
  console.log(`✅ Customer Tab ${tab} rendered (${html.length} chars)`);
});

console.log('\nTesting Owner tabs rendering...');
['dashboard', 'properties', 'requests', 'rent', 'profile'].forEach(tab => {
  owner.currentTab = tab;
  const html = owner.getTabContentHTML();
  console.log(`✅ Owner Tab ${tab} rendered (${html.length} chars)`);
});
