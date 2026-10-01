/**
 * End-to-End UI and Flow Verification Script
 * Validates Login, Role Switching, Customer Flows, Owner Flows & Admin Operations
 */

const assert = require('assert');
const { INITIAL_DATABASE } = require('../js/data.js');

// Mock DOM & Storage environment
const storageMock = {};
global.localStorage = {
  getItem: (key) => storageMock[key] || null,
  setItem: (key, val) => { storageMock[key] = String(val); },
  removeItem: (key) => { delete storageMock[key]; },
  clear: () => { Object.keys(storageMock).forEach(k => delete storageMock[k]); }
};

global.window = {
  INITIAL_DATABASE
};

const { AppState } = require('../js/state.js');

console.log('🚀 Running Comprehensive End-to-End Flow Check...\n');

const state = new AppState();

// 1. Initial State: Authentication Check
console.log('1. Checking Initial Authentication State...');
assert.strictEqual(typeof state.login, 'function', 'state.login must be a function');
assert.strictEqual(typeof state.logout, 'function', 'state.logout must be a function');
console.log('✅ Auth methods available.');

// 2. Customer Login Flow
console.log('\n2. Testing Customer Login...');
state.login('CUSTOMER', 'cust_1');
assert.strictEqual(state.isAuthenticated, true, 'User must be authenticated');
assert.strictEqual(state.currentRole, 'CUSTOMER', 'Role must be CUSTOMER');
assert.strictEqual(state.currentUserId, 'cust_1', 'User ID must be cust_1');
const currentCustomer = state.getCurrentUser();
assert.strictEqual(currentCustomer.name, 'Amit Sharma', 'Current customer must be Amit Sharma');
console.log(`✅ Logged in as: ${currentCustomer.name} (${currentCustomer.role})`);

// 3. Customer Search & Request Flow
console.log('\n3. Testing Customer Search & Request Workflow...');
state.setSearchFilters({ areaType: 'urban', city: 'Varanasi', suitableFor: ['working_professional'], maxRent: 50000, onlyAvailable: true });
const searchResults = state.getSearchResults();
assert.strictEqual(searchResults.length > 0, true, 'Search must return matching units');
const targetRoom = searchResults[0];
console.log(`Found target unit: ${targetRoom.property.title} - ${targetRoom.room.roomNumber} (Rent: ₹${targetRoom.room.monthlyRent})`);

// Customer sends rental request
const req = state.createRentalRequest({
  propertyId: targetRoom.property.id,
  roomId: targetRoom.room.id,
  customerId: currentCustomer.id,
  customerType: currentCustomer.customerType || 'Working Professional',
  monthlyRent: targetRoom.room.monthlyRent,
  securityDeposit: targetRoom.room.securityDeposit,
  message: 'Looking for a 1-year rental lease.'
});
assert.strictEqual(req.status, 'Pending', 'Rental request must start as Pending');
console.log(`✅ Rental Request #${req.id} created successfully.`);

// 4. Owner Login & Approval Flow
console.log('\n4. Testing Owner Login & Request Review...');
state.login('OWNER', 'owner_1');
assert.strictEqual(state.currentRole, 'OWNER', 'Role must be OWNER');
const currentOwner = state.getCurrentUser();
console.log(`✅ Logged in as Owner: ${currentOwner.name}`);

// Owner reviews inquiries
const ownerRequests = state.data.rentalRequests.filter(r => r.ownerId === currentOwner.id);
assert.strictEqual(ownerRequests.some(r => r.id === req.id), true, 'Owner must see pending request');

// Owner accepts inquiry
state.ownerRespondToRequest(req.id, 'ACCEPT');
const updatedReq = state.data.rentalRequests.find(r => r.id === req.id);
assert.strictEqual(updatedReq.status, 'Accepted', 'Request must be Accepted');
console.log('✅ Owner successfully accepted the rental request.');

// 5. Customer Finalizes Agreement & e-KYC
console.log('\n5. Testing Customer Final Terms & Aadhaar e-KYC...');
state.login('CUSTOMER', 'cust_1');
state.performAadhaarKYC('cust_1', '987654321012', '123456');
const cust = state.data.users.find(u => u.id === 'cust_1');
assert.strictEqual(cust.aadhaarVerified, true, 'Aadhaar e-KYC must succeed');

// Finalize agreement -> Active Tenancy
const agreementRes = state.completeRentalAgreement(req.id);
assert.strictEqual(agreementRes.activeRental.status, 'Active', 'Active tenancy must be created');
console.log(`✅ Agreement finalized! Active Tenancy #${agreementRes.activeRental.id} created.`);

// Verify property status changed to Rented
const rentedRoom = state.data.properties.find(p => p.id === targetRoom.property.id).rooms.find(r => r.id === targetRoom.room.id);
assert.strictEqual(rentedRoom.status, 'Rented', 'Room status must be Rented');
console.log('✅ Property status automatically changed to Rented.');

// 6. Monthly Rent Payment & Receipt
console.log('\n6. Testing Monthly Rent Payment & Receipt Generation...');
const pendingPayment = state.data.rentPayments.find(p => p.rentalId === agreementRes.activeRental.id);
const payRes = state.recordRentPayment({
  paymentId: pendingPayment.id,
  paymentMode: 'UPI',
  transactionRef: 'UPI-TEST-998877'
});
assert.strictEqual(payRes.paymentStatus, 'Paid', 'Payment status must be Paid');
assert.strictEqual(typeof payRes.receiptNumber, 'string', 'Receipt number must be generated');
console.log(`✅ Rent Paid! Generated Digital Receipt: #${payRes.receiptNumber}`);

// 7. Admin Login & Governance Suite
console.log('\n7. Testing Admin Login & Governance Control...');
state.login('ADMIN', 'admin_1');
assert.strictEqual(state.currentRole, 'ADMIN', 'Role must be ADMIN');
console.log('✅ Logged in to Admin Control Center.');

// Admin verifies Ledger & Audit Trail
const ledger = state.data.rentPayments;
assert.strictEqual(ledger.length > 0, true, 'Admin ledger must contain rent transactions');
const auditLogs = state.data.auditLogs;
assert.strictEqual(auditLogs.length > 0, true, 'Audit logs must capture events');
console.log(`✅ Admin Ledger contains ${ledger.length} transactions, Audit Trail has ${auditLogs.length} events.`);

// 8. Logout Flow
console.log('\n8. Testing Logout...');
state.logout();
assert.strictEqual(state.isAuthenticated, false, 'User must be logged out');
console.log('✅ Logout successful! Returned to Login Portal.');

console.log('\n========================================================================');
console.log('🎉 ALL END-TO-END WORKFLOWS & FUNCTIONS ARE WORKING 100% PERFECTLY!');
console.log('========================================================================\n');
