const fs = require('fs');
const path = require('path');

const stateCode = fs.readFileSync(path.join(__dirname, '../js/state.js'), 'utf8');
const appCode = fs.readFileSync(path.join(__dirname, '../js/app.js'), 'utf8');
const custCode = fs.readFileSync(path.join(__dirname, '../js/customer.js'), 'utf8');
const ownerCode = fs.readFileSync(path.join(__dirname, '../js/owner.js'), 'utf8');
const adminCode = fs.readFileSync(path.join(__dirname, '../js/admin.js'), 'utf8');
const dataCode = fs.readFileSync(path.join(__dirname, '../js/data.js'), 'utf8');

// Load environment in VM
const vm = require('vm');
const context = {
  window: {
    addEventListener: () => {}
  },
  document: {
    addEventListener: (evt, fn) => { if (evt === 'DOMContentLoaded') fn(); },
    getElementById: () => null,
    querySelectorAll: () => [],
    createElement: () => ({ setAttribute: () => {}, appendChild: () => {}, style: {} }),
    body: { appendChild: () => {}, setAttribute: () => {}, removeAttribute: () => {}, classList: { add: () => {}, remove: () => {} } }
  },
  localStorage: {
    getItem: () => null,
    setItem: () => {}
  },
  console: console,
  setTimeout: setTimeout,
  clearTimeout: clearTimeout
};
context.window = context;
context.window.addEventListener = () => {};

vm.createContext(context);
vm.runInContext(dataCode, context);
vm.runInContext(stateCode, context);
vm.runInContext(custCode, context);
vm.runInContext(ownerCode, context);
vm.runInContext(adminCode, context);
vm.runInContext(appCode, context);

const appCoord = context.window.appCoordinator;
const cust = appCoord.customerApp;
const owner = appCoord.ownerApp;
const admin = appCoord.adminApp;
const state = appCoord.state;

console.log('CustomerApp methods count:', Object.getOwnPropertyNames(Object.getPrototypeOf(cust)).length);
console.log('OwnerApp methods count:', Object.getOwnPropertyNames(Object.getPrototypeOf(owner)).length);
console.log('AdminApp methods count:', Object.getOwnPropertyNames(Object.getPrototypeOf(admin)).length);

// Check missing calls in all JS files
const allFiles = [
  { name: 'customer.js', code: custCode },
  { name: 'owner.js', code: ownerCode },
  { name: 'admin.js', code: adminCode },
  { name: 'app.js', code: appCode },
  { name: 'index.html', code: fs.readFileSync(path.join(__dirname, '../index.html'), 'utf8') }
];

const patterns = [
  { prefix: 'window.customerApp.', obj: cust, objName: 'CustomerAppController' },
  { prefix: 'window.ownerApp.', obj: owner, objName: 'OwnerAppController' },
  { prefix: 'window.adminApp.', obj: admin, objName: 'AdminAppController' },
  { prefix: 'window.appCoordinator.', obj: appCoord, objName: 'AppCoordinator' },
  { prefix: 'window.appState.', obj: state, objName: 'AppState' }
];

let issuesFound = 0;

allFiles.forEach(file => {
  patterns.forEach(p => {
    const regex = new RegExp(p.prefix.replace(/\./g, '\\.') + '([a-zA-Z0-9_]+)', 'g');
    let match;
    while ((match = regex.exec(file.code)) !== null) {
      const methodName = match[1];
      if (typeof p.obj[methodName] !== 'function') {
        console.error(`❌ Missing method: ${p.objName}.${methodName} called in ${file.name}`);
        issuesFound++;
      }
    }
  });
});

if (issuesFound === 0) {
  console.log('✅ No missing method references found!');
} else {
  console.log(`❌ Found ${issuesFound} missing method calls.`);
}
